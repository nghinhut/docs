
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
image: "javascript:;"
author: "{{ .Site.Author.email }} ({{ .Site.Author.name }})"
categories: ""
tags: ""
draft: true
---

**Insert Lead paragraph here.**

<!--more-->

### New Cool Posts

{{ range first 10 ( where .Site.RegularPages "Type" "cool" ) }}
* {{ .Title }}
{{ end }}
