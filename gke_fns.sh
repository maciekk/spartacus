#!/bin/bash
#
# Functions enapsulating key steps from GKE tutorial here:
#  https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app

PROJECT="$(gcloud config get-value project -q)"
NUM_NODES=3
# TODO: what are sensible values for this?
ZONE="us-central1-a"

gke_build () {
  sudo docker build -t gcr.io/${PROJECT}/${PROJECT}-app:v1 .
  sudo docker images # show results
}

gke_push () {
  gcloud auth configure-docker
  sudo docker push gcr.io/${PROJECT}/${PROJECT}-app:v1
}

gke_cluster_up() {
  gcloud container clusters create ${PROJECT}-cluster --num-nodes=$NUM_NODES --zone $ZONE
  gcloud compute instances list # show results
}

gke_cluster_dn() {
  gcloud container clusters delete ${PROJECT}-cluster --zone $ZONE
}

gke_deploy() {
  kubectl run ${PROJECT}-web --image=gcr.io/${PROJECT}/${PROJECT}-app:v1 --port 8080
  kubectl get pods # show results
}

gke_service_up() {
  kubectl expose deployment ${PROJECT}-web --type=LoadBalancer --port 80 --target-port 8080
  kubectl get service # show results
}

gke_service_dn() {
  kubectl delete service ${PROJECT}-web
}

# Arguments: $1 == number of desired replicas
gke_scale() {
  kubectl scale deployment ${PROJECT}-web --replicas=${1:-${NUM_NODES}}
  kubectl get pods # show results
}
