# Database queries

## Get discounts

```sql
SELECT DISTINCT discounts
FROM (
  SELECT discount_1 FROM fdm_mail_data_march
  UNION
  SELECT discount_2 FROM fdm_mail_data_march
) as discounts;
```

## Get bills (WIP)

```sql
SELECT
  aws_academy_recovered_october.account_ref AS account_no,
  CONCAT(aws_academy_recovered_october.lead_liable_name, ' ', aws_academy_recovered_october.lead_liable_lastname) AS name,
  CONCAT(aws_academy_recovered_october.for_addr1, ', ', aws_academy_recovered_october.for_addr2, ', ', aws_academy_recovered_october.for_addr3, ', ', aws_academy_recovered_october.for_addr4, ', ', aws_academy_recovered_october.for_postcode) AS forwarding_address,
  CONCAT(aws_academy_recovered_october.addr1, ', ', aws_academy_recovered_october.addr2, ', ', aws_academy_recovered_october.addr3, ', ', aws_academy_recovered_october.addr4, ', ', aws_academy_recovered_october.postcode) AS property_address,
  aws_academy_recovered_october.vo_band AS vo_band
FROM aws_academy_recovered_october;

-- Returns 117,665 records.
```

## Get properties with VO band in AWS table different in VOB table

```sql
SELECT
  aws_academy_recovered_october.property_ref AS aws_property_reference,
  aws_academy_recovered_october.vo_band AS aws_vo_band,
  valuation_office_bands.vo_band AS vob_vo_band
FROM aws_academy_recovered_october, valuation_office_bands
WHERE aws_academy_recovered_october.property_ref = valuation_office_bands.property_ref AND aws_academy_recovered_october.vo_band <> valuation_office_bands.vo_band;

-- Returns 0 records.
```

## Get properties with VO band in AWS table different in FDM table

```sql
SELECT
  aws_academy_recovered_october.mail_merge_reference AS aws_mail_merge_reference,
  aws_academy_recovered_october.property_ref AS aws_property_reference,
  aws_academy_recovered_october.vo_band AS aws_vo_band,
  fdm_mail_data_march.vo_band AS fdm_vo_band
FROM aws_academy_recovered_october, fdm_mail_data_march
WHERE aws_academy_recovered_october.mail_merge_reference = fdm_mail_data_march.account_number AND aws_academy_recovered_october.vo_band <> fdm_mail_data_march.vo_band;

-- Returns 48 records.
```

## Get properties with VO band in AWS table different in FDM exemptions table

```sql
SELECT
  aws_academy_recovered_october.mail_merge_reference AS aws_mail_merge_reference,
  aws_academy_recovered_october.property_ref AS aws_property_reference,
  aws_academy_recovered_october.vo_band AS aws_vo_band,
  fdm_mail_exemptions_march.vo_band AS fdm_exemp_vo_band
FROM aws_academy_recovered_october, fdm_mail_exemptions_march
WHERE aws_academy_recovered_october.mail_merge_reference = fdm_mail_exemptions_march.account_number AND aws_academy_recovered_october.vo_band <> fdm_mail_exemptions_march.vo_band;

-- Returns 0 records.
```
