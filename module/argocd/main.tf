resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata.0.name

  values = ["${file("${path.module}/values.yaml")}"]
}

# resource "kubernetes_ingress_v1" "argocd_ingress" {
#   wait_for_load_balancer = true
#   metadata {
#     name      = "argocd-ingress"
#     namespace = kubernetes_namespace.argocd.metadata.0.name
#     annotations = {
#       #"nginx.ingress.kubernetes.io/use-regex" = "true"
#       "kubernetes.io/ingress.class"        = "nginx"
#       "ingress.kubernetes.io/ssl-redirect" = "true"
#       #"nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
#       #"nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
#     }
#   }

#   spec {
#     tls {
#       secret_name = "k8s.local-tls"
#     }
#     ingress_class_name = "nginx"
#     rule {
#       host = "argocd.k8s.dev.localhost"
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "agrocd-server"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }