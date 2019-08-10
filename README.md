# k8s
Kubernetes

User service and database:
```
kubectl create -f k8s/user/database-deployment.yml
kubectl create -f k8s/user/service-deployment.yml
```

To connect to database:
```
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h <<database host e.g. user-db>> -p<<password>>
```
