---
title: "GitLab Auto DevOps"
date: 2019-10-29
image: "/assets/img/bg8.jpg"
author: Nghi L. M. Nhựt (nghinhut@gmail.com)
readingTime: "10"
categories: "Software"
tags: "gitlab,devops,development"
---

### Deployment is time consuming
<br/><br/><br/>
### GitLab Auto DevOps come to rescue
Auto DevOps help you save a lot of time, avoid human errors and improve delivery time for your production especially when you doing agile.

<br/>
So, let's hop on!

<br/>
GitLab provides a Helm Chart called auto-deploy-app that already integrates with many GitLab's features. It's making deploy to Kubernetes using GitLab so much easy.

If you're not familiar with Kubernetes or Helm, then don't worry you don't need to. You only have to do a few steps as follow:

1. First, write Dockerfile for your application.
1. Second, configure your app to serving APIs at port 5000 (the default port specify in auto-deploy-app).
Also create an endpoint at path / (default path for healthcheck in auto-deploy-app)

<br/>
Your endpoint needs to response status-code 200 in order to keep your application running. Otherwise, Kubernetes will keep destroying your container replace by another after a few failed attempts.

If your application using a database then you should check your database connection if it's still good, otherwise if things go wrong just return 500, Kubernetes will restart your application. (Caution: need to use replication to minimize downtime)
<br/><br/><br/>


### Example
Your Dockerfile gonna look like this:
```dockerfile
    # Example Dockerfile for Node.js
    FROM node:12-alpine
    
    ENV PORT 5000
    
    COPY package*.json ./
    RUN npm install
    COPY . .
    
    CMD [ "npm", "start" ]
```

<br /><br />
### More...
For more info please read [GitLab Auto DevOps](https://docs.gitlab.com/ee/topics/autodevops/) documents.
