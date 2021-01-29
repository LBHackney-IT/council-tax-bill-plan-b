SELECT
    LOWER(CONCAT(TRIM(aws.lead_liable_name), ' ', TRIM(aws.lead_liable_lastname))) AS aws_main_name,
    CONCAT(TRIM(aws.lead_liable_title), ' ', TRIM(aws.lead_liable_forename), ' ', TRIM(aws.lead_liable_surname)) AS aws_second_name,
    LOWER(fdm.lead_name) AS fdm_lead_name,
    fdm.additional_names AS additional_names
FROM
    aws_academy_recovered_october AS aws
    JOIN fdm_mail_data_march AS fdm ON aws.mail_merge_reference = fdm.account_number
WHERE
    fdm.additional_names IS NOT NULL
    AND LOWER(CONCAT(TRIM(aws.lead_liable_name), ' ', TRIM(aws.lead_liable_lastname))) <> LOWER(fdm.lead_name)
    AND fdm.lead_name NOT ILIKE CONCAT(TRIM(aws.lead_liable_title), '%', TRIM(aws.lead_liable_surname));

