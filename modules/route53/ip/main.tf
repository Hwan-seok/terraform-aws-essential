resource "aws_route53_record" "vpn" {
  zone_id = var.connect_route53_zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [var.connect_ip]
}
