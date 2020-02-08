{
    local BASE_URL = 'asdfasf',
    local OPERATION_TIME_LIMIT = '5s',


    'README.md': |||
        All service function must not excced this limit: %s

        # Document Development
        Update the jsonnet file then exexcute following command (require docker)

        ```
        ./scripts/jsonnet.sh idm/idm.jsonnet -S -m idm
        ```
    ||| % OPERATION_TIME_LIMIT
    ,


    'uc01.sequence.puml': |||
        @startuml

        title Create A New User (UMA2 Protected)
        !pragma teoz true
        !$BASE_URL = "%s"

        participant "Client" as client
        participant "IdM Service" as idm
        participant "IdM Database" as db
        participant "UMA2 Authorization Server" as as
        participant "Encryption Service" as es

        activate client
        client ->> idm : client request permission ticket
        activate idm
            idm -> idm : createPermissionTicket()
            activate idm
                opt invalid or expired access token (PAT)
                    ref over idm, as
                        OAuth2 Client Credentials Grant
                    end
                end
                idm ->> as : create permission ticket with resource scopes: [ 'create-user' ]
                activate as
                deactivate as
                idm <<-- as
            deactivate idm

        client <<-- idm : 200 response { as_uri: ..., ticket: ... }
        deactivate idm

        {start_d1} client ->> idm : request create new user with access token (RPT)
        activate idm


        idm -> idm : tokenIntrospect()
        activate idm
            opt for additional validation\n(offer better security but increases request duration
                ref over idm, as
                    Introspect token with Authz Server
                end
            end
        deactivate idm


        idm -> idm : policyEnforce()
        activate idm
        deactivate idm


        loop for each attribute in user's attributes
            ref over idm, es
                Encrypt user's attribute by [[$BASE_URL/plantuml/IdM/encryption.function.puml Encryption($attribute)]]
            end
        end


        idm -> db : save()
            db -> db : INSERT ... INTO "[[$getBaseUrl()/plantuml/IdM/class.puml Users]]";
        idm <-- db : result

        {end_d1} client <<-- idm : return success response (empty body)
        deactivate client

        == Create Blind Indexing ==
        idm -> idm : createBlindIndex()
        activate idm
            loop for each attribute in ['username', 'email', 'first_name', 'last_name']
                idm -> idm : hash_hmac('sha256', $attribute, $masterKey)
            end
            idm -> db : updateBlindIndex()
                db -> db : INSERT ... INTO "[[$getBaseUrl()/plantuml/IdM/class.puml UsersFilters]]"
            idm <<-- db
        deactivate idm
        deactivate idm

        'Duration Constrains
        {start_d1} <-> {end_d1} : <5s
        @enduml
    ||| % '123',


    'uc02.sequence.puml': |||
        @startuml
        title Query Users

        participant "Client" as client
        participant "IdM Service" as idm
        participant "Shared Cache\n(optional)" as cache
        participant "Database" as db
        participant "UMA2 Authorization Server" as as
        participant "Encryption Service" as es

        ref over client, idm, as
            [[$getBaseUrl()/plantuml/IdM/create-permission-ticket.function.puml{} Create Permission Ticket]] with resources scopes = [ 'list-users' ]
        end

        client ->> idm : list users with limit & offset
        activate idm

        alt query by UUID (unprotected field) (cache first)
            idm -> cache : getCachedUserByUUID()
            activate cache
                idm <-- cache : cached user
            deactivate cache

            opt no cached user
                ref over idm, db
                    [[$getBaseUrl()/plantuml/IdM/query-encrypted-users.function.puml Query Encrypted Users]] by UUID
                end

                loop for each attribute in user's attributes
                    ref over idm, es
                        Decrypt user's attribute by [[$getBaseUrl()/plantuml/IdM/decryption.function.puml{} Decryption(attribute)]]
                    end

                    idm -> idm : userMsg.set(attribute //<decrypted>//, value)
                end
            end
        else search users (include protected fields) (Database first)
            ref over idm, db
                [[$getBaseUrl()/plantuml/IdM/query-encrypted-users.function.puml Query Encrypted Users]] from Database
            end

            loop for each user in users <//encrypted//>
                ref over idm, cache
                    getCachedUser()
                end
                opt if not cached
                    loop for each attribute in user's attributes
                        ref over idm, es
                            Decrypt user's attribute by [[$getBaseUrl()/plantuml/IdM/decryption.function.puml{} Decryption(attribute)]]
                        end

                        idm -> idm : userMsg.set(attribute //<decrypted>//, value)
                    end
                end
            end
        end

        client <<-- idm : send users

        deactivate idm
        @enduml
    |||,


    'uc03.sequence.puml': |||
        @startuml
        title Update User (UMA2 Protected)
        !pragma teoz true

        participant "Client" as client
        participant "IdM Service" as idm
        participant "Shared Cache\n(optional)" as cache
        participant "Database" as db
        participant "UMA2 Authorization Server" as as
        participant "Encryption Service" as es

        == Authorization ==
        activate client
        ref over client, idm, as
            [[$getBaseUrl()/plantuml/IdM/create-permission-ticket.function.puml{} Create Permission Ticket]] with resources scopes = [ 'update-user' ]
        end

        {start_d1} client ->> idm : request update user 197 with access token (RPT)
        note left
            userId: 197
            {
                ..
            }
        end note

        activate idm
        idm -> idm : tokenIntrospect()
        activate idm
            opt for additional validation\n(offer better security but increases request duration
                ref over idm, as
                    Introspect token with Authz Server
                end
            end
        deactivate idm


        idm -> idm : policyEnforce()


        == Updating ==
        ' Disable version(updated_at) check to reducing execute time (expect client to send valid request)
        'ref over idm
        '    [[$getBaseUrl()/plantuml/IdM/query-encrypted-users.function.puml Query Encrypted Users]] with id = 197
        'end
        'break updated_at (from db) != updated_at (from request)
        '    client <-- idm : Error conflict (HTTP Status 409 Conflict) -> Time conflict
        'end

        loop for each not null attribute in user's attributes (request)
            note right of idm
                Assume all not null fields received are those that need to change
                The change detection SHOULD be perform on client side to avoid adding costly change detection mechanics,
                or perform unnecessary encryption on server side,
                while also reducing network load
            end note

            ref over idm, es
                Encrypt user's attribute by [[$getBaseUrl()/plantuml/encryption.function.puml Encryption($attribute)]]
            end

            idm -> idm : user.setAttribute($attribute.key, $attribute.value //<encrypted>//)
        end


        'idm <<-- es
        'deactivate es

        idm -> db : save()
        note right of db
            UPDATE users
                SET ...
            WHERE userId = $1 AND updated_at = $2

            *note the updated_at acting like a version field (OCC)
        end note
        idm <-- db : result

        break the result is empty (unexpected user change)
            client <- idm : HTTP Status 409 Conflict -> User change conflict
        end

        {end_d1} client <<-- idm : return success response (empty body) (HTTP Status 204)
        deactivate client

        == Post-Update Tasks ==
        idm -> idm : prepare shared cache for later usage
        activate idm
        '    idm -> cache : deleteSharedCache()
        '    note right
        '        it's safer to delete shared cache first
        '        avoid conflict if adding failed
        '    end note
            ref over idm, cache
                Adding data to Shared Cache
            end
        deactivate idm


        idm -> idm : createBlindIndex()
        activate idm
            loop for each attribute in ['username', 'email', 'first_name', 'last_name']
                idm -> idm : hash_hmac('sha256', $attribute, $masterKey)
            end
            idm -> db : updateBlindIndex()
                db -> db : INSERT ... INTO "[[$getBaseUrl()/plantuml/class.puml UsersFilters]]"
            idm <<-- db
        deactivate idm

        deactivate idm


        'Duration Constrains
        {start_d1} <-> {end_d1} : <1s (the shorter the better)
        @enduml
    |||,
}
