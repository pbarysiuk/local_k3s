resource "k3d_cluster" "mycluster" {
  name    = "mycluster"
  servers = 1
  agents  = 2

  kube_api {
    host      = "k8s.dev"
    host_ip   = "0.0.0.0"
    host_port = 6445
  }

  image   = "rancher/k3s:v1.27.1-k3s1"
  network = "mycluster-net"
  token   = "superSecretToken"

  volume {
    source      = "/tmp"
    destination = "/storage"
  }

  port {
    host_port      = 80
    container_port = 80
    node_filters = [
      //"server:0:direct",
      "loadbalancer:*"
    ]
  }
    port {
    host_port      = 443
    container_port = 443
    node_filters = [
      //"server:0:direct",
      "loadbalancer:*"
    ]
  }
  registries {
    use = [
      "k3d-registry.localhost:5000"
    ]
    config = <<EOF
mirrors:
  "k3d-registry.localhost:5000":
    endpoint:
      - http://k3d-registry.localhost:5000
EOF
  }

  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

  k3s {
    extra_args {
      arg = "--disable=traefik, --tls-san=127.0.0.1"
      node_filters = [
        "server:*",
      ]
    }
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}

# resource "k3d_node" "mycluster_node_1" {
#   name = "k3d_mycluster_node_1"

#   cluster = "mycluster"
#   image   = "rancher/k3s:v1.27.1-k3s1"
#   memory  = "2Gi"
#   role    = "agent"
# }

# resource "k3d_registry" "mycluster-registry" {
#   name = "registry.localhost"
#   port {
#       host = "registry.localhost"
#       host_ip = "127.0.0.1"
#       host_port = "12345"
#   }
# }