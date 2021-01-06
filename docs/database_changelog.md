# Database changelog

## Tuesday 5th January 2021

### Added

- AWS Academy recovery backup (October 2020) -> `aws_academy_recovered_october` without the following columns which were either all the same value, duplicated, empty or null:
  - `live_ind_from_cooccupancy`
  - `equal_SOMETHING`
  - `equal_SOMETHING`
  - `equal_SOMETHING`
  - `transmission_date`
  - `for_addr_verified`
  - `prohibit_code`
  - `prohibit_end`
  - `prohibit_set`
  - `property_ref`
- Working age (August 2020) -> `working_age_ctr_august`
- FDM mail data (March 2020) -> `fdm_mail_data_march`
- FDM mail exemptions (March 2020) -> `fdm_mail_exemptions_march`
