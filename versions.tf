terraform {
  required_version = ">= 1.2.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
  }
}
