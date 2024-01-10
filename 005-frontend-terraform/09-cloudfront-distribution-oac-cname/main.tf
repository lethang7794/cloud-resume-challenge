terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

provider "aws" {
  region = "ap-southeast-1"
}


variable "s3_bucket_name" {
  description = "Name of the S3 bucket used as origin for Cloudfront distribution"
  type        = string
}

variable "root_domain" {
  description = "Root domain of the site to be issued certficate, e.g. example.com"
  type        = string
}

variable "cloudfront_alternate_domain_names" {
  description = <<-EOL
                  The custom domain names that you use in URLs for the files served by this distribution, e.g. ["example.com", "www.example.com"]
                EOL
  type        = set(string)
}

locals {
  bucket_domain_name = aws_s3_bucket.main.bucket_regional_domain_name
}

resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.main.bucket}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_control" "main" {
  name                              = local.bucket_domain_name
  description                       = local.bucket_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "main" {
  default_root_object = "index.html"
  enabled             = true
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = local.bucket_domain_name
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    domain_name              = local.bucket_domain_name
    origin_id                = local.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = length(var.cloudfront_alternate_domain_names) == 0 ? true : false
    acm_certificate_arn            = length(var.cloudfront_alternate_domain_names) > 0 ? aws_acm_certificate.cert[0].arn : null
    ssl_support_method             = "sni-only"
  }
  aliases = length(var.cloudfront_alternate_domain_names) > 0 ? var.cloudfront_alternate_domain_names : null
}

resource "aws_acm_certificate" "cert" {
  count = length(var.root_domain) > 0 ? 1 : 0

  provider = aws.us_east_1

  domain_name               = var.root_domain
  subject_alternative_names = ["*.${var.root_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = var.root_domain
  }
}

resource "aws_acm_certificate_validation" "cert" {
  count = length(var.root_domain) > 0 ? 1 : 0

  provider = aws.us_east_1

  certificate_arn = aws_acm_certificate.cert[0].arn
}


output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_alternate_domain_names" {
  value = aws_cloudfront_distribution.main.aliases
}
