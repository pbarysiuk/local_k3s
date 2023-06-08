terraform {
  required_version = "~> 1.0"

  required_providers {
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "~>0.0.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.9.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
  //config_context = module.cluster.cluster_name
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}