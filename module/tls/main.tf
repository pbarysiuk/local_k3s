resource "kubernetes_secret" "k8s_local_tls" {
  metadata {
    name      = "k8s.local-tls"
    namespace = "ingress"
  }

  data = {
    "tls.crt" = "${file("${path.module}/cert.pem")}"
    "tls.key" = "${file("${path.module}/key.pem")}"
  }

  type = "kubernetes.io/tls"
}
