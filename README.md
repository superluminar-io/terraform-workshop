# 🎓 Terraform Workshop
> Learn infrastructure as code basics w/ Terraform and AWS

The workshop empowers you to know the core concepts of *infrastructure as code* by using practical examples in Terraform. Learn how to create the first Terraform stack and deploy some resources to AWS. We explore best practices and improve the growing codebase over time.

## ✨ At a glance

* ✅ Set up a new Terraform project from scratch
* ✅ Get familiar with the Terraform Language
* ✅ Learn the fundamentals of module composition
* ✅ Deploy multiple environments with different configurations (e.g. staging and prod)
* ✅ Manage Terraform remote states using AWS S3

## 👾 Prerequisites

Before jumping to the first lab, please double-check the list and prepare your computer.

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [AWS credentials in the terminal](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- IDE with Terraform support (e.g. [VS Code](https://code.visualstudio.com/) / [Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform))
- [tfenv (recommended)](https://github.com/tfutils/tfenv)

## 🤓 Labs

We recommend you walk through the labs step by step and follow the instructions. Feel free to further extend the stack, play around with resources and dive deeper. Have fun ✌️

1. [Getting started](./1-getting-started): Get started with Terraform, deploy some AWS resources, and create a remote backend for the Terraform state
2. [Modules](./2-modules/): Learn more about *modules* by deploying a simple AWS Lambda function
3. [Composition](./3-composition/): Refactor the codebase by creating modules and preparing everything for a multi-environment setup (e.g. staging and prod)
4. [Parameterization](./4-parameterization/): Extend the API by introducing a new feature and enable it only on staging

## 📖 Further Reading

- Best practices for [code structure](https://www.terraform-best-practices.com/code-structure) and [naming conventions](https://www.terraform-best-practices.com/naming)

## 👩‍⚖️ License

See [LICENSE](./LICENSE).
