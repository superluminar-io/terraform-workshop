# Terraform Workshop
> Learn infrastructure as code basics w/ Terraform

## Prerequisites

Make sure you have the following tools installed on your computer: 

- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [AWS credentials in the terminal](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- IDE with Terraform support (e.g. [VS Code](https://code.visualstudio.com/) / [Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform))

## Labs

1. [Bootstrap](./1-bootstrap): Get started with Terraform and deploy your first AWS resource. Learn more about data sources along the way.
2. [Hello World](./2-hello-world/): Extend the codebase and create a simple HTTP API w/ AWS API Gateway and AWS Lambda
3. [Code Structure](./3-code-structure/): Refactor the codebase and learn more about naming conventions and commong code structures.
4. [Environments](./4-environments/): Extend the codebase and prepare everything for multiple environments (e.g. staging and prod). Learn more about modules.
5. [Remote Backend](./5-backend/): Manage Terraform state remotely using AWS S3.
6. [Terragrunt](./5-backend/): Use Terragrunt to automate the creation of the remote state and clean up the environments.
   
## License

See [LICENSE](./LICENSE.md).
