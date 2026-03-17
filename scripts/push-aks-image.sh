#!/usr/bin/env bash
set -e

ACR_NAME="acrcasopractico2pm8471"

az acr login --name "$ACR_NAME"

podman pull docker.io/nginx:stable
podman tag docker.io/nginx:stable "$ACR_NAME".azurecr.io/nginx-aks:v1
podman push "$ACR_NAME".azurecr.io/nginx-aks:v1