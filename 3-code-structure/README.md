# Code Structure

We already created some input variables, resources, modules, and outputs. Let's talk about naming conventions and code structure best practices to keep the Terraform stack clean. In general, it's good practice to split up the codebase into multiple files. And again, we shouldn't reinvent the wheel and follow best practices by the community. 

[Anton Babenko](https://twitter.com/antonbabenko) wrote an awesome ebook collecting many best practices for Terraform. The [ebook](https://www.terraform-best-practices.com/) is a must-read for every Terraform developer!

Based on the [best practices](https://www.terraform-best-practices.com/code-structure), we should split up the `main.tf` file and introduce two new files: 

```sh
touch outputs.tf variables.tf
```

Now, move all outputs into the `outputs.tf` and the input variable into the `variables.tf`. That's it so far!

Please take a few minutes and read the [naming conventions](https://www.terraform-best-practices.com/naming) part in the ebook. It might be helpful to get a better understanding of Terraform in general.

## Next

The [next lab](../4-environments/) covers a very important topic: Instead of just deploying the stack once, we want to deploy the stack for multiple environments. Imagine, we want to have a `staging` and `production` environment, probably with slightly different configurations. 
