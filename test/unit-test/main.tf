provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "example_sa" {
  source = "../"

  namespace           = "my-namespace"
  github_repositories = ["my-repo"]
  enable_sa_env_secret   = true
}
