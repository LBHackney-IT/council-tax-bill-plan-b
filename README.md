# Hackney Council Tax Billing Plan B

## Getting started

### Prerequisites

- [AWS Command Line Interface (CLI)](https://aws.amazon.com/cli/) - to manage AWS RDS database
- [Terraform](https://www.terraform.io/) - to manage infrastructure e.g. database in environments
- [Python](https://www.python.org/) (>= 3.6) - to extract data into CSV files from data sources
- [Graphviz](https://graphviz.gitlab.io/download/) - to generate diagrams

## Usage

### Data extraction scripts

See [FDM Data Extractor Script](data_scripts/FDM_DATA_EXTRACTOR.md).

### Infrastructure

*TODO*

### High-level diagram

The [high-level diagram](./docs/high_level_diagram.png) is generated using [Diagrams by mingrammer](https://diagrams.mingrammer.com/) which allows you to create diagrams by writing Python code.

1. Install diagrams

```bash
$ pip install diagrams
```

2. Update [high_level_diagram.py](./docs/high_level_diagram.py) (see [Diagrams' documentation](https://diagrams.mingrammer.com/docs/guides/diagram))
3. Change directory into /docs so the new image replaces the current one

```bash
$ cd docs
```

4. Run the script to generate the diagram

```bash
$ python high_level_diagram.py
```

5. Commit the updated image

## Documentation

- [Database](./docs/database.md) - overview of the database
- [Database changelog](./docs/database_changelog.md) - a log of changes made to our database
- [Database queries](./docs/database_queries.md) - SQL queries used to extract data
