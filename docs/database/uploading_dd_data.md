# Uploading Direct Debit data

The direct debit is supplied in an excel/csv file which should be imported into the database. It's a row for each account in `aws_academy_recovered_october` with details on direct debit payments, returns and some cash payments.

The supplied file will include all the data, including that which is already in the database. As this is the case, the approach we used is to truncate the table and re-upload everything.

## Steps to replace direct debit data

1. Truncate table `direct_debit_discrepancies`
2. Convert updated data to CSV
3. Import new data, matching columns
4. Run [these SQL update queries](SQL/Other_queries/managing_payment_methods/update_direct_debit_discrepencies_value_columns.sql) to convert text values to numeric on a selection of columns we use for numeric comparisons.
