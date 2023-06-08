module "cluster" {
  source = "./module/k3d"
}

module "monitoring" {
  source     = "./module/monitoring"
  depends_on = [module.cluster]
}

module "ingress" {
  source = "./module/ingress"
  depends_on = [module.cluster]
}