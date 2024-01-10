# Infrastructure as Code for my Cloudflare DNS

## Prerequisites

- [`terraform` CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), recommend install by [`tfenv`](https://github.com/tfutils/tfenv)

- API Token for Cloudflare account

  > Follow this tutorial [Create a scoped Cloudflare API token](https://developer.hashicorp.com/terraform/tutorials/aws/cloudflare-static-website#create-a-scoped-cloudflare-api-token)

  ```shell
  # ~/.zshrc
  # Cloudflare API Token
  export CLOUDFLARE_API_TOKEN='Hzsq3Vub-7Y-hSTlAaLH3Jq_YfTUOCcgf22_Fs-j'
  ```

- Cloudflare Zone ID

  ```shell
  curl -X GET "https://api.cloudflare.com/client/v4/zones" \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type:application/json" | jq -r ".result.[0].id"
  ```

  ```shell
  # ~/.zshrc
  # Cloudflare zone ID
  export CLOUDFLARE_ZONE_ID='81b06ss3228f488fh84e5e993c2dc17'
  ```
