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

resource "kubernetes_ingress_v1" "grafana_ingress" {
  wait_for_load_balancer = true
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"
    annotations = {
      "nginx.ingress.kubernetes.io/use-regex" = "true"
      #"kubernetes.io/ingress.class"                = "nginx"
      #"nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    tls {
      secret_name = "k8s.local-tls"
    }
    ingress_class_name = "nginx"
    rule {
      host = "grafana.k8s.dev.localhost"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

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
