# Getting started

Let’s get started by bootstrapping Terraform and deploying some resources to AWS. Instead of just deploying some random resources, we want to create an S3 bucket and enable static website hosting. Ultimately, we serve a static HTML file.
  
## Bootstrap Terraform

1. Create a new folder and cd into it.
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
4. Replace the `main.tf` file by adding the first resource:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-central-1"
  }

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket        = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }
  ```
5. Run `terraform apply` and confirm the deployment with `yes`.

We just created an empty S3 bucket. Go to the [S3 console](https://s3.console.aws.amazon.com/s3/buckets) and verify the existence. 

What’s going on here? We created a `.tf` file: Terraform comes with its syntax called [HCL](https://www.terraform.io/language/syntax/configuration). In the `main.tf` file, we set the required Terraform version. After that, we configure a provider. Throughout the workshop, we focus on AWS and only deploy AWS resources. The [AWS provider](https://www.terraform.io/language/providers) gives us all the resources and data sources we need to describe AWS infrastructure.

Bare in mind, that Terraform provides [dozens of providers](https://registry.terraform.io/browse/providers) (e.g. Azure, Google Cloud Platform or even Auth0).

Now, after the provider, we have a data source and a resource. The resource block describes a simple S3 bucket. The configuration arguments (between `{` and `}`) describe the resource furthermore. S3 buckets always need a unique bucket name. To achieve this, we get the current AWS account id and append it to the bucket name. We get the AWS account id by using the `aws_caller_identity` data source. With data sources, we can fetch data outside of the Terraform stack and use it for resources.

Finally, we run `terraform apply` to deploy the resources.

## Outputs

Let’s extend the stack and deploy more resources:

1. Create a new file `index.html` next to the `main.tf`:
2. Add the following lines to the HTML file:
  ```html
  <!DOCTYPE html>
  <html>
    <body>
      <h1>Hello World :)</h1>
    </body>
  </html>
  ```
3. Replace the `main.tf` file:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-central-1"
  }

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket        = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }

  resource "aws_s3_object" "startpage" {
    bucket       = aws_s3_bucket.website.id
    key          = "index.html"
    source       = "index.html"
    acl          = "public-read"
    content_type = "text/html"
  }

  resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.bucket

    index_document {
      suffix = "index.html"
    }
  }
  ```
3. Create another file `outputs.tf` next to the `main.tf`. Add the following lines:
  ```tf
  output "website_url" {
    description = "Static website URL"
    value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
  }
  ```
4. Run `terraform apply` again and confirm with `yes`.

The new resources enable static website hosting and upload the `index.html` file. Feel free to go to the S3 console again and watch out for the HTML file.

We also introduced an output: Output is very helpful to retrieve certain data after deployment. Go back to the terminal and check the output. You should find something like this: 

```sh
Outputs:

website_url = "http://hello-world-website-XXXXXXXXXXX.s3-website-eu-central-1.amazonaws.com"
```

Thanks to the output, we can easily find the endpoint of the static website without navigating to the AWS Management Console. In addition, the output might be also interesting for automation (e.g. get the URL to run integration tests etc.).

## Remote Backend

Before we continue and go to the next lab, we need to talk about the Terraform state. As we apply changes, Terraform is always smart enough to update the AWS resources. How does it work? You might have noticed the auto-generated files `terraform.tfstate` and `terraform.tfstate.backup`. Terraform persists every single state of every AWS resource in the Terraform state. When applying a new update, Terraform compares the desired state with the current state and calculates a diff. Based on the diff, Terraform updates the AWS resources and also updates the state afterward. Without the Terraform state, Terraform would lose the connection to the AWS resources and wouldn’t know how to handle updates. As you can see, the Terraform state is very crucial.

Until now, we used local files for the Terraform state. That’s okay for a workshop but doesn’t work for production workloads. The problem is, that we always need the state to apply changes. So if you want to work on the same stack with a team or some form of automation, then you need to share the state with others. The recommended solution is a remote backend. In this workshop, we focus on an S3 bucket, but you have [different options](https://www.terraform.io/language/settings/backends). Instead of keeping the state locally, we upload the state to the S3 bucket and read the current status from there.

1. Create a new S3 bucket in the [AWS Management Console](https://s3.console.aws.amazon.com/s3/bucket/create?region=eu-central-1). Copy the name of the bucket afterward.
2. Go to the file `main.tf` and replace it:
  ```tf
  terraform {
    required_version = "~> 1.1.7"

    backend "s3" {
      key    = "terraform.tfstate"
      region = "eu-central-1"
    }
  }

  provider "aws" {
    region = "eu-central-1"
  }

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket        = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }

  resource "aws_s3_object" "startpage" {
    bucket       = aws_s3_bucket.website.id
    key          = "index.html"
    source       = "index.html"
    acl          = "public-read"
    content_type = "text/html"
  }

  resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.bucket

    index_document {
      suffix = "index.html"
    }
  }
  ```
3. Run `terraform init`. The command asks for the bucket name. Answer the question **Do you want to copy existing state to the new backend?** with **yes**.
4. Run `terraform apply`. Everything should still work.

Go to the S3 bucket in the AWS Management Console and check out the files. You should see a new file in the bucket. It’s still the same file like the one we had locally, but now in the cloud. Terraform takes care of updating the Terraform state automatically.

You might have noticed the manual creation of the S3 bucket. To keep it simple for the sake of the workshop, we create the bucket directly in the AWS Management Console. It’s a classic chicken and egg situation because we would like to use *infrastructure as code* to create the bucket for the remote backend as well, but therefore we need also a Terraform state. Though workarounds and solutions exist, but we won’t cover them here.

## Next

That’s it for the first lab. We learned more about the Terraform Language (provider, data sources, resources and outputs) and deployed some AWS resources. In the [next lab](../2-third-party/), we extend the stack and use a third-party module.
