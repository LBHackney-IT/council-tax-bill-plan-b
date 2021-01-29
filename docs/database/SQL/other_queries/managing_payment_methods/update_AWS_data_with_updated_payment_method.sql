UPDATE
    aws_academy_recovered_october
SET
    payment_method_code_updated = 'CASHM',
    payment_method_type_updated = '1'
WHERE
    mail_merge_reference IN (
        SELECT
            aws.mail_merge_reference
        FROM
            aws_academy_recovered_october AS aws
        LEFT JOIN direct_debit_discrepancies AS ddd ON aws.mail_merge_reference = ddd.mail_merge_reference
    WHERE
        ddd.addacs <> '#N/A'
        OR ddd.returned_dd_not_by_addacs <> '#N/A');

