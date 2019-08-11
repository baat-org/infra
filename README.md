# k8s
Kubernetes

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

## Useful tips:

### Minikube recreate:
```
minikube delete
minikube start
```

### Minikube configs:
```
minikube config set disk-size 6GB
minikube config set memory 6144
```

### To connect to database:
```
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h <<database host e.g. user-db>> -p<<password>>
```

### Get URL
```
minikube service web --url
```
