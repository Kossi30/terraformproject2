terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }
}
provider "aws" {
  region = "us-west-1"
}
#Hosted Zone
resource "aws_route53_zone" "primary" {
  name = "saltouintserv.com"
}
#Simple Routing Policy
#resource "aws_route53_record" "www" {
  #zone_id = aws_route53_zone.primary.zone_id
  #name    = "www.saltouintserv.com"
 # type    = "A"
  #ttl     = "150"
  #records = [aws_eip.eip.public_ip]
#}
resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "dev"
  records        = ["dev.saltouintserv.com"]
}

resource "aws_route53_record" "www-live" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 90
  }

  set_identifier = "live"
  records        = ["live.saltouintserv.com"]
}
