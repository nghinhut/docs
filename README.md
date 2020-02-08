# My Central Document Repository

[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC%20BY--NC--ND%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)
[![Netlify Status](https://api.netlify.com/api/v1/badges/acaf92bf-c37e-453f-b059-24d0f8e3c18f/deploy-status)](https://app.netlify.com/sites/nlmn-docs/deploys)
---

# Microservices
![](http://www.plantuml.com/plantuml/proxy?fmt=svg&src=https://gitlab.com/nghinhut/docs/raw/master/plantuml/MSA/msa.puml)

# UMA2
![](http://www.plantuml.com/plantuml/proxy?fmt=svg&src=https://gitlab.com/nghinhut/docs/raw/master/plantuml/UMA2/uma2-grant.puml)

# IdM
![](http://www.plantuml.com/plantuml/proxy?fmt=svg&src=https://gitlab.com/nghinhut/docs/raw/master/plantuml/IdM/idm.puml)

## Use cases
![](http://www.plantuml.com/plantuml/proxy?fmt=svg&src=https://gitlab.com/nghinhut/docs/raw/master/plantuml/IdM/use-case.puml)

<!-- Image Links -->
[www.plantuml.com]: http://www.plantuml.com/plantuml/proxy?src=
[plantuml.nghinhut.dev]: https://plantuml.nghinhut.dev/proxy?src=

# Document Development

In order to keeping persistence of constraints across multiple files in the same project,
I will update the jsonnet file to generate document instead actual change the document files.

There will be a single .jsonnet file for every project in this repository.

### Updating process
1. Modify document file(s)
1. Git commit & push
1. Build & Deployment (CI/CD)
    1. Data Binding

        Example build **IdM** documents
        ```
        ./scripts/jsonnet.sh idm/idm.jsonnet -S -m out/idm
        ```
        Jsonnet will binding all needed variables into document files
    2. PlantUML build
        
        ```
        ./scripts/plantuml-build.sh
        ```      
    
