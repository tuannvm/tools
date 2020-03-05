#/bin/bash

IFS=$'\n'       # make newlines the only separator

if [ -z "$1" ]; then echo "Usage: ./deploy_finder.sh <deployment-name>" && exit;fi

# Get all cluster from kubeconfig except minikube
clusters=`kubectl config get-contexts | tr -s ' ' | cut -d" " -f2 | grep -viE 'NAME|minikube'`

for cluster in $clusters; do
  deployments=`kubectl --context $cluster get deployment --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,REPLICAS:.spec.replicas | awk "NR==1 || /$1/"`
  if [ "$deployments" ];then
    echo "Cluster: $cluster"
    for deployment in $deployments;do
      echo $deployment
    done
  fi
done
