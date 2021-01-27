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
            fdm_mail_data_march.reduction IS NOT NULL);

