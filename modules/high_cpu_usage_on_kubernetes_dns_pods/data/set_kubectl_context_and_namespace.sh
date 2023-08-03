bash

#!/bin/bash

# Set the Kubernetes context and namespace

kubectl config use-context ${CONTEXT_NAME}

kubectl config set-context $(kubectl config current-context) --namespace=${NAMESPACE}

# Update the resource requests and limits for the DNS pods

kubectl patch deployment coredns --patch '{"spec": {"template": {"spec": {"containers": [{"name": "kubedns", "resources": {"requests": {"cpu": "50m", "memory": "100Mi"}, "limits": {"cpu": "100m", "memory": "200Mi"}}}]}}}}'

# Alternatively, replace kube-dns with the name of the DNS pod deployment and adjust the resource requests and limits as needed

# Restart the DNS pods to apply the changes

kubectl rollout restart deployment kube-dns