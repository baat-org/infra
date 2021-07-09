# Architecture
![IMG_20210709_130348](https://user-images.githubusercontent.com/12097639/125075389-6f3efa00-e0b6-11eb-8824-f23462b24890.jpg)


# infra
Infrastructure (Kubernetes)

# Local Installations
* Docker: https://docs.docker.com/docker-for-mac/install/
* Virtual Box if you don't already have it: `brew cask install virtualbox`
* Minikube: `brew cask install minikube`
* Kubernetes cli tools: `brew install kubernetes-cli`

# Building All Services
## Clone Services
```
git clone git@github.com:baat-org/core.git
git clone git@github.com:baat-org/chat.git
git clone git@github.com:baat-org/user.git
git clone git@github.com:baat-org/gqlapi.git
git clone git@github.com:baat-org/websockets.git
```

## Build services
```
cd ../core && ./rebuildAndPublishLocal.sh && cd ../infra
cd ../chat && ./rebuildAndPush.sh && cd ../infra
cd ../user && ./rebuildAndPush.sh && cd ../infra
cd ../gqlapi && ./rebuildAndPush.sh && cd ../infra
cd ../websockets && ./rebuildAndPush.sh && cd ../infra
```

# Build & Push Custom JRE Image
```
cd images/custom-jre15
./rebuildAndPush.sh
```

# Deployments

## Local Minikube Cluster

### Create New Cluster
```
minikube config set disk-size 20GB
minikube config set memory 6144
minikube delete
minikube start
```

### Deploy All services
```
cd ../chat && ./redeployAll.sh && cd ../infra
cd ../user && ./redeployAll.sh && cd ../infra
cd ../gqlapi && ./redeployAll.sh && cd ../infra
cd ../websockets && ./redeployAll.sh && cd ../infra
```

### IP Setup (Frontend => Backend)  
```
minikube ip (IP for all services)
kubectl get services --namespace=baat (Port for each service is different)

Update `https://github.com/baat-org/rnative/blob/master/.env` with minikube IP & ports for dependent services.
```

### Logging Setup
```
kubectl create namespace baatlogging
kubectl create -f k8s/logging/elastic-deployment.yml --namespace=baatlogging
kubectl create -f k8s/logging/kibana-deployment.yml --namespace=baatlogging
kubectl create -f k8s/logging/fluentd-rbac.yml
kubectl create -f k8s/logging/fluentd-demonset.yml
```

### Dashboard
```
minikube dashboard
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

### Deploy All services
```
cd ../chat && ./redeployAll.sh && cd ../infra
cd ../user && ./redeployAll.sh && cd ../infra
cd ../gqlapi && ./redeployAll.sh && cd ../infra
cd ../websockets && ./redeployAll.sh && cd ../infra
```

### IP Setup (Frontend => Backend)
```
Update `https://github.com/baat-org/rnative/blob/master/.env` with IPs or DNS of dependent services's Load balancers.
```

### Logging Setup
```
Best to create a separate cluster
AWS managed: https://github.com/aws-samples/aws-workshop-for-kubernetes/tree/master/02-path-working-with-clusters/204-cluster-logging-with-EFK
```

### Dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
kubectl apply -f k8s/dashboard/eks-admin-service-account.yaml

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

### Good resources:
* https://www.youtube.com/watch?v=ZpbXSdzp_vo
* https://github.com/burrsutter/9stepsawesome
