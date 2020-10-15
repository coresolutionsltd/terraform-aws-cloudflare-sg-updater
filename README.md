[![alt text](https://coresolutions.ltd/media/core-solutions-82.png "Core Solutions")](https://coresolutions.ltd)

[![maintained by Core Solutions](https://img.shields.io/badge/maintained%20by-coresolutions.ltd-00607c.svg)](https://coresolutions.ltd)
[![GitHub tag](https://img.shields.io/github/v/tag/coresolutions-ltd/terraform-aws-cloudflare-sg-updater.svg?label=latest)](https://github.com/coresolutions-ltd/terraform-aws-cloudflare-sg-updater/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12-623ce4.svg)](https://github.com/hashicorp/terraform/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# Cloudflare SG Updater Terraform Module

A Terraform module to automatically update Security Group ingress rules with the latest public Cloudflare IP ranges.

The lambda function uses tags to identify security groups it needs to update, below is a list of the tags available:

| key           | Description                                 | value       | Default | Required |
| ------------- | ------------------------------------------- | ------------| --------| -------- |
| CF-AutoUpdate | If true the Security group will be updated. | true        | None    | yes      |
| CF-Ports      | Comma seperated list of ports to use.       | `80,443...` | `443`   | no       |

## Getting Started

```sh
module "cloudflare-sg-updater" {
    source  = "coresolutions-ltd/cloudflare-sg-updater/aws"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Whether the Cloudflare SG Updater Lambda runs or not | `bool` | `true` | no |
| name | Name value for resources | `string` | `"Cloudflare-SG-Updater"` | no |
| schedule | The cloudwatch schedule used to run the Lambda. | `string` | `"cron(0 20 * * ? *)"` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | n/a |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
