-- Currently returns 0 records.

SELECT
    aws_academy_recovered_october.mail_merge_reference AS aws_mail_merge_reference,
    aws_academy_recovered_october.property_ref AS aws_property_reference,
    aws_academy_recovered_october.vo_band AS aws_vo_band,
    fdm_mail_exemptions_march.vo_band AS fdm_exemp_vo_band
FROM
    aws_academy_recovered_october,
    fdm_mail_exemptions_march
WHERE
    aws_academy_recovered_october.mail_merge_reference = fdm_mail_exemptions_march.account_number
    AND aws_academy_recovered_october.vo_band <> fdm_mail_exemptions_march.vo_band;

