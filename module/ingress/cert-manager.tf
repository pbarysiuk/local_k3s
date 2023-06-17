resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "ingress"
  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [kubernetes_namespace_v1.ingress]
}

resource "kubectl_manifest" "external_secrets_vault_store" {
  yaml_body  = <<-EOF
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: letsencrypt-dev
    namespace: ingress
  spec:
    acme:
      # The ACME server URL
      server: https://acme-staging-v02.api.letsencrypt.org/directory
      # Email address used for ACME registration
      email: sh.holod@gmail.com
      # Name of a secret used to store the ACME account private key
      privateKeySecretRef:
        name: letsencrypt-local
      # Enable the HTTP-01 challenge provider
      solvers:
      - http01:
          ingress:
            class: nginx
  EOF
  depends_on = [helm_release.cert_manager]
}