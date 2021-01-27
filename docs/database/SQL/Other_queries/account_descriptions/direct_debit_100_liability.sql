INSERT INTO account_profiles (aws_academy_recovered_october_id, account_profiles_description_id)
SELECT
    aws.id,
    1
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
        AND ddd.returned_dd_not_by_addacs IS NULL
        AND ddd.addacs IS NULL
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
