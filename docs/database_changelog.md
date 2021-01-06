# Database changelog

## Wednesday 6th January 2021

### Updated

- FDM mail data (March 2020) with premiums extracted from the FDM data files (DD, cash bills and props) using a new [data extractor script](../data_scripts/fdm_premium_extractor.py)

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
