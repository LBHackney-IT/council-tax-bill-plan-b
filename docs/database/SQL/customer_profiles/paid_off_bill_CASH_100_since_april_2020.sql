-- Have paid off their bill based on the number of days they've occupied the property.

SELECT DISTINCT
    (aws.mail_merge_reference) AS mail_merge_reference,
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
    tot_cash_pay.total AS total_cash_amount,
    aws.formatted_occupied_date AS occupied_date,
    aws.calculated_20_21_charge_value AS calculated_20_21_charge,
    aws.days_occupied AS days_occupied,
    (aws.calculated_20_21_charge_value / 365) * days_occupied AS apportioned_charge_100,
    ROUND(((aws.calculated_20_21_charge_value / 365) * days_occupied - tot_cash_pay.total), 2) AS diff_paid
FROM
    aws_academy_recovered_october AS aws
    LEFT JOIN fdm_mail_data_march AS fdm ON aws.mail_merge_reference = fdm.account_number
    LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions ON aws.mail_merge_reference = fdm_exemptions.account_number
    LEFT JOIN exemption_reasons ON exemption_reasons.class = fdm_exemptions.exemption_class
    LEFT JOIN direct_debit_discrepancies AS ddd ON ddd.mail_merge_reference = aws.mail_merge_reference
    LEFT JOIN total_cash_payments AS tot_cash_pay ON aws.mail_merge_reference = tot_cash_pay.account_id
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
        AND payment_method_code LIKE 'CASH%'
        AND ddd.direct_debit_taken = 0 OR ddd.direct_debit_taken IS NULL
        AND discount_1 IS NULL
        AND exemption_class IS NULL
        AND formatted_occupied_date >= '2020-04-01'
        AND ROUND(((aws.calculated_20_21_charge_value / 365) * days_occupied - tot_cash_pay.total), 2) = 0;
