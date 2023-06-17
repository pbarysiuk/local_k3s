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