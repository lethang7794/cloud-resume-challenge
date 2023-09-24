# Frontend Chunk - CLI

## Create S3 bucket

```shell
aws s3 mb s3://my-s3-bucket-edtf2cinzi --region ap-southeast-1
# make_bucket: my-s3-bucket-edtf2cinzi
```

## Upload website static file

```shell
# cd to root of website static folder
aws s3 sync . s3://my-s3-bucket-edtf2cinzi
# upload: css/style.css to s3://my-s3-bucket-edtf2cinzi/css/style.css
# upload: ./index.html to s3://my-s3-bucket-edtf2cinzi/index.html
```

## Create CloudFront distribution

### First we need an origin access control (OAC)

The OAC config

```yaml
# cloudfront--create-origin-access-control.yaml
OriginAccessControlConfig:
  Name: 'my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com' # <BUCKET NAME>.s3.<REGION>.amazonaws.com
  Description: 'My Origin Accsee Control - Created from AWS CLI'
  SigningProtocol: sigv4
  SigningBehavior: always
  OriginAccessControlOriginType: s3
```

Create OAC with CLI

```shell
aws cloudfront create-origin-access-control --cli-input-yaml file://cloudfront--create-origin-access-control.yaml
```

Output

```json
{
  "Location": "https://cloudfront.amazonaws.com/2020-05-31/origin-access-control/E2FV804DPJZRL0",
  "ETag": "ETVPDKIKX0DER",
  "OriginAccessControl": {
    "Id": "E2FV804DPJZRL0",
    "OriginAccessControlConfig": {
      "Name": "my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com",
      "Description": "My Origin Accsee Control - Created from AWS CLI",
      "SigningProtocol": "sigv4",
      "SigningBehavior": "always",
      "OriginAccessControlOriginType": "s3"
    }
  }
}
```

### Then we create the CloudFront distribution

#### Option 1: The CloudFront distribution (without a custom domain)

Let's generate the skeletion input for cloudfront create-distribution

```shell
# json config (to have a quick glance of the config structure)
aws cloudfront create-distribution --generate-cli-skeleton input > create-distribution-input.json

# yaml config (to have the comments about each fields)
aws cloudfront create-distribution --generate-cli-skeleton yaml-input > create-distribution-input.yaml
```

The distribution config

```yaml
DistributionConfig:
  CallerReference: my-cloudfront-distribution-cli
  DefaultRootObject: index.html
  Origins:
    Quantity: 1
    Items:
      - Id: my-origin-id
        DomainName: my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com
        S3OriginConfig:
          OriginAccessIdentity: ''
        OriginAccessControlId: E2FV804DPJZRL0
  DefaultCacheBehavior:
    TargetOriginId: my-origin-id
    ViewerProtocolPolicy: redirect-to-https
    Compress: true
    ForwardedValues:
      QueryString: true
      Cookies:
        Forward: all
      Headers:
        Quantity: 0
      QueryStringCacheKeys:
        Quantity: 0
    MinTTL: 3600
    DefaultTTL: 86400
  Comment: A CloudFront Distribution created with AWS CLI
  Enabled: true
```

Create the distribution

```shell
aws cloudfront create-distribution --cli-input-yaml file://cloudfront--create-distribution.yaml
```

Output

```json
{
  "Location": "https://cloudfront.amazonaws.com/2020-05-31/distribution/E3OFEFS1AV0UP4",
  "ETag": "E1YQH546TP9TLA",
  "Distribution": {
    "Id": "E3OFEFS1AV0UP4",
    "ARN": "arn:aws:cloudfront::735474573412:distribution/E3OFEFS1AV0UP4",
    "Status": "Deployed",
    "LastModifiedTime": "2023-08-29T07:49:21.156000+00:00",
    "InProgressInvalidationBatches": 0,
    "DomainName": "d2n9aayfmhg2j6.cloudfront.net",
    "ActiveTrustedSigners": {
      "Enabled": false,
      "Quantity": 0
    },
    "ActiveTrustedKeyGroups": {
      "Enabled": false,
      "Quantity": 0
    },
    "DistributionConfig": {
      "CallerReference": "my-cloudfront-distribution-cli",
      "Aliases": {
        "Quantity": 0
      },
      "DefaultRootObject": "index.html",
      "Origins": {
        "Quantity": 1,
        "Items": [
          {
            "Id": "my-origin-id",
            "DomainName": "my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com",
            "OriginPath": "",
            "CustomHeaders": {
              "Quantity": 0
            },
            "S3OriginConfig": {
              "OriginAccessIdentity": ""
            },
            "ConnectionAttempts": 3,
            "ConnectionTimeout": 10,
            "OriginShield": {
              "Enabled": false
            },
            "OriginAccessControlId": "E2FV804DPJZRL0"
          }
        ]
      },
      "OriginGroups": {
        "Quantity": 0
      },
      "DefaultCacheBehavior": {
        "TargetOriginId": "my-origin-id",
        "TrustedSigners": {
          "Enabled": false,
          "Quantity": 0
        },
        "TrustedKeyGroups": {
          "Enabled": false,
          "Quantity": 0
        },
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
          "Quantity": 2,
          "Items": ["HEAD", "GET"],
          "CachedMethods": {
            "Quantity": 2,
            "Items": ["HEAD", "GET"]
          }
        },
        "SmoothStreaming": false,
        "Compress": true,
        "LambdaFunctionAssociations": {
          "Quantity": 0
        },
        "FunctionAssociations": {
          "Quantity": 0
        },
        "FieldLevelEncryptionId": "",
        "ForwardedValues": {
          "QueryString": true,
          "Cookies": {
            "Forward": "all"
          },
          "Headers": {
            "Quantity": 0
          },
          "QueryStringCacheKeys": {
            "Quantity": 0
          }
        },
        "MinTTL": 3600,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000
      },
      "CacheBehaviors": {
        "Quantity": 0
      },
      "CustomErrorResponses": {
        "Quantity": 0
      },
      "Comment": "A CloudFront Distribution created with AWS CLI",
      "Logging": {
        "Enabled": false,
        "IncludeCookies": false,
        "Bucket": "",
        "Prefix": ""
      },
      "PriceClass": "PriceClass_All",
      "Enabled": true,
      "ViewerCertificate": {
        "CloudFrontDefaultCertificate": true,
        "SSLSupportMethod": "vip",
        "MinimumProtocolVersion": "TLSv1",
        "CertificateSource": "cloudfront"
      },
      "Restrictions": {
        "GeoRestriction": {
          "RestrictionType": "none",
          "Quantity": 0
        }
      },
      "WebACLId": "",
      "HttpVersion": "http2",
      "IsIPV6Enabled": true,
      "ContinuousDeploymentPolicyId": "",
      "Staging": false
    }
  }
}
```

Add policy to S3 bucket to allow access from the Cloudfront distribution

The policy can be copied from the Web Console (but we're using CLI, now we need to open the Web Console ???)

```json
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-s3-bucket-edtf2cinzi/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::735474573412:distribution/E3B64F0BQ121SK"
        }
      }
    }
  ]
}
```

```json
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<S3 BUCKET NAME>/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::<AWS ACCOUNT ID>:distribution/<CLOUDFRONT DISTRIBUTION ID>"
        }
      }
    }
  ]
}
```

Update S3 bucket policy to allow access from CloudFront distribution

```shell
aws s3api put-bucket-policy --bucket my-s3-bucket-edtf2cinzi --policy file://s3--bucket-policy.json --region us-east-1
```

#### Option 2: The CloudFront distribution (with a custom domain)

##### Request a TLS certifcate from ACM

CloudFront only accepts a certificate in the US East (N. Virginia) Region (us-east-1).

```shell
aws acm request-certificate --domain-name thanglq.com --domain-name "*.thanglq.com" --validation-method DNS --region us-east-1
```

Then open then Web Console to get the DNS CNAME record info for validation.

##### The CloudFront distribution (with a custom domain)

The distribution config

```yaml
DistributionConfig:
  CallerReference: my-cloudfront-distribution-cli # Used to ensure idempotence
  Aliases:
    Quantity: 1
    Items:
      - resume.thanglq.com
  DefaultRootObject: index.html
  Origins:
    Quantity: 1
    Items:
      - Id: my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com # It's the Origin name in Web Console
        DomainName: my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com
        S3OriginConfig:
          OriginAccessIdentity: ''
        OriginAccessControlId: E2FV804DPJZRL0
  DefaultCacheBehavior:
    TargetOriginId: my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com
    ViewerProtocolPolicy: redirect-to-https
    Compress: true
    ForwardedValues:
      QueryString: true
      Cookies:
        Forward: all
    MinTTL: 3600
  Comment: A CloudFront Distribution created with AWS CLI
  Enabled: true
  ViewerCertificate:
    ACMCertificateArn: arn:aws:acm:us-east-1:735474573412:certificate/4df6f0b0-48b7-4250-8b7e-609bb08185da
    SSLSupportMethod: sni-only
    MinimumProtocolVersion: TLSv1.2_2021
```

Create the distribution with CNAME

```shell
aws cloudfront create-distribution --cli-input-yaml file://cloudfront--create-distribution-minimal-cname.yaml
```

Output

```json
{
  "Location": "https://cloudfront.amazonaws.com/2020-05-31/distribution/E13J24DLLCF2DY",
  "ETag": "E2ZU3C2Q3506RS",
  "Distribution": {
    "Id": "E13J24DLLCF2DY",
    "ARN": "arn:aws:cloudfront::735474573412:distribution/E13J24DLLCF2DY",
    "Status": "Deployed",
    "LastModifiedTime": "2023-08-29T12:14:28.585000+00:00",
    "InProgressInvalidationBatches": 0,
    "DomainName": "dzbcmixsxptk8.cloudfront.net",
    "ActiveTrustedSigners": {
      "Enabled": false,
      "Quantity": 0
    },
    "ActiveTrustedKeyGroups": {
      "Enabled": false,
      "Quantity": 0
    },
    "DistributionConfig": {
      "CallerReference": "my-cloudfront-distribution-cli",
      "Aliases": {
        "Quantity": 1,
        "Items": ["resume.thanglq.com"]
      },
      "DefaultRootObject": "index.html",
      "Origins": {
        "Quantity": 1,
        "Items": [
          {
            "Id": "my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com",
            "DomainName": "my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com",
            "OriginPath": "",
            "CustomHeaders": {
              "Quantity": 0
            },
            "S3OriginConfig": {
              "OriginAccessIdentity": ""
            },
            "ConnectionAttempts": 3,
            "ConnectionTimeout": 10,
            "OriginShield": {
              "Enabled": false
            },
            "OriginAccessControlId": "E2FV804DPJZRL0"
          }
        ]
      },
      "OriginGroups": {
        "Quantity": 0
      },
      "DefaultCacheBehavior": {
        "TargetOriginId": "my-s3-bucket-edtf2cinzi.s3.ap-southeast-1.amazonaws.com",
        "TrustedSigners": {
          "Enabled": false,
          "Quantity": 0
        },
        "TrustedKeyGroups": {
          "Enabled": false,
          "Quantity": 0
        },
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
          "Quantity": 2,
          "Items": ["HEAD", "GET"],
          "CachedMethods": {
            "Quantity": 2,
            "Items": ["HEAD", "GET"]
          }
        },
        "SmoothStreaming": false,
        "Compress": true,
        "LambdaFunctionAssociations": {
          "Quantity": 0
        },
        "FunctionAssociations": {
          "Quantity": 0
        },
        "FieldLevelEncryptionId": "",
        "ForwardedValues": {
          "QueryString": true,
          "Cookies": {
            "Forward": "all"
          },
          "Headers": {
            "Quantity": 0
          },
          "QueryStringCacheKeys": {
            "Quantity": 0
          }
        },
        "MinTTL": 3600,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000
      },
      "CacheBehaviors": {
        "Quantity": 0
      },
      "CustomErrorResponses": {
        "Quantity": 0
      },
      "Comment": "A CloudFront Distribution created with AWS CLI",
      "Logging": {
        "Enabled": false,
        "IncludeCookies": false,
        "Bucket": "",
        "Prefix": ""
      },
      "PriceClass": "PriceClass_All",
      "Enabled": true,
      "ViewerCertificate": {
        "CloudFrontDefaultCertificate": false,
        "ACMCertificateArn": "arn:aws:acm:us-east-1:735474573412:certificate/4df6f0b0-48b7-4250-8b7e-609bb08185da",
        "SSLSupportMethod": "sni-only",
        "MinimumProtocolVersion": "TLSv1.2_2021",
        "Certificate": "arn:aws:acm:us-east-1:735474573412:certificate/4df6f0b0-48b7-4250-8b7e-609bb08185da",
        "CertificateSource": "acm"
      },
      "Restrictions": {
        "GeoRestriction": {
          "RestrictionType": "none",
          "Quantity": 0
        }
      },
      "WebACLId": "",
      "HttpVersion": "http2",
      "IsIPV6Enabled": true,
      "ContinuousDeploymentPolicyId": "",
      "Staging": false
    },
    "AliasICPRecordals": [
      {
        "CNAME": "resume.thanglq.com",
        "ICPRecordalStatus": "APPROVED"
      }
    ]
  }
}
```
