# Scénáře – Euroklíčenka 2.0

## EuroKlíčenka - Use Case - Hodnocení míst (new)

**Name**: Hodnocení míst

**Preconditions**: Zařízení musí být připojeno k internetu.

**Basic flow**:

1.	Uživatel zapne aplikaci Euroklíčenka a přejde na stránku "mapa". 
2.	Klikne na vyhledávací pole a zadá požadovanou adresu. 
3.	Našeptávač uživateli nabídne možné shody, které uživatel může vybrat, nebo mu poskytne další možnosti na dokončení zadávané adresy. 
4.	Uživatel klikne na doporučenou adresu nebo po zadání celé adresy potvrdí vyhledávání.
5.	Po potvrzení se na mapě zobrazí požadované místo. (Dané místo je zvýrazněno ikonou podle toho o jaké zařízení se jedná).
6.	Uživatel klikne na ikonu a tím zobrazí detailní informace o daném místě .
7.	Zobrazí se okno s detailními informacemi, kde se nachází informace o kvalitě daného místa vedle ikony s hvězdičkou.
8.	Uživatel klikne na tlačítko "přidat hodnocení", pokud chce přidat hodnocení.
9.	Systém mu zobrazí formulář s hvězdičkami které symbolizují kvalitu daného místa.
10.	Uživatel vybere počet hvězdiček a klikne na tlačítko „uložit hodnocení“.
11.	Systém uloží hodnocení a přiřadí ho ke konkrétnímu místu.
12.	Na základě průměru hodnocení uživatelů systém zobrazí hodnocení místa.

**Alternative Flow**:

•*Storno hodnocení*: Uživatel může kdykoli stornovat své hodnocení před odesláním a vrátit se na stránku s výsledky vyhledávání nebo podrobnostmi o místě.
•*Nesprávný vstup*: Pokud uživatel nevyplní všechny požadované údaje, aplikace by měla zobrazit upozornění na chybě a vyzvat uživatele, aby doplnil chybějící údaje.
•*Nepřipojen k internetu*: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.

**Postcondition**:

Uživatel zadá adresu, u které by si rád našel euroklíč a aplikace zobrazí hodnocení těchto míst.

## EuroKlíčenka - Use Case – Operace s mapou (new)

**Name**: Operace s mapou

**Actor**: Uživatel

**Preconditions**: Zařízení musí být připojeno k internetu.

**Basic flow**:

1.	Uživatel zapne aplikaci Euroklíčenka a přejde na stránku „mapa“. 
2.	Klikne na vyhledávací pole a zadá požadovanou adresu. 
3.	Našeptávač uživateli nabídne možné shody, které uživatel může vybrat, nebo mu poskytne další možnosti na dokončení zadávané adresy. 
4.	Uživatel klikne na doporučenou adresu nebo po zadání celé adresy potvrdí vyhledávání.
5.	Po potvrzení se na mapě zobrazí požadované místo. (Dané místo je zvýrazněno ikonou podle toho o jaké zařízení se jedná)
6.	Uživatel může kliknout na tento ukazatel a zobrazit si tak detailní informace o daném místě 

**Alternative flow**:

•	*Chybný vstup*: Pokud uživatel nezadá adresu správně nebo server nemůže najít odpovídající místo, aplikace by měla zobrazit chybovou zprávu a umožnit uživateli znovu zadat adresu.

•	*Zrušení hledání*: Uživatel může kdykoli zrušit hledání a vrátit se zpět na kartu s mapou bez zobrazení výsledků.

•	*Nepřipojen k internetu*: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po 
obnovení připojení.

**Postcondition**:

Uživatel může najít konkrétní místo na stránce s mapou

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
