# Database queries

## Get discounts

```sql
SELECT DISTINCT discounts
FROM (
  SELECT discount_1 FROM fdm_mail_data_march
  UNION
  SELECT discount_2 FROM fdm_mail_data_march
) as discounts;
```
