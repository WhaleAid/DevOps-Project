



## login to azure registry
az acr login -n acrESGINCHOBYKHALQALLAHY

## Ecrivez ici les inscriptions et explications pour déployer l'infrastructure et l'application sur Azure
docker build . -t acresginchobykhalqallahy.azurecr.io/flask-app:latest
docker push acresginchobykhalqallahy.azurecr.io/flask-app

## Activate minikube
minikube start


## Création du cluster AKS
az aks get-credentials --name aksESGINCHOBYKHALQALLAHY --overwrite --resource-group rg-ESGI-NCHOBYKHALQALLAHY

## Ajout du repo helm pour l'ingress controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

## Application de l'ingress controller
helm repo update

## 
cd ..
kubectl apply -f flask-deployment.yaml


az aks update -n aksESGINCHOBYKHALQALLAHY -g rg-ESGI-NCHOBYKHALQALLAHY --attach-acr acrESGINCHOBYKHALQALLAHY

ACL_URL=acresginchobykhalqallahy.azurecr.io

terraform get 

NAMESPACE=ingress-basic
# terraform output public_ip_address
PUBLIC_IP_ADDRESS=$(terraform output public_ip)
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.loadBalancerIP=10.224.0.42 \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz