{
    local BASE_URL = 'asdfasf',
    local OPERATION_TIME_LIMIT = '5s',
    local concernsOfASingleService = import "concerns-of-a-single-service.jsonnet",
    local SERVICE_NAME = 'Identity Management Service',
    SERVICE_NAME:: 'Identity Management Service',
    'Service name':: SERVICE_NAME,
    'content':: std.strReplace(importstr "README.md", "$OPERATION_TIME_LIMIT", OPERATION_TIME_LIMIT),
    'concernsOfASingleService':: "Name | Value | Description\n---|---|---\n" + std.join("\n",
    [ concern.name + " | "
    + (if std.objectHas(self, concern.name) then self[concern.name] else "")
    + " | " + concern.description
    for concern in concernsOfASingleService ]),

    'README.md': |||
         %(content)s
         %(SERVICE_NAME)s
         $[SERVICE_NAME]s

         ## Concerns of Service
         %(concernsOfASingleService)s
    ||| % self,
    'uc01.sequence.puml': importstr "uc01.sequence.puml",
    'uc02.sequence.puml': importstr "uc02.sequence.puml",
    'uc03.sequence.puml': importstr "uc03.sequence.puml",
    'uc04.sequence.puml': importstr "uc04.sequence.puml",
    'encryption.function.puml': importstr "encryption.function.puml",
    'decryption.function.puml': importstr "decryption.function.puml",
    'query-encrypted-users.function.puml': importstr "query-encrypted-users.function.puml",
    'idm.puml': importstr "idm.puml",
    'erd.puml': importstr "erd.puml",
    'use-cases.puml': importstr "use-cases.puml",
    'class.puml': importstr "class.puml",
}
