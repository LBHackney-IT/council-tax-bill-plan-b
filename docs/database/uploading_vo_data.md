# Uploading Direct Debit data

The valuation office property band data is supplied in an excel/csv file which should be imported into the database. It's a row for each account in `aws_academy_recovered_october` with details on valuation office band, new band, previous band, effective date and reason for change.

The supplied file will include all the data, including that which is already in the database. As this is the case, the approach we used is to truncate the table and re-upload everything.

## Steps to replace/update Valuation Office data

1. Truncate table `valuation_office_bands`
2. Convert updated data to CSV
3. Import new data, matching columns
4. Run [this SQL update queries](SQL/Other_queries/properties_and_vo_bands/update_vo_bands_in_aws_recovered_data.sql) to update any Council Tax bands in the AWS recovered table that have changed since last update.
