# Guide de Configuration et de Déploiement

Ce guide explique comment configurer et déployer une application Flask avec une base de données Redis sur un cluster Azure Kubernetes Service (AKS) en utilisant Terraform, Helm, et Docker.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé :
- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- [Terraform](https://www.terraform.io/downloads.html)
- [Helm](https://helm.sh/docs/intro/install/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) (si nécessaire pour les tests locaux)

## Étapes de Configuration et de Déploiement

### Étape 1 : Connexion au Registre Azure
``az acr login -n acrESGINCHOBYKHALQALLAHY``

### Étape 2 : Construction et Envoi de l'Image Docker
**Construisez l'image Docker (remplacez <tag> par votre tag) :**

`docker buildx build ./flask-app --platform linux/amd64,linux/arm64 -t acresginchobykhalqallahy.azurecr.io/flaskapp:v1`

**Envoyez l'image vers Azure Container Registry :**

`docker push acresginchobykhalqallahy.azurecr.io/flaskapp:v1`

## Étape 3 : Activation de Minikube (Optionnel)
**Pour tester localement :**

`minikube start`

## Étape 4 : Création et Configuration du Cluster AKS
**Obtenez les identifiants du cluster AKS :**

`az aks get-credentials --name aksESGINCHOBYKHALQALLAHY --overwrite --resource-group rg-ESGI-NCHOBYKHALQALLAHY`

**Ajoutez les dépôts Helm pour l'Ingress Controller :**

```hcl
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```
**Appliquez la configuration Terraform :**

```bash
terraform init
terraform apply
```
## Étape 5 : Déploiement de l'Application dans AKS
**Appliquez le déploiement Kubernetes :**
```
cd ..
kubectl apply -f ./kubernetes/flask-deployment.yaml --namespace ingress-basic
export KUBE_CONFIG_PATH=~/.kube/config
```

**Mettez à jour AKS pour attacher ACR :**
`az aks update -n aksESGINCHOBYKHALQALLAHY -g rg-ESGI-NCHOBYKHALQALLAHY --attach-acr acrESGINCHOBYKHALQALLAHY`

**Créez un secret Kubernetes pour ACR :**
```
ACL_URL=acresginchobykhalqallahy.azurecr.io
```

`terraform get `

## Étape 6 : Configuration de l'Ingress Controller
**Configurez l'Ingress Controller avec l'IP publique :**
```
NAMESPACE=ingress-basic
# terraform output public_ip_address
PUBLIC_IP_ADDRESS=$(terraform output public_ip)
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.loadBalancerIP=$PUBLIC_IP_ADDRESS \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
```
## Étape 7 : Création des Identifiants ACR
**Créez un secret Kubernetes pour les identifiants ACR :**
```
ACR_USERNAME=acresginchobykhalqallahy
ACR_PASSWORD=AlJzM7guu9Od1b0uivZyTHOEnoTjYh8UiI7ILIzjjM+ACRD7bJVV

kubectl create secret generic acr-credentials \
    --from-literal=username=$ACR_USERNAME \
    --from-literal=password=$ACR_PASSWORD
```
## Étape 8 : Importation de l'Image dans ACR
**Si nécessaire, importez l'image dans ACR :**
`az acr import  -n acrESGINCHOBYKHALQALLAHY  --source acresginchobykhalqallahy.azurecr.io/flask-app --image flask-app:v1`
