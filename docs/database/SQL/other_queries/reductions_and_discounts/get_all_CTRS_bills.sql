SELECT
    main.id,
    fdm.reduction
FROM
    aws_academy_recovered_october AS main
    JOIN fdm_mail_data_march AS fdm ON main.mail_merge_reference = fdm.account_number
        AND fdm.reduction IS NOT NULL;

