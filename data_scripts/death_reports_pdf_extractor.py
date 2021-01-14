import re
import sys
from os import path
from tika import parser

input_file = sys.argv[1]
output_file = sys.argv[2]

print("Writing PDF output as | separated csv to %s" % (output_file))

file_contents = parser.from_file(path.join(input_file))

file_raw_content = str(file_contents['content'])

file_raw_content_encoded = file_raw_content.encode('utf-8', errors='ignore')

file_remove_report_data = re.sub('CONFIDENTIAL.{1,280}Date of report.{3,20}\d of \d', '', str(file_raw_content_encoded))

file_formatted = str(file_remove_report_data).replace("\n","").replace("\\","").replace("_________________________________________________________________________","\n").replace('nn','').replace('b"  n', '').replace('n"', '')

file_format_with_separators = str(file_formatted).replace(' Name of Deceased ','|').replace(' Date of Death ','|').replace(' Usual Address ','|')

with open(output_file, 'w', newline='\n') as csvfile:
    csvfile.write(file_format_with_separators)

print("File written")
