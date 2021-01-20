# Database queries

## Main queries

### Get all bills without CTRS

Exclude all unique CTR cases after combining 'working age' CTR data and 'FDM Mail' CTR data:

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
  aws.property_ref as property_ref,
  ddd."20_21_gross_debit_12_instalments" as instalment
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
AND aws.mail_merge_reference NOT IN (
  SELECT account_number FROM death_list
  WHERE account_number IS NOT NULL
  AND LOWER(account_number) <> 'not found'
);
```

### Get all Non CTRS bills for Direct Debit Payers with 100% Liability

<!-- DD PAYER 100% LIABILITY NO RET DD'S NO ADDACS NO DISCOUNTS NO EXEMPTIONS NO CTR LAST DD PAYMENT +/- £5 GROSS DEBIT (20/21)  -->

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
  aws.property_ref as property_ref,
  ddd."20_21_gross_debit_12_instalments" as "20_21_gross_debit_12_instalments",
  ROUND(aws.estimated_21_22_charge::numeric, 2) as estimated_21_22_charge_to_2dp,
  ROUND(aws.estimated_21_22_charge::numeric - (ROUND(aws.estimated_21_22_charge::numeric / 12) * 11), 2) as first_instalment,
  ROUND(aws.estimated_21_22_charge::numeric / 12) as other_instalments
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'DD%'
  AND ddd.direct_debit_taken > 0
  AND ddd.diff_dd_gross_charge_value BETWEEN -5.00 AND 5.00
  AND ddd.returned_dd_not_by_addacs = '#N/A'
  AND ddd.addacs = '#N/A'
  AND discount_1 IS NULL
  AND exemption_class IS NULL
  AND aws.mail_merge_reference NOT IN (
    SELECT account_number FROM death_list
    WHERE account_number IS NOT NULL
    AND LOWER(account_number) <> 'not found'
  );
```

### Get all Non CTRS bills for Direct Debit Payers with 75% Liability

<!-- DD PAYER 75% LIABILITY NO RET DD'S NO ADDACS 25% DISCOUNTS NO EXEMPTIONS NO CTR LAST DD PAYMENT +/- £5 75% OF GROSS DEBIT (20/21)  -->

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
  aws.property_ref as property_ref,
  ddd."75_charge_12_instalments" as "20_21_75_charge_12_instalments",
  ROUND(aws.estimated_21_22_charge::numeric, 2) as estimated_21_22_charge_to_2dp,
  ROUND(aws.estimated_21_22_charge::numeric - (ROUND(aws.estimated_21_22_charge::numeric / 12) * 11), 2) as first_instalment,
  ROUND(aws.estimated_21_22_charge::numeric / 12) as other_instalments
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'DD%'
  AND ddd.direct_debit_taken > 0
  AND discount_1 IS NOT NULL
  AND ddd.diff_dd_gross_charge_25_value BETWEEN -5.00 AND 5.00
  AND ddd.returned_dd_not_by_addacs = '#N/A'
  AND ddd.addacs = '#N/A'
  AND exemption_class IS NULL
  AND aws.mail_merge_reference NOT IN (
    SELECT account_number FROM death_list
    WHERE account_number IS NOT NULL
    AND LOWER(account_number) <> 'not found'
  );
```

### Get all Non CTRS bills for Cash Payers with 100% Liability

<!-- CASH PAYER 100% LIABILITY - 10 INSTALLMENTS NO MENTION DEATH IN DD RECALLS/ADDACS NO DISCOUNTS NO EXEMPTIONS NO CTR LAST CASH PAYMENT +/- £5 GROSS DEBIT (20/21)  -->

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
  aws.property_ref as property_ref,
  ddd."20_21_gross_debit_10_instalments" as "20_21_gross_debit_10_instalments",
  ROUND(aws.estimated_21_22_charge::numeric, 2) as estimated_21_22_charge_to_2dp,
  ROUND(aws.estimated_21_22_charge::numeric - (ROUND(aws.estimated_21_22_charge::numeric / 10) * 9), 2) as first_instalment,
  ROUND(aws.estimated_21_22_charge::numeric / 10) as other_instalments
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'CASH%'
  AND ddd.direct_debit_taken = 0
  AND ddd.diff_cash_paid_gross_debit_10_instalments_value BETWEEN -5.00 AND 5.00
  AND ddd.returned_dd_not_by_addacs = '#N/A'
  AND ddd.addacs = '#N/A'
  AND discount_1 IS NULL
  AND exemption_class IS NULL
  AND aws.mail_merge_reference NOT IN (
    SELECT account_number FROM death_list
    WHERE account_number IS NOT NULL
    AND LOWER(account_number) <> 'not found'
  );
```

### Get all Non CTRS bills for Cash Payers with 75% Liability

<!-- CASH PAYER 75% LIABILITY -10 INSTALLMENTS -NO MENTION DEATH IN DD RECALLS/ADDACS 25% DISCOUNTS NO EXEMPTIONS NO CTR LAST DD PAYMENT +/- £5 75% OF GROSS DEBIT (20/21)  -->

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
  aws.property_ref as property_ref,
  ddd."75_charge_10_instalments" as "20_21_75_charge_10_instalments",
  ROUND(aws.estimated_21_22_charge::numeric, 2) as estimated_21_22_charge_to_2dp,
  ROUND(aws.estimated_21_22_charge::numeric - (ROUND(aws.estimated_21_22_charge::numeric / 10) * 9), 2) as first_instalment,
  ROUND(aws.estimated_21_22_charge::numeric / 10) as other_instalments
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'CASH%'
  AND ddd.direct_debit_taken = 0
  AND ddd.diff_cash_paid_gross_25_off_debit_10_instalments_value BETWEEN -5.00 AND 5.00
  AND ddd.returned_dd_not_by_addacs = '#N/A'
  AND ddd.addacs = '#N/A'
  AND discount_1 IS NOT NULL
  AND exemption_class IS NULL
  AND aws.mail_merge_reference NOT IN (
    SELECT account_number FROM death_list
    WHERE account_number IS NOT NULL
    AND LOWER(account_number) <> 'not found'
  );
```

### Get all Non CTRS bills for Cash Payers with 100% Liability that have paid off their annual bill

<!-- 10 Installments, No mention of death in DD Recalls/ADDACS, No discounts, No exemptions, No CTR, LAST CASH PAYMENT AND NOT BETWEEN MINUS £5 AND £5 GROSS DEBIT (20/21)  -->

```sql
SELECT
  distinct (aws.mail_merge_reference) AS mail_merge_reference,
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
  aws.property_ref as property_ref,
  tot_cash_pay.total as total_cash_amount
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
INNER JOIN total_cash_payments AS tot_cash_pay
ON aws.mail_merge_reference = tot_cash_pay.account_id
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'CASH%'
  AND ddd.direct_debit_taken = 0
  AND NOT (ddd.diff_cash_paid_gross_debit_10_instalments_value BETWEEN -5.00 AND 5.00)
  AND ddd.returned_dd_not_by_addacs = '#N/A'
  AND ddd.addacs = '#N/A'
  AND discount_1 IS NULL
  AND exemption_class IS NULL
  AND (aws.calculated_20_21_charge_value - tot_cash_pay.total = 0.00)
  AND aws.mail_merge_reference NOT IN (
    SELECT account_number FROM death_list
    WHERE account_number IS NOT NULL
    AND LOWER(account_number) <> 'not found'
  );
```

## Get all Non CTRS bills for Cash Payers with 75% Liability that have paid off their annual bill

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
  aws.property_ref as property_ref,
  tot_cash_pay.total as total_cash_amount
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
LEFT JOIN total_cash_payments AS tot_cash_pay
ON aws.mail_merge_reference = tot_cash_pay.account_id
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'CASH%'
  AND ddd.direct_debit_taken = 0
  AND NOT(ddd.diff_cash_paid_gross_25_off_debit_10_instalments_value BETWEEN -5.00 AND 5.00)
  AND ddd.returned_dd_not_by_addacs = '#N/A'
  AND ddd.addacs = '#N/A'
  AND discount_1 IS NOT NULL
  AND exemption_class IS NULL
  AND (aws.calculated_20_21_75_charge - tot_cash_pay.total = 0.00)
  AND aws.mail_merge_reference NOT IN (
    SELECT account_number FROM death_list
    WHERE account_number IS NOT NULL
    AND LOWER(account_number) <> 'not found'
  );
```

## Get cash payers with 100% liability that have moved in after 20th April 2020

And have paid off their bill based on the number of days they've occupied the
property.

```sql
SELECT
  distinct (aws.mail_merge_reference) AS mail_merge_reference,
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
  aws.property_ref as property_ref,
  tot_cash_pay.total as total_cash_amount,
  aws.formatted_occupied_date as occupied_date,
  aws.calculated_20_21_charge_value as calculated_20_21_charge,
  aws.days_occupied as days_occupied,
  (aws.calculated_20_21_charge_value / 365) * days_occupied AS apportioned_charge_100,
  ROUND(((aws.calculated_20_21_charge_value / 365) * days_occupied - tot_cash_pay.total), 2) AS diff_paid
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
LEFT JOIN total_cash_payments AS tot_cash_pay
ON aws.mail_merge_reference = tot_cash_pay.account_id
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'CASH%'
  AND ddd.direct_debit_taken = 0
  AND discount_1 IS NULL
  AND exemption_class IS NULL
  AND formatted_occupied_date >= '2020-04-01'
  AND ROUND(((aws.calculated_20_21_charge_value / 365) * days_occupied - tot_cash_pay.total), 2) = 0;
```

## Get cash payers with 75% liability that have moved in after 20th April 2020

```sql
SELECT
  DISTINCT(aws.mail_merge_reference) AS mail_merge_reference,
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
  aws.property_ref as property_ref,
  tot_cash_pay.total as total_cash_amount,
  aws.formatted_occupied_date as occupied_date,
  aws.calculated_20_21_75_charge as calculated_20_21_75_charge,
  aws.days_occupied as days_occupied,
  ((aws.calculated_20_21_75_charge / 365) * days_occupied) AS apportioned_charge_75,
  ROUND(((aws.calculated_20_21_75_charge / 365) * days_occupied - coalesce(tot_cash_pay.total, 0)), 2) AS diff_paid
FROM aws_academy_recovered_october AS aws
LEFT JOIN fdm_mail_data_march AS fdm
ON aws.mail_merge_reference = fdm.account_number
LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions
ON aws.mail_merge_reference = fdm_exemptions.account_number
LEFT JOIN exemption_reasons
ON exemption_reasons.class = fdm_exemptions.exemption_class
LEFT JOIN direct_debit_discrepancies AS ddd
ON ddd.mail_merge_reference = aws.mail_merge_reference
LEFT JOIN total_cash_payments AS tot_cash_pay
ON aws.mail_merge_reference = tot_cash_pay.account_id
WHERE aws.mail_merge_reference NOT IN (SELECT main.mail_merge_reference
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL UNION SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL))
  AND payment_method_code LIKE 'CASH%'
  AND ddd.direct_debit_taken = 0
  AND discount_1 IS NOT NULL
  AND exemption_class IS NULL
  AND formatted_occupied_date >= '2020-04-01'
  AND ROUND(((aws.calculated_20_21_75_charge / 365) * days_occupied - tot_cash_pay.total), 2) = 0;
```

## Other queries

### Get discounts

```sql
SELECT DISTINCT discounts
FROM (
  SELECT discount_1 FROM fdm_mail_data_march
  UNION
  SELECT discount_2 FROM fdm_mail_data_march
) as discounts;
```

### Get properties with VO band in AWS table different in VOB table

```sql
SELECT
  aws_academy_recovered_october.property_ref AS aws_property_reference,
  aws_academy_recovered_october.vo_band AS aws_vo_band,
  valuation_office_bands.vo_band AS vob_vo_band
FROM aws_academy_recovered_october, valuation_office_bands
WHERE aws_academy_recovered_october.property_ref = valuation_office_bands.property_ref AND aws_academy_recovered_october.vo_band <> valuation_office_bands.vo_band;

-- Returns 0 records.
```

### Get properties with VO band in AWS table different in FDM table

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

### Get properties with VO band in AWS table different in FDM exemptions table

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

### Update reasons for exclusion join table based on the result of a main data and supplementary data query

Replace <reason_id> with the actual reason id from reasons table. Reason should exist in reasons table to provide that <reason_id>

```sql
INSERT INTO account_exclusions (account_id, reason_id)
SELECT main.id, <reason_id>
FROM ctax_billing_dumb_v1 AS main
JOIN fdm_mail_data AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.discount_1 IS NOT NULL;
```

### Get all accounts without a reason to exclude

```sql
SELECT main.id, main.mail_merge_reference, account_exclusions.exclusion_reasons_id
FROM aws_academy_recovered_october AS main
LEFT JOIN account_exclusions
ON main.id = account_exclusions.aws_academy_recovered_october_id
WHERE account_exclusions.exclusion_reasons_id IS NULL;
```

### Get all working age reductions not in FDM mail data

```sql
SELECT DISTINCT(working_age_ctr_august.ctax_ref)
FROM working_age_ctr_august
WHERE working_age_ctr_august.ctax_ref NOT IN (SELECT fdm_mail_data_march.account_number FROM fdm_mail_data_march WHERE fdm_mail_data_march.reduction IS NOT NULL);
```

### Get all bills with CTRs

```sql
SELECT main.id, fdm.reduction
FROM aws_academy_recovered_october AS main
JOIN fdm_mail_data_march AS fdm
ON main.mail_merge_reference = fdm.account_number AND fdm.reduction IS NOT NULL;
```

### Managing Payment Methods when DD returned

#### Confirm the account numbers of DDs returned in Direct debit discrepencies
```sql
SELECT * FROM aws_academy_recovered_october WHERE aws_academy_recovered_october.payment_method_code_updated <> aws_academy_recovered_october.payment_method_code;
```

#### Confirm the account numbers of DDs returned

```sql
SELECT aws.mail_merge_reference
FROM aws_academy_recovered_october AS aws
LEFT JOIN direct_debit_discrepancies AS ddd
ON aws.mail_merge_reference = ddd.mail_merge_reference
WHERE ddd.addacs <> '#N/A'
	OR ddd.returned_dd_not_by_addacs <> '#N/A';
  -- 2710 rows on 20/01/2021
```


#### Update main data in AWS recovered table with updated payment method
```sql
UPDATE aws_academy_recovered_october
SET payment_method_code_updated = 'CASHM', payment_method_type_updated = '1'
WHERE mail_merge_reference IN (
	SELECT aws.mail_merge_reference
	FROM aws_academy_recovered_october AS aws
	LEFT JOIN direct_debit_discrepancies AS ddd
	ON aws.mail_merge_reference = ddd.mail_merge_reference
	WHERE ddd.addacs <> '#N/A'
	OR ddd.returned_dd_not_by_addacs <> '#N/A'
);
```
