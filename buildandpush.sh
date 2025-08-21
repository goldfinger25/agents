#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Get ACR login server from Terraform output
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
IMAGE_NAME=$(terraform output -raw acr_image_name)
IMAGE_TAG=$(terraform output -raw acr_image_tag)

# Authenticate with ACR
az acr login --name $ACR_LOGIN_SERVER

# Build the Docker image
docker build -t $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG .

# Push the Docker image to ACR
docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG

echo "Docker image built and pushed successfully."