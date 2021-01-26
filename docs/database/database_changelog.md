# Database changelog

## Tuesday 19th January 2021

### Added

- Breakdown vo bands table -> contains amounts for Hackney, Adult Social Care & Greater London Authority per vo_band
- `days_occupied`, `apportioned_charge` & `formatted_occupied_date` columns to the `aws_academy_recovered_october`

## Monday 18th January 2021

### Added

- All cash payments from April to December -> `ctax_cash_all_payments`
- Total amount of cash payments -> `total_cash_payments`

### Updated

- Recently deceased with corresponding account number

## Thursday 14th January 2021

### Added

- Recently deceased -> `death_list`
- Value columns for `direct_debit_discrepancies`:
  - `diff_dd_gross_charge_value`
  - `diff_dd_gross_charge_25_value`
  - `diff_cash_paid_gross_debit_10_instalments_value`
  - `diff_cash_paid_gross_25_off_debit_10_instalments_value`
  - `75_charge_10_instalments_value`
  - `20_21_gross_debit_10_instalments_value`
  - `75_charge_12_instalments_value`
  - `20_21_gross_debit_12_instalments_value`

## Tuesday 12th January 2021

### Added

- Temporary table of estimated reasons to exclude an account from being sent a bill -> `exclusion_reasons`
- Temporary table to hold list of account ids that have been identified as having a exclusion reason associated with them -> `account_exclusions`

## Thursday 7th January 2021

### Added

- Exemption reasons -> `exemption_reasons`
- VO data (January 2021) -> `valuation_office_bands`
- Direct debit discrepancies -> `direct_debit_discrepancies`

### Updated

- FDM mail exemptions with exemption class using new data extractor script -> `exemption_class`

## Wednesday 6th January 2021

### Updated

- FDM mail data (March 2020) with premiums extracted from the FDM data files (DD, cash bills and props) using a new [data extractor script](../../data_scripts/fdm_premium_extractor.py)

## Tuesday 5th January 2021

### Added

- AWS Academy recovery backup (October 2020) -> `aws_academy_recovered_october` without the following columns which were either all the same value, duplicated, empty or null:
  - `live_ind from ctoccupancy`
  - `equal_access_code`
  - `sched_code`
  - `person_status`
  - `transmission_date`
  - `for_addr_verified`
  - `prohibit_code`
  - `prohibit_end`
  - `prohibit_set`
  - `property_ref`
- Working age (August 2020) -> `working_age_ctr_august`
- FDM mail data (March 2020) -> `fdm_mail_data_march`
- FDM mail exemptions (March 2020) -> `fdm_mail_exemptions_march`
