import re
import csv

file_to_parse = './CTax AB Text Files/TD Copy of ct6090_893218b_ LBH Props.txt'
output_file_name = 'FDM-hackney-data.csv'
exemptions_file = False

last_record_line = ' WILL BE DEBITED DIRECTLY FROM YOUR BANK ACCOUNT AS FOLLOWS'
nothing_to_pay_line = 'THIS NOTICE IS FOR INFORMATION ONLY'
cash_bill_line = 'DUE IN RESPECT OF THIS BILL'
credit = 'YOUR ACCOUNT IS IN CREDIT BY'
exempt_first_line = 'Council Tax exemption notice for 2020/2021'
exempt_summary = 'this property has been made exempt'

bill_issue_date = '10 March 2020'
account_regex = re.compile('^3\d{7,8}X?')
band_regex = re.compile('^[ABCDEFGH]{1}\|')
name_numeric = re.compile('^[0-9]')
band_free_text = re.compile('^This property is in band [A-H]')
# keep the space before the - in deduction_identifier to account for rare data
# with a negative/account in credit value
deduction_identifier = ' -£'

headers = [
    'lead_name',
    'additional_names',
    'vo_band',
    'account_number',
    'discount_1',
    'discount_1_amount',
    'discount_2',
    'discount_2_amount',
    'exemption',
    'exemption_amount',
]

exemption_headers = [
    'account_number',
    'lead_name',
    'additional_names',
    'vo_band',
]

name_list = []
name_count = 0
name_capture = False
reduction_count = 0
reduction_capture = False
total_reductions = 0
account_num_processed = False

def end_of_bill(line):
    return last_record_line in line or nothing_to_pay_line in line or cash_bill_line in line or credit in line or exempt_summary in line

def add_empty_columns_for_discounts_if_required(line, record, reduction_count):
    if reduction_count == 1 and "Less Council Tax" in line:
        record.append(None)
        record.append(None)

    if reduction_count == 0 and "Less Council Tax" in line:
        record.append(None)
        record.append(None)
        record.append(None)
        record.append(None)

def has_value_deducted_from_bill(line):
    return " -£" in line

with open(file_to_parse, encoding="ISO-8859-1") as fp:
    Lines = fp.readlines()

    if exemptions_file:
        records = [exemption_headers]
    else:
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

        if bill_issue_date in line:
            name_capture = True
            name_list = []
        elif line == '|\n' and name_capture is True:
            record.append(','.join(name_list))
            name_list = []
            name_capture = False
            name_count = 0
        elif name_capture and not name_numeric.match(line):
            name_count = name_count + 1
            if name_count == 1:
                record.append(line.strip()[:-1])
            else:
                name_list.append(line.strip()[:-1])

        if band_regex.match(line):
            record.append(line[0])

        if has_value_deducted_from_bill(line):
            reduction_capture = True

            add_empty_columns_for_discounts_if_required(line, record, reduction_count)

            reduction_line_and_amount = line.split(deduction_identifier)
            if credit not in line:
                record.append(reduction_line_and_amount[0].strip())
                record.append(reduction_line_and_amount[1].strip())

            reduction_count = reduction_count + 1
            total_reductions = total_reductions + 1

        elif line == '|\n' and reduction_capture == True:
            reduction_capture = False
            reduction_count = 0

        if exemptions_file and band_free_text.match(line):
            band_text = band_free_text.match(line)
            record.append(band_text.group(0)[-1])

        if end_of_bill(line):
            if total_reductions == 0:
                record.append(None)
                record.append(None)
                record.append(None)
                record.append(None)
                record.append(None)
                record.append(None)

            total_reductions = 0
            account_num_processed = False

            records.append(record)
            record = []

    with open(output_file_name, 'w', newline='\n') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(records)
