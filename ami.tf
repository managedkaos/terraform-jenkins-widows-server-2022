data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Core-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
