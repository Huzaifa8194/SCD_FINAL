#!/bin/bash

echo "=== Checking Persistent Volume Claims ==="
kubectl get pvc

echo -e "\n=== Checking Pods ==="
kubectl get pods

echo -e "\n=== Checking Services ==="
kubectl get svc

echo -e "\n=== Checking Deployments ==="
kubectl get deployments

echo -e "\n=== Frontend URL ==="
echo "http://$(minikube ip):30080" 