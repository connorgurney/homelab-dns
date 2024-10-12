# DNS zone itself
resource "aws_route53_zone" "this" {
  name = "internal.connorgurney.me.uk"
}

# Root TXT records
# I do this here as Amazon Route 53 doesn’t support having more than one TXT
# record at the root of the zone.
resource "aws_route53_record" "root_txt" {
  zone_id = aws_route53_zone.this.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "3600"
  records = [
    # Email SPF
    "v=spf1 include:spf.protection.outlook.com -all"
  ]
}

# Email routing
resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.this.zone_id
  name    = ""
  type    = "MX"
  ttl     = "3600"
  records = [
    "0 internal-connorgurney-me-uk.mail.protection.outlook.com"
  ]
}

# Email DMARC
resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=DMARC1; p=reject; adkim=s; aspf=s; fo=1; rua=mailto:postmaster@connorgurney.me.uk; ruf=mailto:postmaster@connorgurney.me.uk"
  ]
}

# Email DKIM
resource "aws_route53_record" "dkim_1" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "selector1._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "selector1-internal-connorgurney-me-uk._domainkey.connorgurney.onmicrosoft.com"
  ]
}

resource "aws_route53_record" "dkim_2" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "selector2._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "selector2-internal-connorgurney-me-uk._domainkey.connorgurney.onmicrosoft.com"
  ]
}

# Email autodiscovery
resource "aws_route53_record" "autodiscover" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "autodiscover"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "autodiscover.outlook.com"
  ]
}

# MDM registration
resource "aws_route53_record" "mdm_registration" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "enterpriseregistration"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "enterpriseregistration.windows.net"
  ]
}

# MDM enrollment
resource "aws_route53_record" "mdm_enrollment" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "enterpriseenrollment"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "enterpriseenrollment-s.manage.microsoft.com"
  ]
}
