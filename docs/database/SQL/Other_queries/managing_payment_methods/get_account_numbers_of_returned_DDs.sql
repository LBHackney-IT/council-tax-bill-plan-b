SELECT
    aws.mail_merge_reference
FROM
    aws_academy_recovered_october AS aws
    LEFT JOIN direct_debit_discrepancies AS ddd ON aws.mail_merge_reference = ddd.mail_merge_reference
WHERE
    ddd.addacs <> '#N/A'
    OR ddd.returned_dd_not_by_addacs <> '#N/A';

-- 2710 rows on 20/01/2021
