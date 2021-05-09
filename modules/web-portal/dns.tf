


resource "aws_route53_record" "wildcard" {
  zone_id = var.aws_dns_zone_id
  name    = var.wildcard
  type    = "CNAME"
  ttl     = "300"
  records = [var.lb]
}