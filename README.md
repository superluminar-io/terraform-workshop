# 🎓 Terraform Workshop
> Learn infrastructure as code basics w/ Terraform and AWS

The workshop empowers you to know the core concepts of *infrastructure as code* by using practical examples in Terraform. Learn how to create the first Terraform stack and deploy some resources to AWS. We explore best practices and improve the growing codebase over time.

## ✨ At a glance

* ✅ Set up a new Terraform project from scratch
* ✅ Get familiar with the Terraform Language
* ✅ Manage Terraform state using a remote backend with AWS S3
* ✅ Learn the fundamentals of module composition
* ✅ Deploy multiple environments (e.g. staging and prod)
* ✅ Implement a feature flag and learn more about parameterization

## 🤓 Labs

We recommend you walk through the labs step by step and follow the instructions. Feel free to further extend the stack, play around with resources and dive deeper. Have fun ✌️

0. [Boostrap Environment](./0-bootstrap) Please double-check the instructions and set up your working environment
1. [Getting Started](./1-getting-started): Get started with Terraform, deploy some AWS resources, and create a remote backend for the Terraform state
2. [Third Party](./2-third-party/): Use a third-party *module* to easily build and deploy an AWS Lambda function
3. [Module Composition](./3-module-composition/): Improve the growing codebase by introducing custom modules and module composition
4. [Multi Environment](./4-multi-environment/): Make the Terraform configuration ready for a multi-environment setup
5. [Parameterization](./5-parameterization/): Implement a feature flag and enable the new feature only on staging

## 📖 Further Reading

- Best practices for [code structure](https://www.terraform-best-practices.com/code-structure) and [naming conventions](https://www.terraform-best-practices.com/naming)
- [Testing Terraform modules and configurations](https://www.hashicorp.com/blog/testing-hashicorp-terraform)
- [Static analysis of the Terraform code using tfsec](https://github.com/aquasecurity/tfsec)
- [Awesome Terraform: Curated list of resources on Terraform](https://github.com/shuaibiyy/awesome-terraform)
- [DRY improvements using Terragrunt (Advanced)](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/)

## 👩‍⚖️ License

See [LICENSE](./LICENSE).
