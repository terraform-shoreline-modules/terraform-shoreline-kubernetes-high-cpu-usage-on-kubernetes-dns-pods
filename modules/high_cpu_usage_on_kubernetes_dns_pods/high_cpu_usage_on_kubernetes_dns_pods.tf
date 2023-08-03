resource "shoreline_notebook" "high_cpu_usage_on_kubernetes_dns_pods" {
  name       = "high_cpu_usage_on_kubernetes_dns_pods"
  data       = file("${path.module}/data/high_cpu_usage_on_kubernetes_dns_pods.json")
  depends_on = [shoreline_action.invoke_set_kubectl_context_and_namespace]
}

resource "shoreline_file" "set_kubectl_context_and_namespace" {
  name             = "set_kubectl_context_and_namespace"
  input_file       = "${path.module}/data/set_kubectl_context_and_namespace.sh"
  md5              = filemd5("${path.module}/data/set_kubectl_context_and_namespace.sh")
  description      = "Optimize the configuration of the DNS pods to reduce their resource consumption and improve efficiency, such as adjusting resource requests and limits, or using a more lightweight DNS solution."
  destination_path = "/agent/scripts/set_kubectl_context_and_namespace.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_set_kubectl_context_and_namespace" {
  name        = "invoke_set_kubectl_context_and_namespace"
  description = "Optimize the configuration of the DNS pods to reduce their resource consumption and improve efficiency, such as adjusting resource requests and limits, or using a more lightweight DNS solution."
  command     = "`chmod +x /agent/scripts/set_kubectl_context_and_namespace.sh && /agent/scripts/set_kubectl_context_and_namespace.sh`"
  params      = ["NAMESPACE","CONTEXT_NAME"]
  file_deps   = ["set_kubectl_context_and_namespace"]
  enabled     = true
  depends_on  = [shoreline_file.set_kubectl_context_and_namespace]
}

