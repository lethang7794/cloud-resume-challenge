provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "main" {
  bucket = "my-bucket-0fiesvn0oj"
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
  name                              = aws_s3_bucket.main.bucket_regional_domain_name
  description                       = aws_s3_bucket.main.bucket_regional_domain_name
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
    target_origin_id       = aws_s3_bucket.main.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}
