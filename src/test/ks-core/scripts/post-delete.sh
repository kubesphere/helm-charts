#!/usr/bin/env bash

set -x

# delete crds
for crd in `kubectl get crds -o jsonpath="{.items[*].metadata.name}"`
do
  if [[ $crd == *kubesphere.io ]]; then
     scop=$(eval echo $(kubectl get crd ${crd} -o jsonpath="{.spec.scope}"))
     if [[ $scop =~ "Namespaced" ]] ; then
        kubectl get $crd -A --no-headers | awk '{print $1" "$2" ""'$crd'"}' | xargs -n 3 sh -c 'kubectl patch $2 -n $0 $1 -p "{\"metadata\":{\"finalizers\":null}}" --type=merge 2>/dev/null && kubectl delete $2 -n $0 $1 2>/dev/null'
     else
        kubectl get $crd -A --no-headers | awk '{print $1" ""'$crd'"}' | xargs -n 2 sh -c 'kubectl patch $1 $0 -p "{\"metadata\":{\"finalizers\":null}}" --type=merge 2>/dev/null && kubectl delete $1 $0 2>/dev/null'
     fi
     kubectl delete crd $crd 2>/dev/null;
  fi
done
