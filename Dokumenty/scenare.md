# Scénáře – Euroklíčenka 2.0

**EuroKlíčenka - Use Case – Operace s mapou**

**Name:** Operace s mapou

**Actor:** Uživatel

**Preconditions:** Zařízení musí být připojeno k internetu a mít sdílenou polohu.

**Postcondition:** Uživatel může najít konkrétní místo na stránce s mapou a zobrazit v seznamu nejbližší místa.

**Basic flow:**

1.	Uživatel zapne aplikaci Euroklíčenka a přejde na stránku "*mapa*".
2.	Klikne na vyhledávací pole a zadá požadovanou adresu.
3.	Našeptávač uživateli nabídne možné shody, které uživatel může vybrat, nebo mu poskytne další možnosti na dokončení zadávané adresy.
4.	Uživatel klikne na doporučenou adresu nebo po zadání celé adresy potvrdí vyhledávání.
5.	Po potvrzení se na mapě zobrazí požadované místo zvýrazněné červeným symbolem.
6.	Uživatel může přejít na kartu "*seznam*". Zde se mu zobrazí nejbližší místa k místu co vyhledal.
7.	Uživatel klikne na nějaké z uvedených míst, které se následně zobrazí na kartě "*mapa*".
   
**Alternative flow:**

• **Alternativní vyhledání místa na kartě seznam**: Uživatel může zadat adresu do vyhledávače na kartě seznam. Adresa se mu následně zobrazí na mapě v kartě "*mapa*".

• **Výchozí místo**: Pokud uživatel nezadá žádnou adresu, zobrazí se mu v seznamu nejbližší místa v jeho současné lokaci. 

• **Zrušení hledání**: Uživatel může kdykoli zrušit hledání a vrátit se zpět na kartu s mapou bez zobrazení výsledků.

• **Nepřipojen k internetu**: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.

## EuroKlíčenka - Use Case - Hodnocení míst

**Name**: Hodnocení míst

**Preconditions**: Zařízení musí být připojeno k internetu.

**Postcondition**: Uživatel zadá adresu, u které by si rád našel euroklíč a aplikace zobrazí hodnocení těchto míst.

**Basic flow**:

1.	Uživatel zapne aplikaci Euroklíčenka a přejde na stránku "*mapa*". 
2.	Klikne na vyhledávací pole a zadá požadovanou adresu. 
3.	Našeptávač uživateli nabídne možné shody, které uživatel může vybrat, nebo mu poskytne další možnosti na dokončení zadávané adresy. 
4.	Uživatel klikne na doporučenou adresu nebo po zadání celé adresy potvrdí vyhledávání.
5.	Po potvrzení se na mapě zobrazí požadované místo zvýrazněné červeným symbolem.
6.	Uživatel si vybere místo v okolí zadané adresy.
7.	Uživatel klikne na ikonu a tím zobrazí detailní informace o daném místě .
8.	Zobrazí se okno s detailními informacemi, kde se nachází informace o kvalitě daného místa vedle ikony s hvězdičkou.
9.	Uživatel klikne na tlačítko "*přidat hodnocení*", pokud chce přidat hodnocení.
10. Systém mu zobrazí formulář s hvězdičkami které symbolizují kvalitu daného místa.
11. Uživatel vybere počet hvězdiček a klikne na tlačítko "*uložit hodnocení*".
12. Systém uloží hodnocení a přiřadí ho ke konkrétnímu místu.

**Alternative Flow**:

• **Storno hodnocení**: Uživatel může kdykoli stornovat své hodnocení před odesláním a vrátit se na stránku s výsledky vyhledávání nebo podrobnostmi o místě.

• **Nepřipojen k internetu**: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.

## EuroKlíčenka - Use Case – Operace s mapou

**Name**: Návrat na aktuální polohu

**Actor:** Uživatel

**Preconditions**: Zařízení musí být připojeno k internetu.

**Postcondition**: Uživatel se může přesunout zpátky na místo, kde se aktuálně nachází.

**Basic flow**:

1. Uživatel přejde na kartu "*mapa*".
2. Uživatel posouvá svojí polohu po mapě, aby získal lepší přehled o okolí.
3. Uživatel ztratí svou konkrétní polohu a chce se vrátit zpátky.
4. Uživatel klikne 2x rychle zasebou, aby se vrátil na svou původní polohu.
5. Mapa se vráti na aktuální polohu uživatele.

**Alternative Flow**:

• **Ikona návratu na aktuální polohu**: na rohu obrazovky se zobrazí jasně viditelná ikona symbolizující návrat na aktuální polohu uživatele. Po kliknutí na ikonu se uživatel automaticky vrátí na aktuální polohu.

