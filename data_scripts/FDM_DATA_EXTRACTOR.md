# FDM Data Extractor Script

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

## Using the tool

Open the script, and update the `file_to_parse`, `output_file_name` and `exemptions_file` to be correct for your use case.

Run `python fdm_extractor.py` and the output file will be generated at the path you entered.

Note: I am not proud of this script, it's brittle, untested and basically cobbled together using trial and error. Improvements could be made by mapping data to a dict instead of appending directly to the `record` however this wasn't straight forward for a couple reasons but should be possible. Ideally convert to a command line tool to run the data extracts, but with luck this is going to be a one time use bit of code.
