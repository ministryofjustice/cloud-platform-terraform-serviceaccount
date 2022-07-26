terraform {
  required_version = ">= 0.14"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
