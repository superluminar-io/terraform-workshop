# 🎓 Terraform Workshop
> Learn infrastructure as code basics w/ Terraform and AWS

The workshop addresses infrastructure as code and Terraform basics. Learn how to create the first Terraform stack and deploy some resources to AWS. We explore best practices and improve the growing codebase over time.

## ✨ At a glance

* ✅ Learn how to setup Terraform
* ✅ Learn how to deploy a simple HTTP API using AWS API Gateway and AWS Lambda
* ✅ Learn how to maintain multiple environments (e.g. staging and prod) with module composition
* ✅ Learn how to manage remote states using AWS S3
* ✅ Learn how to improve a growing codebase with Terragrunt

## 👾 Prerequisites

Before jumping to the first lab, please double-check the list and prepare your computer.

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [AWS credentials in the terminal](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- IDE with Terraform support (e.g. [VS Code](https://code.visualstudio.com/) / [Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform))
- [tfenv (recommended)](https://github.com/tfutils/tfenv)

## 🤓 Labs

We recommend you walk through the labs step by step and follow the instructions. Feel free to further extend the stack, play around with resources and dive deeper. Have fun ✌️

1. [Static Hosting](./1-static-hosting): Get started with Terraform and deploy the first AWS resources
2. [Simple API](./2-simple-api/): Extend the codebase and create a simple HTTP API using AWS API Gateway and AWS Lambda
3. [Environments](./3-environments/): Extend the codebase and prepare everything for multiple environments (e.g. staging and prod). Learn more about modules.
4. [Feature flags](./3-feature-flags/): Introduce a feature flag for the API and learn more about parameterization.
5. [Remote Backend](./5-remote-backend/): Manage Terraform state remotely using AWS S3.
6. [Terragrunt](./6-terragrunt/): Use Terragrunt to automate the creation of the remote state and clean up the environments.

## 📖 Further Reading

- Best practices for [code structure](https://www.terraform-best-practices.com/code-structure) and [naming conventions](https://www.terraform-best-practices.com/naming)

## 👩‍⚖️ License

See [LICENSE](./LICENSE.md).
