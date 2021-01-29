SELECT
    *
FROM
    aws_academy_recovered_october
WHERE
    aws_academy_recovered_october.payment_method_code_updated <> aws_academy_recovered_october.payment_method_code;
