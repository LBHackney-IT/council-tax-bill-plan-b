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
  aws.mail_merge_reference AS mail_merge_reference,
  CONCAT(aws.lead_liable_name, ' ', aws.lead_liable_lastname) AS name,
  CONCAT(aws.for_addr1, ', ', aws.for_addr2, ', ', aws.for_addr3, ', ', aws.for_addr4, ', ', aws.for_postcode) AS forwarding_address,
  CONCAT(aws.addr1, ', ', aws.addr2, ', ', aws.addr3, ', ', aws.addr4, ', ', aws.postcode) AS property_address,
  aws.vo_band AS vo_band,
  coalesce(fdm.additional_names, fdm_exemptions.additional_names) AS additional_names,
  fdm.discount_1 AS discount_1,
  fdm.discount_2 AS discount_2,
  fdm.reduction AS reduction,
  aws.payment_method_code AS payment_method_code,
  fdm_exemptions.exemption_class AS exemption_class,
  exemption_reasons.reason AS exemption_reason,
  aws.property_ref as property_ref
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class;


-- Returns 119,036 records.
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