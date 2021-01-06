import re
import csv

file_to_parse = '<PATH>/CTax AB Text Files/TD Copy of ct6090_893218b_ LBH Props.txt'
output_file_name = 'FDM-hackney-data-with-premium-props.csv'
output_sql_file_name = 'SQL-FDM-hackney-data-with-premium-props.txt'

last_record_line = ' WILL BE DEBITED DIRECTLY FROM YOUR BANK ACCOUNT AS FOLLOWS'
nothing_to_pay_line = 'THIS NOTICE IS FOR INFORMATION ONLY'
cash_bill_line = 'DUE IN RESPECT OF THIS BILL'
credit = 'YOUR ACCOUNT IS IN CREDIT BY'
exempt_summary = 'this property has been made exempt'

account_regex = re.compile('^3\d{7,8}X?')

headers = [
    'account_number',
    'premium'
]

def end_of_bill(line):
    return last_record_line in line or nothing_to_pay_line in line or cash_bill_line in line or credit in line or exempt_summary in line

def has_premium_applied(line):
    return "Long Term Empty" in line

account_num_processed = False
premium_applied = False

with open(file_to_parse, encoding="ISO-8859-1") as fp:
    Lines = fp.readlines()

    records = [headers]
    record = []

    for line in Lines:

      if account_regex.match(line) and account_num_processed is False:
          account_num_line = line.split()

          account_num_processed = True

      if has_premium_applied(line):
        premium_applied = True

        if account_num_line[0].endswith('|'):
            record.append(account_num_line[0][:-1])
        else:
            record.append(account_num_line[0])

        premium_description = line.split('£')
        premium = premium_description[0].strip()

        record.append(premium)

      if end_of_bill(line):
          account_num_processed = False

          if premium_applied is True:
              records.append(record)

          premium_applied = False
          record = []

    with open(output_file_name, 'w', newline='\n') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(records)

    with open(output_sql_file_name, 'w', newline='\n') as sqlfile:

        for record in records:
          account_num = record[0]
          premium = record[1]

          sql = f"UPDATE fdm_mail_data_march SET premium = '{premium}' WHERE account_number = '{account_num}';"
          print(sql)

