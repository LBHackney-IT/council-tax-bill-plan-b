UPDATE
    aws_academy_recovered_october AS aws
SET
    vo_band = vo.vo_band,
    vo_effective_date = vo.vo_schedule_date
FROM
	valuation_office_bands AS vo
WHERE
    aws.mail_merge_reference = vo.mail_merge_reference
AND
    aws.vo_band <> vo.new_band_from_schedule
AND
	vo.new_band_from_schedule IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H');
