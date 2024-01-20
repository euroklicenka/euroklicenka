# Risk List

| ID | Risk | Dopad | MA (Mitigační akce) | Priorita[^1] | Pravděpodobnost |
|----|------|-------|---------------------|----------|-----------------|
| R1 | Časová náročnost projektu | Může vést k nedodržení termínu jednotlivých sprintů. | Využití plánovacího softwaru přidělení práce každému členu týmu. | 3 | 60 % |
| R2 | Chyby v použitých knihovnách | Může vést k neočekávaným chybám a snížení kvality aplikace. | Pravidelné testování aplikace. | 4 | 50 % |
| R3 | Chyby ve Flutter SDK | Může vést k neočekávaným chybám, snížení kvality aplikace a znemožnění publikace na Google Play nebo App Store. | Pravidelné testování aplikace. | 6 | 50 % |
| R4 | Nedostatek komunikace ze strany zadavatele | Může vést k nedodržení termínu jednotlivých sprintů. | Pravidelné schůzky s zadavatelem. | 5 | 80 % |
| R5 | Bezpečnostní chyby v externích knihovnách | Externí knihovny mohou obsahovat bezpečnostní chyby, které vynutí aktualizaci knihoven. | Používat pouze podporované verze externích knihoven, SDK a kompilátoru, aby bylo možné knihovny aktualizovat na verzi, která má opravené bezpečnostní chyby. | 2 | 40% |
| R6 | Změna datového zdroje | Pokud Euroklíč změní URL k souboru dat o místech osazených eurozámkem, znamená to aplikaci úplné odříznutí od dat. | Domluva s vedoucími Euroklíče o potřebách aplikace. Držení offline EUK dat. | 5 | 30% |
| R7 | Změna technologie | Použitá technologie (Flutter, Dart), která byla zvolena předchozím týmem závisí na externích knihovnách, které se mohou měnit. | Použít best-practices pro správu externích závislostí. Udržovat knihovny v průběhu vývoje aktualizované. | 1 | 10% |

[^1]: Priority jsou číslované 1-6, kde 1 má nejmenší prioritu, 6 má největší prioritu.
