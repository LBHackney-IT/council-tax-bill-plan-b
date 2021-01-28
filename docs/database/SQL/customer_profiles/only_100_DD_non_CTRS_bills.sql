-- DD PAYER 100% LIABILITY NO RET DD'S NO ADDACS NO DISCOUNTS NO EXEMPTIONS NO CTR LAST DD PAYMENT +/- £5 GROSS DEBIT (20/21)

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
    aws.property_ref AS property_ref,
    ddd. "20_21_gross_debit_12_instalments" AS "20_21_gross_debit_12_instalments",
    ROUND(aws.estimated_21_22_charge::numeric, 2) AS estimated_21_22_charge_to_2dp,
    ROUND(aws.estimated_21_22_charge::numeric - (ROUND(aws.estimated_21_22_charge::numeric / 12) * 11), 2) AS first_instalment,
    ROUND(aws.estimated_21_22_charge::numeric / 12) AS other_instalments
FROM
    aws_academy_recovered_october AS aws
    LEFT JOIN fdm_mail_data_march AS fdm ON aws.mail_merge_reference = fdm.account_number
    LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions ON aws.mail_merge_reference = fdm_exemptions.account_number
    LEFT JOIN exemption_reasons ON exemption_reasons.class = fdm_exemptions.exemption_class
    LEFT JOIN direct_debit_discrepancies AS ddd ON ddd.mail_merge_reference = aws.mail_merge_reference
WHERE
    aws.mail_merge_reference NOT IN (
        SELECT
            main.mail_merge_reference
        FROM
            aws_academy_recovered_october AS main
            JOIN fdm_mail_data_march AS fdm ON main.mail_merge_reference = fdm.account_number
                AND fdm.reduction IS NOT NULL
            UNION
            SELECT DISTINCT
                (working_age_ctr_august.ctax_ref)
            FROM
                working_age_ctr_august
        WHERE
            working_age_ctr_august.ctax_ref NOT IN (
                SELECT
                    fdm_mail_data_march.account_number
                FROM
                    fdm_mail_data_march
                WHERE
                    fdm_mail_data_march.reduction IS NOT NULL))
        AND payment_method_code LIKE 'DD%'
        AND ddd.direct_debit_taken > 0
        AND ddd.diff_dd_gross_charge_value BETWEEN - 5.00
        AND 5.00
        AND ddd.returned_dd_not_by_addacs IS NULL OR ddd.returned_dd_not_by_addacs = '#N/A'
        AND ddd.addacs IS NULL OR ddd.addacs = '#N/A'fedr
        AND discount_1 IS NULL
        AND exemption_class IS NULL
        AND aws.mail_merge_reference NOT IN (
            SELECT
                account_number
            FROM
                death_list
            WHERE
                account_number IS NOT NULL
                AND LOWER(account_number) <> 'not found');
