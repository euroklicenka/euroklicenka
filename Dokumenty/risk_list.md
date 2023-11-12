# Risk List

| ID | Risk | Dopad | MA (Mitigační akce) | Priorita[^1] | Pravděpodobnost |
|----|------|-------|---------------------|----------|-----------------|
| R1 | Slabá komunikace | Členové týmu nebudou na stejné stránce, ohledně stavu projektu. Může dojít k nevědomosti, co už je hotové a co je třeba udělat dál. | Sledování prováděné aktivity v Jire. Přidělení práce hned na začátku sprintu. Kontrola před koncem. O nečekaných změnách ohledně práce informovat celý tým několik dní předem. | 3 | 80% |
| R2 | Neznalost technologie Flutter | Bez známosti použité technologie není možné pokračovat ve vývoji projektu. | Seznámit se součástmi technologie (Gradle, Dart, Flutter) vytvořením drobného prototypu. Průběžné sdílení zkušeností. | 5 | 60% |
| R3 | Nekvalitní kód | Rychle psaný a nekontrolovaný kód vede ke slabé udržitelnosti a snížené použitelnosti (bugy) softwaru. | Použití architektury, dodržování best practises. Průběžné manuální testování. Tvorba automatických testů. Implementace Continuous Integration. | 2 | 25% |
| R4 | Náhlé změny požadavků (zákazníkem) | Promarněný čas, nekompletní funkce. | Domluva se zákazníkem => Způsob "Něco za něco" - implementace funkcí na úkor jiných. | 2 | 0% |
| R5 | Ztráta člena týmu | Snížení efektivnosti celého týmu a zvýšení zátěže pro zbývající členy. | Aspoň jeden další člen má přehled v problematice chybějící osoby. Dokumentace prováděné činnosti. Krátké sprinty (1-2 týdny). | 5 | 30% |
| R6 | Časová náročnost projektu | Může vést k nedodržení termínu jednotlivých sprintů | Využití plánovacího softwaru přidělení práce každému členu týmu | 2 | 50 % |
| R7 | Nedostatečná znalost aktuálního stavu aplikace | Může vést k chybám ve vývoji kvůli neznalosti aplikace | Studium dokumentace předchozího týmu | 3 | 30 % |
| R8 | Změna datového zdroje | Pokud Euroklíč změní URL k souboru dat o místech osazených eurozámkem, znamená to aplikaci úplné odříznutí od dat. | Domluva s vedoucími Euroklíče o potřebách aplikace. Držení offline EUK dat. | 6 | 100% |
| R9 | Změna technologie | Použitá technologie (Flutter, Dart), která byla zvolena předchozím týmem závisí na externích knihovnách, které se mohou měnit. | Použít best-practices pro správu externích závislostí. Udržovat knihovny v průběhu vývoje aktualizované. | 6 | 100% |
| R10 | Bezpečnostní chyby v externích knihovnách | Externí knihovny mohou obsahovat bezpečnostní chyby, které vynutí aktualizaci knihoven. | Používat pouze podporované verze externích knihoven, SDK a kompilátoru, aby bylo možné knihovny aktualizovat na verzi, která má opravené bezpečnostní chyby. | 6 | 100% |
| R11 | Technologický dluh | Kód existujícího projektu je neudržovaný nebo neudržovatelný. | Důkladné prostudování stávajícího zdrojového kódu a použitých technologií. | 3 | 50% |
| R12 | Přetížení zdroje dat | Uživatelé budou aplikaci hodně využívat a kvůli nevhodně zvolené technologii dojde k přetížení zdroje. | Lokální cache zdroje dat, automatická i manuální aktualizace dat. Remote cache v CDN. | 2 | 10 % |

[^1]: Priority jsou číslované 1-6, kde 1 má nejmenší prioritu, 6 má největší prioritu.
