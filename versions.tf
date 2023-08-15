terraform {
  required_version = ">= 1.2.5"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
