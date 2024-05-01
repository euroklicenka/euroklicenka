#!/usr/bin/env python3

import json
import sys
from html.parser import HTMLParser

tbody = False
tr = False
td = False
no = 0
entry = {"type": "wc"}
id = 1000 # Slovensko

parsed = []

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        global tbody
        global tr
        global td
        global no
        global data
        global entry
        if tag == "tbody":
            tbody = True

        if tbody and tag == "tr":
            tr = True
            entry = {"type": "wc"}
            no = 0

        if tbody and tr and tag == "td":
            td = True
            data = []
            no += 1

    def handle_endtag(self, tag):
        global tbody
        global tr
        global td
        global no
        global data
        global entry
        if tbody and tag == "tbody":
            tbody = False
        if tbody and tr and tag == "tr":
            tr = False
            parsed.append(entry)
        if tbody and tr and td and tag == "td":
            td = False
            if no == 1: # logo
                pass
            elif no == 2: # kraj
                if data[0] == "BA":
                    entry['region'] = "Bratislavský kraj"
                elif data[0] == "TT":
                    entry['region'] = "Trnavský kraj"
                elif data[0] == "NR":
                    entry['region'] = "Nitriansky kraj"
                elif data[0] == "BB":
                    entry['region'] = "Banskobystrický kraj"
                elif data[0] == "KE":
                    entry['region'] = "Košický kraj"
                elif data[0] == "PO":
                    entry['region'] = "Prešovský kraj"
                elif data[0] == "TN":
                    entry['region'] = "Trenčiansky kraj"
                elif data[0] == "ZA":
                    entry['region'] = "Žilinský kraj"
                else:
                    assert False
            elif no == 3: # nazev
                entry['place'] = " ".join(data).strip()
            elif no == 4: # adresa
                if len(data) == 1:
                    data.append(data[0])
                    data[0] = ""
                entry['street'] = data[0]

                import re
                r = re.compile("[0-9]{3} [0-9]{2}")
                m = r.search(data[1])
                if m is not None:
                    entry['zip'] = m.group(0)
                    entry['city'] = data[1][len(entry['zip']) + 1:].strip()
                else:
                    entry['zip'] = ""
                    entry['city'] = data[1]

            elif no == 5: # popis
                entry['description'] = " ".join(data).strip()
            elif no == 6: # gps
                entry['lat'] = data[0]
                entry['lng'] = data[1]
            elif no == 7: # otevírací doba
                entry['hours'] = " ".join(data).strip()

#            entry['lat'] = gps[0].strip()
#            entry['lng'] = gps[1].strip()

    def handle_data(self, content):
        global td
        global no
        global data
        global entry

        if tbody and tr and td:
            data.append(content)

parser = MyHTMLParser()
with open(sys.argv[1]) as f:
    parser.feed(f.read())

with open(sys.argv[2], 'w') as json_file:
    json.dump(parsed, json_file, skipkeys = True, indent = 2)
