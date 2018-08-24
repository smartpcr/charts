#!/bin/bash

kubectl config use minikube 

kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm reset 
helm init --service-account tiller --upgrade
kubectl get pods -n kube-system # wait till tiller pod is running

Write-Host "Installing prometheus..."
# helm del --purge prometheus
helm install stable/prometheus --name prometheus --namespace prometheus 

kubectl get pods -n prometheus --watch 
# kubectl port-forward prometheus-server-86887bb56b-5b8mc -n prometheus 9090:9090

Write-Host "Installing grafana..."
# helm del --purge grafana
helm install stable/grafana --name grafana --namespace grafana

# if any thing changed on grafa, run the following to upgrade with same release name
# helm upgrade grafana stable/grafana 

kubectl get pods -n grafana --watch
# kubectl port-forward grafana-cb9886fd7-rrvqk -n grafana 3000:3000
# I am already expose 3000 via loadbalancer for another service
kubectl port-forward deployment/grafana -n grafana 3000:3001 