UPDATE direct_debit_discrepancies SET diff_dd_gross_charge_value = CAST(REGEXP_REPLACE(diff_dd_gross_charge, '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET diff_dd_gross_charge_25_value = CAST(REGEXP_REPLACE(diff_dd_gross_charge_25, '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET diff_cash_paid_gross_debit_10_instalments_value = CAST(REGEXP_REPLACE(diff_cash_paid_gross_debit_10_instalments, '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET diff_cash_paid_gross_25_off_debit_10_instalments_value = CAST(REGEXP_REPLACE(diff_cash_paid_gross_25_off_debit_10_instalments, '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET "75_charge_10_instalments_value" = CAST(REGEXP_REPLACE("75_charge_10_instalments", '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET "20_21_gross_debit_10_instalments_value" = CAST(REGEXP_REPLACE("20_21_gross_debit_10_instalments", '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET "75_charge_12_instalments_value" = CAST(REGEXP_REPLACE("75_charge_12_instalments", '£|,', '', 'g') AS NUMERIC);

UPDATE direct_debit_discrepancies SET "20_21_gross_debit_12_instalments_value" = CAST(REGEXP_REPLACE("20_21_gross_debit_12_instalments", '£|,', '', 'g') AS NUMERIC);
