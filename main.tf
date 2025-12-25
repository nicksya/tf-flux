module "kind_cluster" {
  source = "github.com/den-vasyliev/tf-kind-cluster"
}

# output "client_key" {
#   value = kind_cluster.this.client_key
# }

# output "ca" {
#   value = kind_cluster.this.cluster_ca_certificate
# }

# output "crt" {
#   value = kind_cluster.this.client_certificate
# }

# output "endpoint" {
#   value = kind_cluster.this.endpoint
# }

module "flux_bootstrap" {
  source            = "github.com/den-vasyliev/tf-fluxcd-flux-bootstrap?ref=kind_auth"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
  private_key       = module.tls_private_key.private_key_pem
  config_host       = module.kind_cluster.endpoint
  config_client_key = module.kind_cluster.client_key
  config_ca         = module.kind_cluster.ca
  config_crt        = module.kind_cluster.crt
  github_token      = var.GITHUB_TOKEN
}

# module "flux_bootstrap" {
#   source            = "github.com/den-vasyliev/tf-fluxcd-flux-bootstrap"
#   github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
#   private_key       = module.tls_private_key.private_key_pem
#   config_path       = module.gke_cluster.kubeconfig
#   github_token      = var.GITHUB_TOKEN
# }

module "github_repository" {
  source                   = "github.com/den-vasyliev/tf-github-repository"
  github_owner             = var.GITHUB_OWNER
  github_token             = var.GITHUB_TOKEN
  repository_name          = var.FLUX_GITHUB_REPO
  public_key_openssh       = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux"
}

module "tls_private_key" {
  source      = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
  algorithm   = "RSA"
  ecdsa_curve = "P256"
}

# output "private_key_pem" {
#   value = module.tls_private_key.private_key_pem
# }

# output "public_key_openssh" {
#   value = module.tls_private_key.public_key_openssh
# }
