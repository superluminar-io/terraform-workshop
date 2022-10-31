# Getting started

Let’s get started by bootstrapping Terraform and out AWS environment.

## IDE
For the whole workshop we recommend to set up your IDE with Terraform support or to use an IDE with Terraform support
(e.g. [VS Code](https://code.visualstudio.com/) / [Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform))

## AWS credentials setup

Before you start you will need

- an AWS account that you can safely use during this workshop
- administrator credentials to this account
- install the aws cli according to the [documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
 
If you already have a mechanism in place for allowing access to AWS accounts (like [SAML](https://cloud.nwse.io/how-to/getting-started/login.html#terminal-cli) or AWS SSO), please use this. 
Otherwise, you can create an IAM users as described [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html#getting-started-prereqs-iam).

Lastly you have to publish your credentials to your shell environment. If you created an IAM user earlier, 
you can follow [this guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods) 
to configure your credentials with the `aws configure` command.

### Test your credentials setup

To make sure that your environment is set up correctly, you can use the following command:

```shell
$ aws sts get-caller-identity
{
    "UserId": "AIDASAMPLEUSERID",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/DevAdmin"
}
```
 
You should make sure, that the field `Account` has the same account id that you wanted to use.

## Bootstrap Terraform

### Install Terraform

During this workshop we will be using the terraform cli. To install we recommend that you use the 
[terraform version manager tfenv](https://github.com/tfutils/tfenv).

You can now install terraform using tfenv

```shell
$ tfenv install 1.1.9
```

Test if you are using the correct version afterwards

```shell
$ terraform --version
Terraform v1.1.9
...
```

### Bootstrap the Terraform project

1. Create a new folder `my-project` and cd into it.
1. Create a new file `main.tf`
2. Add these lines to the `main.tf`:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-central-1"
  }
  ```
3. Run `terraform init`

You should see some output similar to this:
```shell
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.27.0...
- Installed hashicorp/aws v4.27.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
...
```
## Next

Our AWS environment and the terraform project is now properly set up. In the [next lab](../1-getting-started/), we can start deploying a first resource to our AWS account.
