resource "kubernetes_namespace_v1" "ingress" {
  metadata {
    annotations = {
      name = "ingress"
    }
    name = "ingress"
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
  }
}
resource "helm_release" "ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = resource.kubernetes_namespace_v1.ingress.metadata[0].name
  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "ingress/k8s.local-tls"
  }
  depends_on = [resource.kubernetes_namespace_v1.ingress]
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

  type       = "kubernetes.io/tls"
  depends_on = [kubernetes_namespace_v1.ingress]
}
