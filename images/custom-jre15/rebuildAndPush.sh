SERVICE=${PWD##*/}

# delete existing containers/images.
docker rmi $(docker images -qa 'sachingoyaldocker/baat-org-'$SERVICE)
echo ">>> Existing Images/Containers Deleted"

docker build --no-cache -t sachingoyaldocker/baat-org-$SERVICE:latest .
echo ">>> New Docker Image Built"

docker push sachingoyaldocker/baat-org-$SERVICE:latest
echo ">>> New Docker Image Pushed to Docker Hub"
