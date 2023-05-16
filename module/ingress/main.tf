resource "helm_release" "ingress" {
    name             = "ingress"
    repository       = "https://kubernetes.github.io/ingress-nginx"
    chart            = "ingress-nginx"
    create_namespace = "true"
    namespace        = "ingress"
    set {
      name = "default-ssl-certificate"
      value = "ingress/nginx-server-certs"
    }
}