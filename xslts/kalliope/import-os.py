import requests
import xml.etree.ElementTree as ET

url = "https://kalliope-verbund.info/sru?version=1.2&operation=searchRetrieve&query=Arthur+Schnitzler&recordSchema=mods"

# Get the number of records from the SRU endpoint
response = requests.get(url + "&maximumRecords=0")
root = ET.fromstring(response.content)
num_records = int(root.find(".//{http://www.loc.gov/zing/srw/}numberOfRecords").text)

# Set the batch size and initialize counters
batch_size = 100
start_record = 1

# Open the output file
with open("results.xml", "wb") as f:

    # Write the XML header
    f.write(b'<?xml version="1.0" encoding="UTF-8"?>\n<records>\n')

    # Loop through all records and write them to the output file
    while start_record <= num_records:

        # Get the records for the current batch
        response = requests.get(url + f"&startRecord={start_record}&maximumRecords={batch_size}")
        root = ET.fromstring(response.content)
        records = root.findall(".//{http://www.loc.gov/mods/v3}mods")

        # Write the records to the output file
        for record in records:
            f.write(ET.tostring(record))

        # Increment the start record counter
        start_record += batch_size

    # Write the XML footer
    f.write(b'</records>')
