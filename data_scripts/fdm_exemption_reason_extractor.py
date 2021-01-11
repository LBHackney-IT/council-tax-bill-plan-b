import re
import csv

file_to_parse = '/Users/mattbee/Documents/Hackney/Council Tax Plan B/data/CTax AB Text Files/ct6090_893216b - CT Exemption Notices-REASONS.txt'
output_file_name = 'FDM-hackney-data-exemption-reasons.csv'
output_sql_file_name = 'SQL-FDM-hackney-data-exemption-reasons.txt'

exempt_summary = 'This exemption will apply until the circumstances'

account_regex = re.compile('^3\d{7,8}X?')
exemption_text = re.compile('^class [A-Z]')

headers = [
    'account_number',
    'exemption_class'
]

def end_of_bill(line):
    return exempt_summary in line

account_num_processed = False
premium_applied = False

with open(file_to_parse, encoding="ISO-8859-1") as fp:
    Lines = fp.readlines()

    records = [headers]
    record = []

    for line in Lines:

        if account_regex.match(line) and account_num_processed is False:
                account_num_line = line.split()

                if account_num_line[0].endswith('|'):
                    record.append(account_num_line[0][:-1])
                else:
                    record.append(account_num_line[0])

                account_num_processed = True

        if exemption_text.match(line):
            exemption_classification = line.split()
            exemption_classification_letter = exemption_classification[1]
            record.append(exemption_classification_letter)

        if end_of_bill(line):
            account_num_processed = False
            records.append(record)
            record = []

    with open(output_file_name, 'w', newline='\n') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(records)

    with open(output_sql_file_name, 'w', newline='\n') as sqlfile:

        for record in records[1:]:
            account_num = record[0]
            exemption_class = record[1]

            sql = f"UPDATE fdm_mail_exemptions_march SET exemption_class = '{exemption_class}' WHERE account_number = '{account_num}';"
            sqlfile.write(f'{sql}\n')
