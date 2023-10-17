# Scénáře – Euroklíčenka 2.0

## EuroKlíčenka - Use Case - Hodnocení míst

**Name**: Hodnocení míst

**Preconditions**: Zařízení musí být připojeno k internetu.

**Basic flow**:

1. Uživatel vybere volbu vyhledávání lokace
2. Systém zobrazí textové pole na vyhledávání
3. Uživatel zadá lokaci( pomocí filtru-> města,místa)
4. Uživatel si vybere dané místo z nabízených možností
5. Uživatel si vybere možnost hodnocení 
6. Systém zobrazí okno s hodnocením a  s textovým polem
7. Uživatel hodnocení uloží
8. Systém hodnocení uloží 
9. Systém hodnocení zobrazí

**Alternative Flow**:

1. Uživatel špatně zadal hledanou lokaci, upozornění uživatele
2. Nepřítomnost internetu/GPS signálu, upozornění uživatele
3. Uživatel si zobrazí základní informace o euromístu (typ místa, budova, poschodí, GPS souřadnice)
4. Uživatel si vybere možnost navigace k dané lokaci -> Zobrazí se API google.maps
5. Nastane chyba v databázi a hodnocení nebude uloženo (uživatel bude upozorňen) 
6. Nepřítomnost internetu/ upozornění uživatele
7. Chyba databáze systém neuloží hodnocení (uživatel bude upozorněn)

**Postcondition**:

Uživatel zadá adresu, u které by si rád našel euroklíč a aplikace zobrazí hodnocení těchto míst.

## EuroKlíčenka - Use Case – Zobrazení nejbližších lokací na mapě

**Name**: Zobrazení nejbližších lokací na mapě

**Actor**: Uživatel

**Preconditions**: Zařízení musí být připojeno k internetu a mít sdílenou polohu.

**Basic flow**:

1. Uživatel vybere volbu vyhledávání lokace (Moje poloha)
2. Systém zobrazí MapsActivity stránku (aktuální polohu uživatele na mapě)
3. Zobrazení nejbližších euroklíč míst od aktuální polohy

**Alternative Flow**:

1. Nezobrazí se mapy -> ztráta připojení k internetu
2. Nezobrazí se žádné místa -> Ztráta GPS připojení

**Postcondition**:

Uživatel si vybere z blízkých míst nabízených na mapě

## EuroKlíčenka - Use Case – Operace s mapou

**Name**: Operace s mapou

## EuroKlíčenka - Use Case – Vyhledání specifické lokace

**Name**: Vyhledání specifické lokace

**Actor**: Uživatel

**Preconditions**: Zařízení musí být připojeno k internetu.

**Basic flow**:

1. Uživatel vybere volbu vyhledávání lokace
2. Systém zobrazí textové pole na vyhledávání
3. Uživatel zadá lokaci( pomocí filtru-> města,místa)
4. Uživatel si vybere dané místo z nabízených možností

**Alternative Flow**:

1. Uživatel špatně zadal hledanou lokaci, upozornění uživatele
2. Nepřítomnost internetu/GPS signálu, upozornění uživatele
3. Uživatel si zobrazí základní informace o euromístu (typ místa, budova, poschodí, GPS souřadnice)
4. Uživatel si vybere možnost navigace k dané lokaci -> Zobrazí se API google.maps

**Postcondition**:

Uživatel zadá adresu, u které by si rád našel euroklíč místa a aplikace zobrazí nejbližší místa od zadané lokace

## EuroKlíčenka - Use Case – Zobrazení nejbližších lokací na mapě

**Name**: Zobrazení nejbližších lokací na mapě

**Actor**: Uživatel

**Preconditions**: Zařízení musí být připojeno k internetu a mít sdílenou polohu.

**Basic flow**:

1. Uživatel vybere volbu vyhledávání lokace (Moje poloha)
2. Systém zobrazí MapsActivity stránku (aktuální polohu uživatele na mapě)
3. Zobrazení nejbližších euroklíč míst od aktuální polohy

**Alternative Flow**:

1. Nezobrazí se mapy -> ztráta připojení k internetu
2. Nezobrazí se žádné místa -> Ztráta GPS připojení

**Postcondition**:

Uživatel si vybere z blízkých míst nabízených na mapě

## EuroKlíčenka - Use Case – První spuštění aplikace

**Name**: První spuštění aplikace

**Actor**: Uživatel

**Preconditions**: Nainstalovaná aplikace

**Basic flow**:

1. Uživatel spustí aplikaci.
2. Aplikace zobrazí návod, jak používat aplikaci v podobě několika karet.
3. Uživatel může tyto karty přeskakovat po jednom pomocí tlačítka „další“, nebo rovnou přeskočí všechny pomocí tlačítka „přeskočit“.

**Postcondition**:

Uživatel byl seznámen s funkcemi aplikace a nyní je v hlavní nabídce
