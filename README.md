
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High CPU Usage on Kubernetes DNS Pods
---

This incident type involves a high CPU usage on Kubernetes DNS pods in a test environment. It typically occurs when the average CPU usage exceeds a certain threshold, as indicated by a query alert monitor. This can impact the performance and stability of the Kubernetes cluster and may require investigation and remediation to prevent further issues.

### Parameters
```shell
# Environment Variables

export NAMESPACE="PLACEHOLDER"

export SELECTOR="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export INCIDENT_KEYWORD="PLACEHOLDER"

export CONTEXT_NAME="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"

export MEMORY_THRESHOLD="PLACEHOLDER"
```

## Debug

### 1. Check the CPU usage of Kubernetes DNS pods
```shell
kubectl top pods --namespace ${NAMESPACE} --selector ${SELECTOR} # replace ${NAMESPACE} and ${SELECTOR} with appropriate values
```

### 2. Check the resource limits and requests of Kubernetes DNS pods
```shell
kubectl describe pods --namespace ${NAMESPACE} --selector ${SELECTOR} | grep -A 5 "Limits\|Requests" # replace ${NAMESPACE} and ${SELECTOR} with appropriate values
```

### 3. Check the status of the Kubernetes cluster
```shell
kubectl get nodes # check if any nodes are in NotReady state
```

### 4. Check the logs of the Kubernetes DNS pods
```shell
kubectl logs ${POD_NAME} --namespace ${NAMESPACE} # replace ${POD_NAME} and ${NAMESPACE} with appropriate values
```

### 5. Check the status of the Kubernetes DNS service
```shell
kubectl describe services coredns --namespace ${NAMESPACE} # replace ${NAMESPACE} with appropriate value
```

### 6. Check the CPU usage of the node(s) hosting the Kubernetes DNS pods
```shell
kubectl top nodes # identify the node(s) hosting the pods and check their CPU usage
```

### 7. Check the Kubernetes events related to the incident
```shell
kubectl get events --namespace ${NAMESPACE} --sort-by='.metadata.creationTimestamp' | grep -i ${INCIDENT_KEYWORD} # replace ${NAMESPACE} and ${INCIDENT_KEYWORD} with appropriate values
```

## Repair

### Optimize the configuration of the DNS pods to reduce their resource consumption and improve efficiency, such as adjusting resource requests and limits, or using a more lightweight DNS solution.
```shell
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


```