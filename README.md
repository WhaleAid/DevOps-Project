

terraform apply --auto-approve

## login to azure registry
az acr login -n acrESGINCHOBYKHALQALLAHY

## Ecrivez ici les inscriptions et explications pour déployer l'infrastructure et l'application sur Azure
docker buildx build ./flask-app --platform linux/amd64,linux/arm64  -t acresginchobykhalqallahy.azurecr.io/flaskapp:v1
docker push acresginchobykhalqallahy.azurecr.io/flaskapp:v1

## Activate minikube
minikube start


## Création du cluster AKS
az aks get-credentials --name aksESGINCHOBYKHALQALLAHY --overwrite --resource-group rg-ESGI-NCHOBYKHALQALLAHY

## Création du namespace
kubectl create namespace ingress-nginx

## Ajout du repo helm pour l'ingress controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

## Application de l'ingress controller
helm repo update

## Installation de l'ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx -n ingress-nginx


## 
cd ..
kubectl apply -f flask-deployment.yaml --namespace ingress-basic

export KUBE_CONFIG_PATH=~/.kube/config

az aks update -n aksESGINCHOBYKHALQALLAHY -g rg-ESGI-NCHOBYKHALQALLAHY --attach-acr acrESGINCHOBYKHALQALLAHY

# terraform output public_ip_address
NAMESPACE=ingress-nginx
PUBLIC_IP_ADDRESS=$(terraform output public_ip)
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.loadBalancerIP=$PUBLIC_IP_ADDRESS \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz



ACR_USERNAME=acresginchobykhalqallahy
ACR_PASSWORD=AlJzM7guu9Od1b0uivZyTHOEnoTjYh8UiI7ILIzjjM+ACRD7bJVV

kubectl create secret generic acr-credentials \
    --from-literal=username=$ACR_USERNAME \
    --from-literal=password=$ACR_PASSWORD



az acr import  -n acrESGINCHOBYKHALQALLAHY  --source acresginchobykhalqallahy.azurecr.io/flask-app --image flask-app:v1
