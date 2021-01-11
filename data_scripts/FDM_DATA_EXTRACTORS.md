# FDM Data Extractors

We've currently have 3 data extractor scripts for FDM print files:

- `/data_scripts/fdm_extractor.py` - to extract data from FDM bill print files
- `/data_scripts/fdm_exemption_reason_extractor.py` - to extract exemption reasons from FDM exemption print files
- `/data_scripts/fdm_premium_extractor.py` - to extract the premium from FDM bill print files

## FDM extractor

This script will take FDM data files supplied from the Council Tax billing done in March 2020 and extract the following fields for standard bill formats:

`lead liability name`
`additional liable persons names`
`valuation office band`
`account number`
`discounts`
`reductions`

And using a variable in the script we get some details from the FDM file for exempt notices.

`account_number`
`lead liability name`
`additional liable persons names`
`valuation office band`

### Usage

1. Open the [FDM extractor script](./fdm_extractor.py)
2. Update the `file_to_parse`, `output_file_name`, `output_sql_file_name` and `exemptions_file` to be correct for your use case
3. Run the script and the output file will be generated at the path you entered
```bash
$ python /data_scripts/fdm_extractor.py
```

## FDM exemption reasons extractor

This script takes the exemption reasons from FDM data into a CSV and SQL
files so that we can append the exemption reason to the existing FDM
data.

*INPUT DATA*: This was proving to be a challenge, so we manually updated the
input files to feature "class [A-Z]" on its own line. So for example
using a regex Find and replace on `class [A-Z]` we output the class and
classification letter on a new line. So the old data file would inclue
(newlines are literal here):

```
because it falls into the category of exempt class N which is OCCUPIED - ALL
OCCUPIERS ARE STUDENTS.
```
The curated data for extraction should be:
```
because it falls into the category of exempt
class N
  which is OCCUPIED - ALL
OCCUPIERS ARE STUDENTS.
```

### Usage

1. Open the [FDM exemption reason extractor script](./fdm_exemption_reason_extractor.py)
2. Update the `file_to_parse`, `output_file_name` and `output_sql_file_name` to be correct for your use case
3. Run the script and the output file will be generated at the path you entered
```bash
$ python /data_scripts/fdm_exemption_reason_extractor.py
```

## FDM premium extractor

This script takes the premium from FDM data into a CSV and SQL
files so that we can append the premium reason to the existing FDM
data.

### Usage

1. Open the [FDM premium extractor script](./fdm_premium_extractor.py)
2. Update the `file_to_parse`, `output_file_name` and `output_sql_file_name` to be correct for your use case
3. Run the script and the output file will be generated at the path you entered
```bash
$ python /data_scripts/fdm_premium_extractor.py
```

## Note

We're not proud of these scripts, it's brittle, untested and basically cobbled together using trial and error. Improvements could be made by mapping data to a dict instead of appending directly to the `record` however this wasn't straight forward for a couple reasons but should be possible. Ideally convert to a command line tool to run the data extracts, but with luck this is going to be a one time use bit of code.