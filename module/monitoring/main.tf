resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kube-prometheus"
  create_namespace = "true"
  namespace        = "monitoring"
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = "true"
  set {
    name  = "adminPassword"
    value = "admin"
  }
  set {
    name  = "sidecar.datasources.enabled"
    value = "true"
  }
  set {
    name  = "sidecar.dashboards.enabled"
    value = "true"
  }
  set {
    name  = "sidecar.dashboards.label"
    value = "grafana_dashboard"
  }
  set {
    name  = "sidecar.datasources.label"
    value = "grafana_datasource"
  }
}

# resource "kubernetes_ingress_v1" "grafana" {
#   metadata {
#     name = "grafana"
#     namespace = "monitoring"
#     annotations = {
#       "ingress.kubernetes.io/ssl-redirect" = "true"
#     }
#   }
#   spec {
#     rule {
#       host = "grafana.k8s.local"
#       http {
#         path {
#           backend {
#             service_name = "grafana"
#             service_port = "3000"
#           }
#           path = "/"
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "prometheus" {
#   wait_for_load_balancer = true
#   metadata {
#     name = "prometheus"
#     namespace = "monitoring"
#     annotations = {
#       "ingress.kubernetes.io/ssl-redirect" = "true"
#     }
#   }
#   spec {
#     //ingress_class_name = "nginx"
#     rule {
#       host = "prometheus.k8s.local"
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = "prometheus-operated"
#               port {
#                 number = 9090
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
