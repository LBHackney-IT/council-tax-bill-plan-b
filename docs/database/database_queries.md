# Database queries

## Main queries

### Customer Profiles

1. [Get all bills without CTRS](/docs/database/SQL/customer_profiles/all_non_CTRS_bills.sql)
2. [Get all Non CTRS bills for Direct Debit Payers with 100% Liability](/docs/database/SQL/customer_profiles/only_100_DD_non_CTRS_bills.sql)
3. [Get all Non CTRS bills for Direct Debit Payers with 75% Liability](/docs/database/SQL/customer_profiles/only_75_DD_non_CTRS_bills.sql)
4. [Get all Non CTRS bills for Cash Payers with 100% Liability](/docs/database/SQL/customer_profiles/only_100_CASH_non_CTRS_bills.sql)
5. [Get all Non CTRS bills for Cash Payers with 75% Liability](/docs/database/SQL/customer_profiles/only_75_CASH_non_CTRS_bills.sql)
6. [Get all Non CTRS bills for Cash Payers with 100% Liability that have paid off their annual bill](/docs/database/SQL/customer_profiles/paid_off_annual_bill_CASH_100.sql)
7. [Get all Non CTRS bills for Cash Payers with 75% Liability that have paid off their annual bill](/docs/database/SQL/customer_profiles/paid_off_annual_bill_CASH_75.sql)
8. [Get cash payers with 100% liability that have moved in after 20th April 2020](/docs/database/SQL/customer_profiles/paid_off_bill_CASH_100_since_april_2020.sql)
9. [Get cash payers with 75% liability that have moved in after 20th April 2020](/docs/database/SQL/customer_profiles/paid_off_bill_CASH_75_since_april_2020.sql)

## Other queries

### Reductions and Discounts

1. [Get discounts](/docs/database/SQL/Other_queries/reductions_and_discounts/get_discounts.sql)
2. [Get all working age reductions not in FDM mail data](/docs/database/SQL/Other_queries/reductions_and_discounts/get_working_age_reductions_not_in_FDM.sql)
3. [Get all bills with CTRs](/docs/database/SQL/Other_queries/reductions_and_discounts/get_all_CTRS_bills.sql)

### Properties and Valuation Office Bands

1. [Get properties with VO band in AWS table different in VOB table](/docs/database/SQL/Other_queries/properties_and_vo_bands/get_properties_with_different_VO_bands_in_AWS_and_VO.sql)
2. [Get properties with VO band in AWS table different in FDM table](/docs/database/SQL/Other_queries/properties_and_vo_bands/get_properties_with_different_VO_bands_in_AWS_and_FDM.sql)
3. [Get properties with VO band in AWS table different in FDM exemptions table](/docs/database/SQL/Other_queries/properties_and_vo_bands/get_properties_with_different_VO_bands_in_AWS_and_FDM_exemptions.sql)

### Managing Payment Methods

1. [Confirm the account numbers of DDs returned in Direct debit discrepencies](/docs/database/SQL/Other_queries/managing_payment_methods/confirm_account_numbers_of_returned_DDs_in_updated_data.sql)
2. [Confirm the account numbers of DDs returned](/docs/database/SQL/Other_queries/managing_payment_methods/get_account_numbers_of_returned_DDs.sql)
3. [Update main data in AWS recovered table with updated payment method](/docs/database/SQL/Other_queries/managing_payment_methods/update_AWS_data_with_updated_payment_method.sql)

### Account Profile Descriptions

1. [Find people where lead aws name and lead fdm name don't match](/docs/database/SQL/Other_queries/account_descriptions/get_accounts_where_lead_aws_name_lead_fdm_name_do_not_match.sql)
2. [Direct Debit 100% liability](/docs/database/SQL/Other_queries/account_descriptions/direct_debit_100_liability.sql)
3. [Direct Debit 75% liability](/docs/database/SQL/Other_queries/account_descriptions/cash_75_liability.sql)
4. [CASHM 100% liability](/docs/database/SQL/Other_queries/account_descriptions/cash_100_liability.sql)
5. [CASHM 75% liability](/docs/database/SQL/Other_queries/account_descriptions/cash_75_liability.sql)
6. [CASHM 100% zero account balance](/docs/database/SQL/Other_queries/account_descriptions/cash_100_liability_zero_account_balance.sql)
7. [CASHM 75% zero account balance](/docs/database/SQL/Other_queries/account_descriptions/cash_75_liability_zero_account_balance.sql)
8. [CASHM 100% liability, moved in after 1st April 2020](/docs/database/SQL/Other_queries/account_descriptions/cash_100_liability_moved_in_from_April.sql)
9. [CASHM 75% paid off liability, moved in after 1st April 2020](/docs/database/SQL/Other_queries/account_descriptions/cash_75_liability_moved_in_from_April.sql)
