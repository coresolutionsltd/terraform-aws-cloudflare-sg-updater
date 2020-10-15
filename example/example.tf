data "aws_vpc" "core" {
  filter {
    name   = "tag:Name"
    values = ["Core"]
  }
}


resource "aws_security_group" "sg1" {
  name        = "Cloudflare-SG-1"
  description = "Cloudflare SG Updater Example"
  vpc_id      = data.aws_vpc.core.id

  tags = {
    Name          = "Cloudflare-SG-1"
    CF-AutoUpdate = "true"
  }
}

resource "aws_security_group" "sg2" {
  name        = "Cloudflare-SG-2"
  description = "Cloudflare SG Updater Example"
  vpc_id      = data.aws_vpc.core.id

  tags = {
    Name          = "Cloudflare-SG-2"
    CF-AutoUpdate = "true"
    CF-Ports      = "8080,443"
  }
}

module "cloudflare-sg-updater" {
  source = "coresolutions-ltd/cloudflare-sg-updater/aws"
}
