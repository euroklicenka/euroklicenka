# Aktualizace míst

Místa s Euroklíči jsou uložena ve formátu JSON jako seznam, každá
položka má následující strukturu:

  {
    "id": unikátní id (integer),
    "lat": zeměpisná šířka (double),
    "lng": zeměpisná délka (double),
    "place": název místa (string),
    "street": ulice" (string),
    "region": kraj (string),
    "city": město (string),
    "zip": PSČ (string),
    "type": jedna z následujících: wc, elevator, gate, platform (string),
  },

## Místa v Česku

Místa v ČR jsou k dispozici na stránkách https://www.euroklic.cz pod
položkou "Kde mohu použít Euroklíč".  Je zapotřebí stáhnout kompletní
seznam míst jako XLSX, a následně je zpracovat pomocí programu v
Pythonu, který je uložen v bin/xlsx2json.py.  Ideální postup je
použití venv:

    $ python3 -m venv venv
    $ source venv/bin/activate
    $ pip3 install pandas
    $ pip3 install openpyxl
    $ bin/xlsx2json.py bin/pruvodce.xlsx

Je možné, že vstupní soubor může obsahovat špatně naformátovaná data,
v takovém případě jsou řádky, které program přeskočil, vypsány v
následujícím formátu:

SKIP: {'#': 379, 'KRAJ': 'Jihočeský', 'MĚSTO': 'České Budějovice', 'OSAZENÉ MÍSTO': 'WC (1E). Veřejné WC Záchytné parkoviště Jírovcova, č.parc. 2097/56,  370 04 České Budějovice', 'GPS': '48°59\'11.441", 14°28\'40.289"'}
SKIP: {'#': 647, 'KRAJ': 'Ústecký', 'MĚSTO': 'Podbořany', 'OSAZENÉ MÍSTO': 'WC (1E). Úřad práce ČR Podbořany, Masarykovo náměstí 733, 441 01 Podbořany', 'GPS': '50°13′41.35″, 13°24′27.105″'}

V prvním případě jsou před PSČ dvě mezery, a v druhém případě se pro
minuty a sekundy používá jiný znak než ' a ".  Obojí je možné opravit
i v samotném skriptu (v budoucnu), ale autoři souboru pokaždé přijdou
s novou kreativní verzí.

## Místa na Slovensku

Slovenská místa osazená Euroklíčem se parsují přímo z HTML stránky
http://www.eurokluc.sk/euro-wc-Sk.html pomocí skriptu bin/parse-sk.py.

    $ curl -sSLO http://www.eurokluc.sk/euro-wc-Sk.html
    $ python3 bin/parse-sk.py euro-wc-Sk.html assets/data-sk.json

## Aktualizace souborů v aplikaci

Následně je možné provést aktualizaci míst v aplikaci dvěmi způsoby:

1. Sestavením nové verze aplikace
2. Aktualizací souborů na webu cdn.euroklicenka.cz; přistupové údaje
   přes FTP jsou k dispozici na vyžádání.  Aplikace si je pak jednou
   denně stahuje.