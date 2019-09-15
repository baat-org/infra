# k8s
Kubernetes

## Installations
* Docker: https://docs.docker.com/docker-for-mac/install/
* Virtual Box if you don't already have it: `brew cask install virtualbox`
* Minikube: `brew cask install minikube`
* Kubernetes cli tools: `brew install kubernetes-cli`


## Deployments

### User service and database:
```
kubectl create -f k8s/user/database-deployment.yml
kubectl create -f k8s/user/service-deployment.yml
```

### Chat service, messaging and database:
```
kubectl create -f k8s/chat/messaging-deployment.yml
kubectl create -f k8s/chat/database-deployment.yml
kubectl create -f k8s/chat/service-deployment.yml
```

### Websockets service:
```
kubectl create -f k8s/websockets/service-deployment.yml
```

### GQL API service:
```
kubectl create -f k8s/gql_api/service-deployment.yml
```  

### Web service:
1. Take note of IP/DNS for Websockets service, GQL API service and update `k8s/web/service-deployment.yml`
2. Deploy service: `kubectl create -f k8s/web/service-deployment.yml`  


## Minikube cluster setup

```
minikube config set disk-size 20GB
minikube config set memory 6144
minikube delete
minikube start

kubectl create -f k8s/user/database-deployment.yml
kubectl create -f k8s/user/service-deployment.yml
kubectl create -f k8s/chat/database-deployment.yml
kubectl create -f k8s/chat/messaging-deployment.yml
kubectl create -f k8s/chat/service-deployment.yml
kubectl create -f k8s/websockets/service-deployment.yml
kubectl create -f k8s/gql_api/service-deployment.yml

----

minikube ip

Update k8s/web/service-deployment.yml with IPs for dependent services.

kubectl create -f k8s/web/service-deployment.yml
```

## AWS EKS cluster setup

### Setup

```
From AWS management console (IAM):
1. Create user (baat-user)
2. Create group (admin) (AdminAccessAll), and assign user.

Command line:
1. brew install weaveworks/tap/eksctl
2. aws configure (and setup access key password to this user)
```

### AWS EKS cluster
```
eksctl create cluster \
    --name baat \
    --version 1.13 \
    --nodegroup-name standard-workers \
    --node-type t3.medium \
    --nodes 3 \
    --nodes-min 1 \
    --nodes-max 4 \
    --node-ami auto
```

### Deployment

```
kubectl create -f k8s/user/database-deployment.yml
kubectl create -f k8s/user/service-deployment.yml
kubectl create -f k8s/chat/database-deployment.yml
kubectl create -f k8s/chat/messaging-deployment.yml
kubectl create -f k8s/chat/service-deployment.yml
kubectl create -f k8s/websockets/service-deployment.yml
kubectl create -f k8s/gql_api/service-deployment.yml

----

Update k8s/web/service-deployment.yml with IPs or DNS for dependent services.
kubectl create -f k8s/web/service-deployment.yml

```

## Useful tips:

### Minikube recreate:
```
minikube delete
minikube start
```

### Minikube configs:
```
minikube config set disk-size 20GB
minikube config set memory 6144
```

### To connect to database:
```
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h <<database host e.g. user-db>> -p<<password>>
```

### Get a service's URL
```
minikube service <<service name>> --url
```
### Minikube Dashboard
```
minikube dashboard
```

### Good resources:
* https://www.youtube.com/watch?v=ZpbXSdzp_vo
* https://github.com/burrsutter/9stepsawesome
