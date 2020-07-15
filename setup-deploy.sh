#!/usr/bin/env bash

echo "microk8s: install..."
sudo snap install microk8s --classic

echo "microk8s: enable helm3..."
microk8s.enable helm3

echo "microk8s: deploy helm chart"
microk8s.helm3 install --debug hipstershop helm/
