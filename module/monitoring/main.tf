resource "helm_release" "monitoring" {
  name             = "basic-prometheus-monitoring"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kube-prometheus"
  create_namespace = "true"
  namespace        = "monitoring"
}