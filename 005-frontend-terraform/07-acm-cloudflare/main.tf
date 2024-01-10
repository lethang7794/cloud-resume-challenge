terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

provider "cloudflare" {
}

variable "site_domain" {
  type    = string
  default = "thanglq.com"
}

resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1

  domain_name               = var.site_domain
  subject_alternative_names = ["*.${var.site_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = var.site_domain
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.us_east_1

  certificate_arn = aws_acm_certificate.cert.arn
}


# data "cloudflare_zones" "domain" {
#   filter {
#     name = var.site_domain
#   }
# }

# resource "cloudflare_record" "acm" {
#   allow_overwrite = true

#   zone_id = data.cloudflare_zones.domain.zones[0].id

#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       record_name  = dvo.resource_record_name
#       record_value = dvo.resource_record_value
#       record_type  = dvo.resource_record_type
#     }
#   }

#   name  = split(each.value.record_name, ".")[0]
#   value = each.value.record_value
#   type  = trimsuffix(each.value.record_type, ".")

#   // Must be set to false. ACM validation false otherwise
#   proxied = false

#   comment = "AWS ACM - ${var.site_domain} - Managed by Terraform"
# }

# output "domain_validation_options" {
#   value = aws_acm_certificate.cert.domain_validation_options
# }
