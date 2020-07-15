#!/usr/bin/env bash

echo "microk8s: install..."
sudo snap install microk8s --classic

echo "microk8s: enable helm3, istio..."
microk8s.enable helm3 istio

echo "enable side-car injection 'default' namespace..."
microk8s.kubectl label namespace default istio-injection=enabled

echo "microk8s: deploy helm chart"
microk8s.helm3 install --debug hipstershop helm/
