
---
title: "Kubernetes Objects"
date: 2019-11-16T22:36:04+07:00
image: "javascript:;"
author: "nghinhut@gmail.com (Nghi L. M. Nhựt)"
categories: ""
tags: ""
draft: true
---

**Kubernetes defines a set of building blocks ("primitives"), which collectively provide mechanisms that deploy, maintain, and scale applications based on CPU, memory[14] or custom metrics.[15][^wiki]**

<!--more-->

### Kubernetes Objects[^wiki][^k8s-concept]
Kubernetes defines a set of building blocks ("primitives"), which collectively provide mechanisms that deploy, maintain, and scale applications based on CPU, memory[14] or custom metrics.[15] Kubernetes is loosely coupled and extensible to meet different workloads. This extensibility is provided in large part by the Kubernetes API, which is used by internal components as well as extensions and containers that run on Kubernetes.[16] The platform exerts its control over compute and storage resources by defining resources as Objects, which can then be managed as such. The key objects are:
#### Pods
#### Replica Sets
#### Services
#### Volumes
#### Namespaces
#### ConfigMaps and Secrets
#### StatefulSets

### Managing Kubernetes objects
#### Labels and selectors
#### Field selectors
#### Replication Controllers and Deployments
#### Cluster API


### Architecture
Kubernetes follows the [primary/replica architecture](https://en.wikipedia.org/wiki/Master/slave_\(technology\)). The components of Kubernetes can be divided into those that manage an individual node and those that are part of the control plane.[16][28]
#### Kubernetes control plane
##### etcd
etcd[^Container_Linux_by_CoreOS] is a persistent, lightweight, distributed, key-value data store developed by CoreOS that reliably stores the configuration data of the cluster, representing the overall state of the cluster at any given point of time. Just like Apache ZooKeeper, etcd is a system that favors consistency over availability in the event of a network partition (see CAP theorem). This consistency is crucial for correctly scheduling and operating services. The Kubernetes API Server uses etcd's watch API to monitor the cluster and roll out critical configuration changes or simply restore any divergences of the state of the cluster back to what was declared by the deployer. As an example, if the deployer specified that three instances of a particular pod need to be running, this fact is stored in etcd. If it is found that only two instances are running, this delta will be detected by comparison with etcd data, and Kubernetes will use this to schedule the creation of an additional instance of that pod.[^kubernetes_infrastructure]
##### API Server
The API server is a key component and serves the Kubernetes API using JSON over HTTP, which provides both the internal and external interface to Kubernetes.[16][30] The API server processes and validates REST requests and updates state of the API objects in etcd, thereby allowing clients to configure workloads and containers across Worker nodes.[31]
##### Scheduler
The scheduler is the pluggable component that selects which node an unscheduled pod (the basic entity managed by the scheduler) runs on, based on resource availability. The scheduler tracks resource use on each node to ensure that workload is not scheduled in excess of available resources. For this purpose, the scheduler must know the resource requirements, resource availability, and other user-provided constraints and policy directives such as quality-of-service, affinity/anti-affinity requirements, data locality, and so on. In essence, the scheduler's role is to match resource "supply" to workload "demand".[32]
##### Controller manager
A controller is a reconciliation loop that drives actual cluster state toward the desired cluster state, communicating with the API server to create, update, and delete the resources it manages (pods, service endpoints, etc.). [33][30] The controller manager is a process that manages a set of core Kubernetes controllers. One kind of controller is a Replication Controller, which handles replication and scaling by running a specified number of copies of a pod across the cluster. It also handles creating replacement pods if the underlying node fails.[33] Other controllers that are part of the core Kubernetes system include a DaemonSet Controller for running exactly one pod on every machine (or some subset of machines), and a Job Controller for running pods that run to completion, e.g. as part of a batch job.[34] The set of pods that a controller manages is determined by label selectors that are part of the controller's definition.[27]

#### Kubernetes node
##### Kubelet
##### Kube-proxy
##### Container runtime

#### Add-ons
##### DNS
##### Web UI
##### Container Resource Monitoring
##### Cluster-level logging

[//]: # (Footnotes - all Markdown footnotes SHOULD be add here)
[^wiki]: https://en.wikipedia.org/wiki/Kubernetes
[^k8s-concept]: https://kubernetes.io/docs/concepts/
[^Container_Linux_by_CoreOS]: https://en.wikipedia.org/wiki/Container_Linux_by_CoreOS#Cluster_infrastructure
[^kubernetes_infrastructure]: https://docs.openshift.org/latest/architecture/infrastructure_components/kubernetes_infrastructure.html

