#!/usr/bin/env python3

import pandas
import json

excel_data_df = pandas.read_excel('9ce2559301112481.xlsx')

# Convert excel to string
# (define orientation of document in this case from up to down)
thisisjson = excel_data_df.to_json(orient='records')

data = json.loads(thisisjson)

parsed = []

id = 0
for row in data:
    import re

    id += 1
    region = row['KRAJ']
    city = row['MĚSTO']
    full_address = row['ORIGINÁLNÍ ZÁZNAM']
    latlng = row['GPS']

    if latlng is None:
        print(f"SKIP: {row}")
        continue

    # 50°5'11.124", 14°25'4.031"
    r = re.compile('[°\'", ]+')
    _ = r.split(latlng.strip())
    if (len(_) == 8):
        _ = _[0:3] + _[4:7]

    lat = float(_[0]) + float(_[1]) / 60 + float(_[2]) / 3600;
    lng = float(_[3]) + float(_[4]) / 60 + float(_[5]) / 3600;

    # WC (1E). Městský úřad Zlín, L. Váchy 602, 761 40 Zlín
    r = re.compile("[^.]*[.]")
    m = r.search(full_address)

    euk_type = m.group(0).strip(".")

    if m.group(0).find("WC") >= 0:
        euk_type = "wc"
    elif m.group(0).find("Výtah") >= 0:
        euk_type = "elevator"
    elif m.group(0).find("Brána") >= 0:
        euk_type = "gate"
    elif m.group(0).find("Plošina") >= 0:
        euk_type = "platform"
    else:
        print(euk_type)

    address = full_address[len(m.group(0)):].strip()

    r = re.compile(', [0-9]{3} [0-9]{2} .*$')
    m = r.search(full_address)

    if m is None:
        print(f"SKIP: {row}")
        continue

    zip_address = m.group(0).strip(". ")

    r = re.compile("[0-9]{3} [0-9]{2}")
    m = r.search(zip_address)

    if m is None:
        print(f"SKIP: {row}")
        break

    zip = m.group(0)

    address = address[:-len(zip_address)].strip(", ")

    parsed.append({
        "id": id,
        "lat": lat,
        "lng": lng,
        "address": address,
        "region": region,
        "city": city,
        "zip": zip,
        "type": euk_type,
    })

#    newd = {}
#    newd['#'] = row['#']
#    newd['kraj'] = row['KRAJ']

#    break

with open('data.json', 'w') as json_file:
    json.dump(parsed, json_file, skipkeys = True, indent = 2)
