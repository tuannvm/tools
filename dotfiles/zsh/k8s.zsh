export KUBECONFIG=~/.kube/config
# EXTRA_KUBECONFIGS="vungle_1d1"
# 
# for file in $EXTRA_KUBECONFIGS; do
#   export KUBECONFIG=$KUBECONFIG:~/.kube/$file
# done

kc() {
  kubectl config current-context
}

kget() {
  kubectl get $@
}

kgetd() {
  kubectl get deployment $@
}

kscale() {
  kubectl scale deployment $1 --replicas=$2
}

kroll() {
  kubectl rollout restart deployment $@
}

kedit() {
  kubectl edit $@
}

keditd() {
  kedit deployment $@
}

kedits() {
  kedit secret $@
}

kpods() {
  kubectl get pod
}

kns() {
  kubectl config set-context $(kubectl config current-context) --namespace=$1
}

kcurrent() {
  kubectl config current-context
}

kdes() {
  kubectl describe $@
}

klogs() {
  kubectl logs -f $@
}

kex() {
  kubectl explain $@
}

kexec() {
  kubectl exec -it $@
}

ktest() {
  kubectl run -it --rm --image=quay.io/tuannvm/ubuntu tuan-shell -- bash
}

kdash() {
  kubectl -n kube-system port-forward $(kubectl get pods -n kube-system -o wide | grep dashboard | awk '{print $1}') 9090
}

ktag() {
  kpods $@ -o json | jq ".spec.containers[].image" | cut -d":" -f2
}

knodes() {
  kubectl get no -o custom-columns=NAME:.metadata.name,AWS-INSTANCE:.spec.externalID,AGE:.metadata.creationTimestamp
}
