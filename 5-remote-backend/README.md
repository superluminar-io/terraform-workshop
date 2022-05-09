# Remote Backend

In the last lab of the Terraform workshop, we need to talk about the state. A very important part of *infrastructure as code*. During the workshop, we applied many changes and Terraform was always smart enough to update the AWS resources. How does it work? You might have noticed the auto-generated files `terraform.tfstate` and `terraform.tfstate.backup`. Terraform persists every single state of every AWS resource in the Terraform state. When applying a new update, Terraform compares the desired state with the current state and calculates a diff. Based on the diff, Terraform update the AWS resources and also update the state afterwards. Without the Terraform state, Terraform would lose the connection to the AWS resources and wouldn't know how to handle updates. As you can see, the Terraform state is very crucial.

Until now, we used local files for the Terraform state. That's okay for a workshop but doesn't work for production workloads. The problem is, that we always need the state to apply changes. So if you want to work on the same stack with a team or some form of automation, then you need to share the state with others. The recommended solution is a remote backend. In this workshop, we focus on an S3 bucket, but you have [different options](https://www.terraform.io/language/settings/backends). Instead of keeping the state locally, we upload the state to the S3 bucket and read the current status from there.

## Configure the backend

1. Create a new S3 bucket in the [AWS management console](https://s3.console.aws.amazon.com/s3/bucket/create?region=eu-west-1). Copy the name of the bucket afterward.
2. Go to the file `staging/main.tf` and replace it:
  ```tf
  terraform {
    required_version = "~> 1.1.7"

    backend "s3" {
      key    = "staging/terraform.tfstate"
      region = "eu-west-1"
    }
  }

  provider "aws" {
    region = "eu-west-1"
  }

  module "website" {
    source = "../modules/website"

    environment = "staging"
  }

  module "api" {
    source = "../modules/api"

    environment             = "staging"
    enable_greeting_feature = true
  }
  ```
3. Run `terraform init`. The command asks for the bucket name. 
4. Run `terraform apply`. Everything should still work.

Go to the S3 bucket in the AWS management console and check out the files. You should see a new file under `staging/terraform.tfstate`. It's still the same file like the one we had locally, but now in the cloud. Terraform takes care of updating the Terraform state automatically.

Repeat the procedure for the production environment but make sure you rename the key to `prod/terraform.tfstate`.

**Note:** This is a very basic setup for a remote backend. Please read the [documentation](https://www.terraform.io/language/settings/backends/s3) for more hints.

## Final words

Thank you so much for going through all the labs. We hope you enjoyed it!
