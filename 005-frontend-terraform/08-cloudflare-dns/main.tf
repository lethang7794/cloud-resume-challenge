###############################################################################
# CNAME *.thanglq.com
###############################################################################
resource "cloudflare_record" "www" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "thanglq.com"
  zone_id = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "cv" {
  name    = "cv"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "d14fbeuz1w7lqe.cloudfront.net"
  zone_id = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "resume" {
  name    = "resume"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "cv.thanglq.com"
  zone_id = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "stg" {
  name    = "stg"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "cname.vercel-dns.com"
  zone_id = "1762f873513f99798276553abcad7080"
}

###############################################################################
# iCloud Mail
###############################################################################
resource "cloudflare_record" "icloud_cname" {
  comment = "iCloud Mail"
  name    = "sig1._domainkey"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "sig1.dkim.thanglq.com.at.icloudmailadmin.com"
  zone_id = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "icloud_mx01" {
  comment  = "iCloud Mail"
  name     = "thanglq.com"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "mx01.mail.icloud.com"
  zone_id  = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "icloud_mx02" {
  comment  = "iCloud Mail"
  name     = "thanglq.com"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "mx02.mail.icloud.com"
  zone_id  = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "icloud_txt_icloud" {
  comment = "iCloud Mail"
  name    = "thanglq.com"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=spf1 include:icloud.com ~all"
  zone_id = "1762f873513f99798276553abcad7080"
}

resource "cloudflare_record" "icloud_txt_apple_domain" {
  comment = "iCloud Mail"
  name    = "thanglq.com"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "apple-domain=yh9y9deSHbOjiriH"
  zone_id = "1762f873513f99798276553abcad7080"
}

###############################################################################
# Vercel
###############################################################################
resource "cloudflare_record" "vercel" {
  comment = "Vercel"
  name    = "thanglq.com"
  proxied = true
  ttl     = 1
  type    = "A"
  value   = "76.76.21.21"
  zone_id = "1762f873513f99798276553abcad7080"
}

###############################################################################
# AWS Certificate Manager
###############################################################################
resource "cloudflare_record" "aws_acm" {
  comment = "AWS ACM"
  name    = "_79249924f8cc044bdf1936752bc64db4"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "_3974e14547309ae84f8f0f021bae7798.vlvttdkdcz.acm-validations.aws."
  zone_id = "1762f873513f99798276553abcad7080"
}
