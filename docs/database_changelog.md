# Database changelog

## Tuesday 5th January 2021

### Added

- AWS recovery backup (October 2020) -> `aws_recovery_backup_october` without the following columns which were either all the same value, duplicated, empty or null:
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
- Working age (August) -> `working_age_ctr_august`
- FDM mail data (YEAR) -> `fdm_mail_data_YEAR`
- FDM mail exemptions (YEAR) -> `fdm_mail_exemptions_YEAR`
