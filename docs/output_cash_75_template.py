output_cash_75 = (
f"""
----------
|1 April 2021 to 31 March 2022|
10 March 2021|
{lead_liable}|
{additional_name}|
|\n
{address_line_1}|
{address_line_2}|
{address_line_3}|
{address_line_4}|
{postcode}|
{property_address_line_1}|
{property_address_line_2}|
{property_address_line_3}|
{property_address_line_4}|
{vo_band}|
{mail_merge_reference}   {bill_number}|
{barcode_number}|
|\n
{gross_amount_due}|
{overall_change_from_previous_year}|
LONDON BOROUGH OF HACKNEY|
{amount_to_recipient_lbh}|
{change_from_previous_year_to_lbh}|
ADULT SOCIAL CARE|
{amount_to_recipient_asc}|
{change_from_previous_year_to_asc}|
GREATER LONDON AUTHORITY|
{amount_to_gla}|
{change_from_previous_year_to_gla}|
|\n
This bill is for Council Tax for the period from 1 April 2021 to 31 March 2022.|
|\n
Council Tax due for period 01.04.2021 to 31.03.2022|
{full_amount_due}|
{discount_25_statement}|
|\n
Total Charge for Period|
{net_amount_due}|
|\n
Total amount due for period 01.04.2021 to 31.03.2022|
{net_council_tax_due}|
10 PAYMENTS ARE DUE IN RESPECT OF THIS BILL:|
{month_1}|£{first_instalment}|{month_6}|£{next_instalment}|
{month_2}|£{next_instalment}|{month_7}|£{next_instalment}|
{month_3}|£{next_instalment}|{month_8}|£{next_instalment}|
{month_4}|£{next_instalment}|{month_9}|£{next_instalment}|
{month_5}|£{next_instalment}|{month_10}|£{next_instalment}|
"""
)
