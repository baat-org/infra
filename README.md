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
kubectl create -f k8s/gqlapi/service-deployment.yml
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
kubectl create -f k8s/gqlapi/service-deployment.yml

----

minikube ip (IP for all services)
kubectl get services (Port for each service is different)

Update k8s/web/service-deployment.yml with minikube IP & ports for dependent services.

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
Create cluster, it will use autoscaling without any policy, but keep instances in min/max.
To enable pod and cluster auto scaler they need to be setup seprately.

eksctl create cluster \
    --name baat \
    --version 1.13 \
    --nodegroup-name baat-workers \
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
kubectl create -f k8s/gqlapi/service-deployment.yml

----

Update k8s/web/service-deployment.yml with IPs or DNS for dependent services.
kubectl create -f k8s/web/service-deployment.yml
```

### Deploy dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

-------

Create eks-admin-service-account.yaml with following:

apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system

-------
kubectl apply -f eks-admin-service-account.yaml

-------
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
kubectl proxy

Open:
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

And put the token.
```

### Delete AWS Kubernetes Cluster
```
kubectl get svc --all-namespaces

kubectl delete svc `service-name`

eksctl delete cluster --name baat

```

## Useful tips:

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
