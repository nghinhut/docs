
---
title: "Kubernetes"
date: 2019-11-09T01:45:50+07:00
image: "/assets/img/1200px-Kubernetes_logo_without_workmark.svg.png"
author: "nghinhut@gmail.com (Nghi L. M. Nhựt)"
categories: "Deployment"
tags: "kubernetes,devops"
draft: false
---

**Kubernetes** is an open source container orchestration engine for automating deployment, scaling, and management of containerized applications.[^k8s-docs]

<!--more-->

### Introduction to Containers, Docker and Kubernetes[^hackernoon]
Container technologies such as Docker and Kubernetes are essential in modern cloud infrastructure, but what are they and how do they work? This article will present a quick introduction to the key concepts. To help you further understand the concepts in a more practical manner, the introduction will be followed by a tutorial in setting up a local development copy of Kubernetes. We will then deploy a MySQL database and the Joget application platform to provide a ready environment for visual, rapid application development.

#### Containers
Containers are a way of packaging software so that application code, libraries, and dependencies are packed together in a repeatable way. Containers share the underlying operating system but run in isolated processes.

At this point, you might be asking how a container is different from a virtual machine (VM) running on a VM platform (called hypervisors) such as VMware or VirtualBox? Virtual machines include the entire operating system (OS) running on virtual hardware and is good for isolating the whole environment. For example, you could run an entire Windows Server installation on top of a Mac computer running macOS. Containers, on the other hand, sit above the OS and can share libraries so they are more lightweight and thus are more suitable for deployment on a larger, more efficient scale. The diagram below illustrates the difference in a visual manner for easier understanding.


Difference between virtual machines and containers
#### Docker
Docker is an open source tool to create, deploy and run containers. In Docker, you essentially define a Dockerfile that is like a snapshot of an application that can be deployed and run wherever a Docker runtime is available, whether in the cloud, on your PC, or even within a VM. Docker also supports repositories such as Docker Hub where container images are stored to be distributed.

While Docker is not the only container technology available (with alternatives such as CoreOS rkt, Mesos, LXC), it is dominant and the de facto standard in industry right now.

#### Kubernetes
If Kubernetes sounds Greek to you, it’s because it literally is. Kubernetes is the Greek word for “captain” or “helmsman of a ship”. Kubernetes, shortened to K8s (convert the middle eight letters into the number 8), is an open source container orchestration platform. What does orchestration mean in this case? While containers make it easier to package software, it does not help in many operational areas, for example:

* How do you deploy containers across different machines? What happens when a machine fails?
* How do you manage load? How can containers be automatically started or stopped according to the load on the system?
* How do you handle persistent storage? Where do containers store and share files?
* How do you deal with failures? What happens when a container crashes?
An orchestration platform helps to manage containers in these areas and more.

Originally created by Google based on their need to support massive scale, Kubernetes is now under the purview of Cloud Native Computing Foundation (CNCF), a vendor-neutral foundation managing popular open source projects.

There are alternatives to Kubernetes (such as Docker Swarm, Mesos, Nomad, etc) but Kubernetes has seemingly won the container orchestration war having been adopted by almost all the big vendors including Google, Amazon, Microsoft, IBM, Oracle, Red Hat and many more.

### Setup up highly available Kubernetes cluster with kubeadm[^ha-kubeadm]
![]({{<baseurl>}}/assets/img/kubeadm-ha-topology-stacked-etcd.svg)


#### Implementation
Dependencies:

1. Load Balancer: [HAProxy](http://www.haproxy.org/)

2. in addition to run HAProxy reliably we need [keepalived](https://www.keepalived.org/)

```shell script
    # /etc/haproxy/haproxy.cfg on load balancer 1 & load balancer 2
    global
       log /dev/log local0
       log /dev/log local1 notice
       chroot /var/lib/haproxy
       stats timeout 30s
       user haproxy
       group haproxy
       daemon
    
    defaults
       log global
       option tcplog
       mode tcp
       option httplog
       option dontlognull
       timeout connect 5s
       timeout client 30s
       timeout server 30s
    
    listen lets-encrypt-http-resolver
        bind *:80
        mode http
        maxconn 8
        stats uri /haproxy?stats
        balance roundrobin
        server k8s-nginx-ingress-01 192.168.0.111:80 check
        server k8s-nginx-ingress-02 192.168.0.112:80 check
        server k8s-nginx-ingress-07 192.168.0.107:80 check
    
    listen k8s-nginx-ingress
        bind *:443
        mode tcp
        maxconn 128
        balance roundrobin
        option tcp-check
        server k8s-nginx-ingress-01 192.168.0.111:443 check fall 3 rise 2 
        server k8s-nginx-ingress-02 192.168.0.112:443 check fall 3 rise 2
        server k8s-nginx-ingress-07 192.168.0.107:443 check fall 3 rise 2
    
    listen k8s-api-server
        bind *:6443
        mode tcp
        maxconn 128
        timeout connect 5s
        timeout client 24h
        timeout server 24h
        server k8s-master-01 192.168.0.111:6443 check fall 3 rise 2
        server k8s-master-02 192.168.0.112:6443 check fall 3 rise 2
        server k8s-master-07 192.168.0.107:6443 check fall 3 rise 2
```

```shell script
    # /etc/keepalived/keepalived.conf on load balancer 1
    global_defs {
      enable_script_security
      script_user root root
      router_id lb01                            
    }
    vrrp_script chk_haproxy {
      script "/usr/bin/killall -0 haproxy"
      interval 2
      weight 2
    }
    vrrp_instance VI_1 {
      virtual_router_id 51
      advert_int 1
      priority 100
      state MASTER
      interface virbr0
      #track_interface {
      #  p4p2
      #  virbr0
      #}
      unicast_src_ip 192.168.0.101
      unicast_peer {
        192.168.0.102
      }
      virtual_ipaddress {
        192.168.0.203 dev virbr0
      }
      authentication {
         auth_type PASS
         auth_pass 1111
      }
      track_script {
        chk_haproxy
      }
    }
```

```shell script
    # /etc/keepalived/keepalived.conf on load balancer 2
    global_defs {
      enable_script_security
      script_user root root
      router_id lb02
    }
    vrrp_script chk_haproxy {
      script "/usr/bin/killall -0 haproxy"
      interval 2
      weight 2
    }
    vrrp_instance VI_1 {
      virtual_router_id 51
      advert_int 1
      priority 99
      state BACKUP
      interface virbr0
      #track_interface {
      #  p4p2
      #  virbr0
      #}
      unicast_src_ip 192.168.0.102
      unicast_peer {
        192.168.0.101
      }
      virtual_ipaddress {
        192.168.0.203 dev virbr0
      }
      authentication {
          auth_type PASS
          auth_pass 1111
      }
      track_script {
        chk_haproxy
      }
    }
```

[^k8s-docs]: https://kubernetes.io/docs/home/
[^wiki:kubernetes]: https://en.wikipedia.org/wiki/Kubernetes
[^hackernoon]: https://hackernoon.com/kubernetes-what-the-hype-is-all-about-and-a-practical-tutorial-on-deploying-joget-for-low-code-47a8b02e47f5
[^ha-kubeadm]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
[^wiki:Network_topology]: https://en.wikipedia.org/wiki/Network_topology
