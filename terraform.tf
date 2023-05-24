terraform {
  required_version = "~> 1.4"

  backend "s3" {
    key    = "terraform-jenkins-server/terraform.tfstate" # the directory/file.tfstate
    bucket = "tf-state-storage-a1e1e6a446badf3f0570560f1e81be127a6a7d75"
    region = "us-east-2"
  }
}
