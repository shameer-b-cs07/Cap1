#!/bin/bash

while true
do
    #new_pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running -o json | jq '.items[].metadata.name' | grep -v "email-notification" | grep -v "kube-proxy" | sort)
    new_pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running -o json | jq '.items[].metadata.name' | grep -v "email-notification" | grep -v "kube-proxy" |  grep -v "coredns" |grep -v "etcd" | grep -v "kube-apiserver" | grep -v "kube-controller" | grep -v "kube-scheduler" | grep -v "weave" |sort)
    for pod in $new_pods
    do
        if ! grep -q "$pod" /tmp/k8s-pods
        then
            echo "New Static pod created: $pod" | mailx -s "New Static Pod Created" <EMAIL-ID>
            echo "$pod" >> /tmp/k8s-pods
        fi
    done
    sleep 10
    rm -rf /tmp/k8s-pods
done
