# Infrastructure

Terraform is used to create the infrastructure required for this project. The
main resource is an AWS Aurora PostgreSQL database instance which is created using the
[AWS RDS Aurora Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest).
This is used to store data collated from different sources
as described in our [high-level diagram](../docs/diagrams/high_level_diagram.png).

To manage Terraform state, an AWS S3 bucket is used as the backend.

To apply changes to infrastructure, a [CI pipeline](../.circleci/config.yml) is used.

## Creating a database for another environment

Currently, only a production database is used but one can be easily created in another
environment with how the Terraform code is structured.

As we're using a S3 bucket as the backend, a bucket must exist before being used
to store a Terraform state file. It's possible to create the bucket using the
AWS Console or use Terraform to do it with some acrobatics. To create the S3
bucket in production, we went with the acrobatics approach and instructions
below will outline this.

Below will be the final file structure.
```
infrastructure/
├── production/
│   ├── main.tf
│   └── state-persistence.tf
├── <environment>/
│   ├── main.tf
│   └── state-persistence.tf
├── shared/
│   └── main.tf # reusable database resources
```

### Declare AWS S3 bucket for Terraform state management

1. Create a new directory within `/infrastructure`

```bash
# Replace <environment> with the name of the environment
$ mkdir infrastructure/<environment>
```

2. Duplicate the `state-persistence.tf` file within `/infrastructure/production` directory into the new directory: `/infrastructure/<environment>`

```bash
# Replace <environment> with the name of the environment
$ cp infrastructure/production/state-persistence.tf infrastructure/<environment>/state-persistence.tf
```

3. Within `infrastructure/<environment>/state-persistence.tf`, update the bucket name used as the backend with the correct environment name on line 12 to `hackney-council-tax-bill-plan-b-terraform-state-<environment>`

```terraform
terraform {
  ...

  backend "s3" {
     region  = "eu-west-2"
     key     = "tf-remote-state"
     bucket  = "hackney-council-tax-bill-plan-b-terraform-state-production" # Update production with name of environment
     encrypt = true
   }
}
```

4. Within `infrastructure/<environment>/state-persistence.tf`, update the bucket name created with the correct environment name on line 22 to `hackney-council-tax-bill-plan-b-terraform-state-<environment>`

```terraform
resource "aws_s3_bucket" "terraform_state" {
  bucket = "hackney-council-tax-bill-plan-b-terraform-state-production" # Update production with name of environment
  acl    = "private"

  ...
}
```

5. Comment out the `backend` block (this means Terraform will manage state locally for a bit)
6. Change into the `/infrastructure/<environment>` directory

```bash
# Replace <environment> with the name of the environment
$ cd infrastructure/<environment>
```

### Create AWS S3 bucket for Terraform state management

Make sure you've signed into the AWS CLI of the AWS environment you want the database to be in e.g. `ProductionAPIs` , you are using the relevant AWS profile in your terminal and running the latest version of Terraform:

1. Initialise Terraform

```bash
$ terraform init
```

2. Run a plan of the infrastructure

```bash
$ terraform plan
```

The plan should only output that there will be 1 to add which will be the AWS S3
bucket.

3. Create the S3 bucket using Terraform

```bash
$ terraform apply

# You can verify its creation by running:
# aws s3 ls | grep "hackney-council-tax-bill"
```

4. Uncomment the `backend` block (this means Terraform will manage state using the S3 bucket)
5. Reinitialise Terraform

```bash
$ terraform init
```

6. Enter `yes` when Terraform asks if you want to copy existing state to the new backend (this means the S3 bucket configuration can be changed using Terraform)

### Declare resources for the database

1. Duplicate the `main.tf` file within `/infrastructure/production` directory into the new directory: `/infrastructure/<environment>`

```bash
# Replace <environment> with the name of the environment
$ cp infrastructure/production/main.tf infrastructure/<environment>/main.tf
```

This will declare all the resources required to set up the database by defining a `module` with `./shared` as the source. See [./shared/main.tf](./shared/main.tf) for the exact resources created.

2. Update the values for each variable used in the `module` in `infrastructure/<environment>/main.tf`

### Update CI pipeline for new environment

The CI pipeline needs to be updated to run Terraform on the new environment.

1. Add two new `jobs` to `.circleci/.config.yml` to run Terraform on the new environment by replicating the ones already declared for `production` but changing `production` and `PRODUCTION` to the name of the environment

```yaml
# Replace <environment> and <ENVIRONMENT> with the name of the environment
jobs:
  assume-role-production:
    executor: docker-python
    steps:
      - assume-role-and-persist-workspace:
          aws-account: $AWS_ACCOUNT_PRODUCTION
  terraform-init-and-apply-to-production:
    executor: docker-terraform
    steps:
      - terraform-init-then-apply:
          stage: "production"
  assume-role-<environment>:
    executor: docker-python
    steps:
      - assume-role-and-persist-workspace:
          aws-account: $AWS_ACCOUNT_<ENVIRONMENT>
  terraform-init-and-apply-to-<environment>:
    executor: docker-terraform
    steps:
      - terraform-init-then-apply:
          stage: "<environment>"
```

> **Tip:** Validate the CircleCI configuration by using [CircleCI CLI](https://circleci.com/docs/2.0/local-cli-getting-started/) and running `circleci config validate .circleci/config.yml`.

2. Add, commit and push files to GitHub
3. [View progress on CircleCI](https://app.circleci.com/pipelines/github/LBHackney-IT/council-tax-bill-plan-b?branch=master)

This will trigger CircleCI to create the database and other resources necessary
using Terraform which may take a while (around 15 minutes).
