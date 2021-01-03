provider "helm" {
  kubernetes {
    config_path = "./kubeconfig_ekstf"
  }
}

# Generating a strong random password
resource "random_password" "password" {
  length    = 16
  special   = false
  min_upper = 2
  min_lower = 2
}

resource "helm_release" "jenkins" {
  name       = "jenkins"

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  # Installing required jenkins plugins.
  set {
    name = "controller.additionalPlugins[0]"
    value = "docker-build-step:2.6"
  }

  # Exposing jenkins to the internet using ELB
  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

  # Setting generated password as the jenkins admin password
  set {
    name  = "controller.adminPassword"
    value = random_password.password.result
  }
}