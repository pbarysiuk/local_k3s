resource "helm_release" "ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = "true"
  namespace        = "ingress"
  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "ingress/k8s.local-tls"
  }
}

resource "kubernetes_secret" "k8s_local_tls" {
  metadata {
    name      = "k8s.local-tls"
    namespace = helm_release.ingress.namespace
  }

  data = {
    "tls.crt" = "${file("${path.module}/cert.pem")}"
    "tls.key" = "${file("${path.module}/key.pem")}"
  }

  type = "kubernetes.io/tls"
}
