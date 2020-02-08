{
    local BASE_URL = 'asdfasf',
    local OPERATION_TIME_LIMIT = '5s',

    'README.md': std.strReplace(importstr "README.md", "$OPERATION_TIME_LIMIT", OPERATION_TIME_LIMIT),
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
