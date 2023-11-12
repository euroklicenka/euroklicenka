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
5.	Po potvrzení se na mapě zobrazí požadované místo. (Dané místo je zvýrazněno ikonou podle toho o jaké zařízení se jedná)
6.	Uživatel může kliknout na tento ukazatel a zobrazit si tak detailní informace o daném místě
7.	Uživatel může přejít na kartu "*seznam*". Zde se mu zobrazí nejbližší místa k místu co vyhledal.
8.	Uživatel klikne na nějaké z uvedených míst, které se následně zobrazí na kartě "*mapa*" (opět zvýrazněné ikonou).
   
**Alternative flow:**

• **Alternativní vyhledání místa na kartě seznam**: Uživatel může zadat adresu do vyhledávače na kartě seznam. Adresa se mu následně zobrazí na mapě v kartě "*mapa*".

• **Výchozí místo**: Pokud uživatel nezadá žádnou adresu, zobrazí se mu v seznamu nejbližší místa v jeho současné lokaci. 

• **Zrušení hledání**: Uživatel může kdykoli zrušit hledání a vrátit se zpět na kartu s mapou bez zobrazení výsledků.

• **Nepřipojen k internetu**: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.

• **Ztráta GPS připojení**: Pokud uživatel nemá připojení k GPS, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení

## EuroKlíčenka - Use Case - Hodnocení míst

**Name**: Hodnocení míst

**Preconditions**: Zařízení musí být připojeno k internetu.

**Postcondition**: Uživatel zadá adresu, u které by si rád našel euroklíč a aplikace zobrazí hodnocení těchto míst.

**Basic flow**:

1.	Uživatel zapne aplikaci Euroklíčenka a přejde na stránku "*mapa*". 
2.	Klikne na vyhledávací pole a zadá požadovanou adresu. 
3.	Našeptávač uživateli nabídne možné shody, které uživatel může vybrat, nebo mu poskytne další možnosti na dokončení zadávané adresy. 
4.	Uživatel klikne na doporučenou adresu nebo po zadání celé adresy potvrdí vyhledávání.
5.	Po potvrzení se na mapě zobrazí požadované místo. (Dané místo je zvýrazněno ikonou podle toho o jaké zařízení se jedná).
6.	Uživatel klikne na ikonu a tím zobrazí detailní informace o daném místě .
7.	Zobrazí se okno s detailními informacemi, kde se nachází informace o kvalitě daného místa vedle ikony s hvězdičkou.
8.	Uživatel klikne na tlačítko "*přidat hodnocení*", pokud chce přidat hodnocení.
9.	Systém mu zobrazí formulář s hvězdičkami které symbolizují kvalitu daného místa.
10.	Uživatel vybere počet hvězdiček a klikne na tlačítko "*uložit hodnocení*".
11.	Systém uloží hodnocení a přiřadí ho ke konkrétnímu místu.

**Alternative Flow**:

• **Storno hodnocení**: Uživatel může kdykoli stornovat své hodnocení před odesláním a vrátit se na stránku s výsledky vyhledávání nebo podrobnostmi o místě.

• **Nepřipojen k internetu**: Pokud uživatel nemá připojení k internetu, aplikace by měla informovat o této situaci a nabídnout možnost opětovného pokusu po obnovení připojení.


