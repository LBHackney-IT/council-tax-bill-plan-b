# Hackney Council Tax Billing Plan B

## Getting started

### Prerequisites

- [AWS Command Line Interface (CLI)](https://aws.amazon.com/cli/) (v2) - to manage AWS RDS database
- [Session Manager plugin for AWS CLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) (v2) - to connect to the database
- [Terraform](https://www.terraform.io/) - to manage infrastructure e.g. database in environments
- [Python](https://www.python.org/) (>= 3.6) - to extract data into CSV files from data sources
- [Graphviz](https://graphviz.gitlab.io/download/) - to generate diagrams

### Set up connection to the database

Assuming you've been added to AWS for Hackney:

1. Configure Single Sign-On (SSO) for AWS CLI
```
$ aws configure sso
SSO start URL [None]: https://d-936715b9ec.awsapps.com/start#/
SSO region [None]: eu-west-1
```

AWS CLI will then attempt to open your default browser and begin the login
process for your AWS SSO account.

It will then show you the accounts available to you.

2. Select to use the `DevelopmentAPIs` account
3. Enter a name for the CLI profile e.g. `hackney-dev`
4. Verify the profile by listing AWS S3 buckets
```
$ aws s3 ls --profile hackney-dev
```

You can set a default AWS profile so you don't have to use `--profile` all the
time by adding `export AWS_PROFILE=hackney-dev` to your `.zshrc` for example.

## Usage

### Connecting to the database

1. Sign into AWS CLI using SSO
```
$ aws sso login
```

AWS CLI will then attempt to open your default browser and begin the login
process for your AWS SSO account.

2. Run the script to open a tunnel to the database in development

```
$ ./bin/open_db_tunnel development
```
3. Retrieve the database password using AWS Systems Manager (SSM)
```
$ aws ssm get-parameter --output text --query Parameter.Value --name /council-tax-plan-b/development/database-master-password --with-decryption
```
4. Using a SQL client, e.g. [Postico](https://eggerapps.at/postico/), [DataGrip](https://www.jetbrains.com/datagrip/), connect to the database with the following:
   - Host: `localhost`
   - Port: `5433`
   - Password: (value from Step 3)
   - Database: `council_tax`

### Data extraction scripts

See [FDM Data Extractors](data_scripts/FDM_DATA_EXTRACTORS.md).

### Infrastructure

*TODO*

### High-level diagram

The [high-level diagram](./docs/high_level_diagram.png) is generated using [Diagrams by mingrammer](https://diagrams.mingrammer.com/) which allows you to create diagrams by writing Python code.

1. Install diagrams
```bash
$ pip install diagrams
```
2. Update [high_level_diagram.py](./docs/high_level_diagram.py) (see [Diagrams' documentation](https://diagrams.mingrammer.com/docs/guides/diagram))
3. Change directory into `/docs` so the new image replaces the current one
```bash
$ cd docs
```
4. Run the script to generate the diagram
```bash
$ python high_level_diagram.py
```
5. Commit the updated image and Python script

## Documentation

- [Database](./docs/database.md) - overview of the database
- [Database changelog](./docs/database_changelog.md) - a log of changes made to our database
- [Database queries](./docs/database_queries.md) - SQL queries used to extract data
