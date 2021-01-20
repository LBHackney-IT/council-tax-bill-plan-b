import os
import psycopg2
from flask import Flask
app = Flask(__name__)

# Database connection setup
db_host = os.environ.get('DB_HOST')
db_port = os.environ.get('DB_PORT')
db_name = os.environ.get('DB_NAME')
db_user = os.environ.get('DB_USER')
db_password = os.environ.get('DB_PASSWORD')

db_conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_password)
db_cursor = db_conn.cursor()

@app.route('/')
def home():
    return 'Council Tax Bill Generator'

@app.route('/account/<account_number>')
def account(account_number):
    query = (
        'SELECT '
        'aws.mail_merge_reference AS mail_merge_reference, '
        'CONCAT(aws.lead_liable_name, \' \', aws.lead_liable_lastname) AS name, '
        'CONCAT(aws.for_addr1, \' \', aws.for_addr2, \' \', aws.for_addr3, \' \', aws.for_addr4, \' \', aws.for_postcode) AS forwarding_address, '
        'CONCAT(aws.addr1, \' \', aws.addr2, \' \', aws.addr3, \' \', aws.addr4, \' \', aws.postcode) AS property_address, '
        'aws.vo_band AS vo_band, '
        'coalesce(fdm.additional_names, fdm_exemptions.additional_names) AS additional_names, '
        'fdm.discount_1 AS discount_1, '
        'fdm.discount_2 AS discount_2, '
        'fdm.reduction AS reduction, '
        'aws.payment_method_code AS payment_method_code, '
        'fdm_exemptions.exemption_class AS exemption_class, '
        'exemption_reasons.reason AS exemption_reason, '
        'aws.property_ref as property_ref '
        'FROM aws_academy_recovered_october AS aws '
        'LEFT JOIN fdm_mail_data_march AS fdm '
        'ON aws.mail_merge_reference = fdm.account_number '
        'LEFT JOIN fdm_mail_exemptions_march AS fdm_exemptions '
        'ON aws.mail_merge_reference = fdm_exemptions.account_number '
        'LEFT JOIN exemption_reasons '
        'ON exemption_reasons.class = fdm_exemptions.exemption_class '
        'WHERE aws.mail_merge_reference = '
        f"'{account_number}'"
    )

    db_cursor.execute(query)

    result = db_cursor.fetchone()

    return f'{result[0]}, {result[1]}, {result[2]}, {result[3]}, {result[4]}, {result[5]}, {result[6]}, '
