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
