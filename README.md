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

### Web service:
```
kubectl create -f k8s/web/service-deployment.yml
```

### Recreate baat cluster:
```
minikube config set disk-size 20GB
minikube config set memory 6144
minikube delete
minikube start
minikube addons enable ingress

kubectl create -f k8s/user/database-deployment.yml
kubectl create -f k8s/user/service-deployment.yml
kubectl create -f k8s/chat/database-deployment.yml
kubectl create -f k8s/chat/messaging-deployment.yml
kubectl create -f k8s/chat/service-deployment.yml
kubectl create -f k8s/websockets/service-deployment.yml
kubectl create -f k8s/web/service-deployment.yml

kubectl apply -f k8s/ingress/web-ingress-deployment.yml
kubectl apply -f k8s/ingress/websockets-ingress-deployment.yml
kubectl apply -f k8s/ingress/api-ingress-deployment.yml

minikube ip

echo "update /etc/hosts with above IP and host for baat.org, api.baat.org & websockets.baat.org"
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
