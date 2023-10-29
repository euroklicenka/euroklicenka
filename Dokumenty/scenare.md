# Scénáře – Euroklíčenka 2.0

## EuroKlíčenka - Use Case - Hodnocení míst (new)

**Name**: Hodnocení konkrétního místa

**Aktéři**: Uživatel, systém

**Popis**: Postup, kterým uživatel hodnotí konkrétní místo

**Preconditions**: Zařízení musí být připojeno k internetu

**Basic flow**:

1.	Uživatel otevře aplikaci.
2.	Uživatel použije funkci vyhledávání a zadá konkrétní místo.
3.	Aplikace zobrazí výsledky vyhledávání obsahující nalezené místo.
4.	Uživatel klikne na název nalezeného místa, aby zobrazil podrobnosti o něm.
5.	Aplikace zobrazí podrobnosti o místě, včetně názvu, adresy a dalších informací.
6.	Zde uživatel najde možnost "Hodnotit" a klikne na ni.
7.	Aplikace otevře formulář pro hodnocení místa, který obsahuje pole pro hodnocení a tlačítko pro potvrzení.
8.	Uživatel zadá hodnocení (například hodnocení na stupnici od 1 do 5).
9.	Po dokončení uživatel klikne na tlačítko "Odeslat".
10.	Aplikace uloží uživatelovo hodnocení pro toto místo.

**Alternative Flow**:

1. *Storno hodnocení*: Uživatel může kdykoli stornovat své hodnocení před odesláním a vrátit se na stránku s výsledky vyhledávání nebo podrobnostmi o místě.
2. *Nesprávný vstup*: Pokud uživatel nevyplní všechny požadované údaje, aplikace by měla zobrazit upozornění na chybě a vyzvat uživatele, aby doplnil chybějící údaje.
3. *Nepřipojen k internetu*: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.

**Postcondition**:

Uživatel zadá adresu, u které by si rád našel euroklíč a aplikace zobrazí hodnocení těchto míst.

## EuroKlíčenka - Use Case – Operace s mapou (new)

**Name**: Operace s mapou

**Aktéři**: Uživatel

**Popis**: Akce, kdy uživatel hledá místo na mapě.

**Preconditions**: Zařízení musí být připojeno k internetu

**Basic flow**:

1.	Uživatel otevře aplikaci a přejde na kartu s mapou.
2.	Na kartě s mapou uvidí vyhledávací pole
3.	Uživatel klikne na vyhledávací pole
4.	Uživatel zadá hledanou adresu do textového pole.
5.	Jakmile uživatel dokončí zadávání adresy, klikne na tlačítko "Hledat" nebo použije klávesu "Enter".
6.	Aplikace odešle zadání adresy na server, kde probíhá vyhledávání.
7.	Server vrátí výsledky vyhledávání, které zahrnují nalezenou adresu a případně další informace jako geografické souřadnice.
8.	Aplikace zobrazí na mapě nalezenou adresu nebo místo na základě vrácených geografických souřadnic.
9.	Uživatel může přiblížit nebo oddálit mapu a prozkoumávat místo.

**Alternative Flow**:
1. *Chybný vstup*: Pokud uživatel nezadá adresu správně nebo server nemůže najít odpovídající místo, aplikace by měla zobrazit chybovou zprávu a umožnit uživateli znovu zadat adresu.
2. *Zrušení hledání*: Uživatel může kdykoli zrušit hledání a vrátit se zpět na kartu s mapou bez zobrazení výsledků.
3. *Nepřipojen k internetu*: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.

**Postcondition**: Uživatel je schopen na stránce s mapou vyhledávat konkrétní místa

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
