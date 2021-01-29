-- Currently returns 0 records.

SELECT
    aws_academy_recovered_october.property_ref AS aws_property_reference,
    aws_academy_recovered_october.vo_band AS aws_vo_band,
    valuation_office_bands.vo_band AS vob_vo_band
FROM
    aws_academy_recovered_october,
    valuation_office_bands
WHERE
    aws_academy_recovered_october.property_ref = valuation_office_bands.property_ref
    AND aws_academy_recovered_october.vo_band <> valuation_office_bands.vo_band;
