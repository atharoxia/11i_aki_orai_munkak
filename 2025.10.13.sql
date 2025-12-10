--A Ceglédi kistérséghez tartozó városok nevei:
SELECT varos.vnev
FROM varos
WHERE varos.kisterseg = "Ceglédi";

--Az 5000 főnél népesebb vársok neve és népessége:
SELECT varos.vnev, varos.nepesseg
FROM varos
WHERE varos.nepesseg > 5000

--Az 50 és 150 km2 közötti vársok neve, népessége és járása népesség szerint csökkenő sorrendben:
SELECT varos.vnev, varos.nepesseg, varos.jaras
FROM varos
WHERE varos.terulet >= 50 AND varos.terulet <= 150
ORDER BY varos.nepesseg DESC

--Melyik város a legkisebb területű? Írjuk ki a nevét, területét és népességszámát:
SELECT varos.vnev, varos.terulet, varos.nepesseg
FROM varos
ORDER BY varos.terulet ASC
LIMIT 1;

--Melyik a három legnépesebb város Budapesten kívül? Írjuk a nevüket és hogy melyik kistérséghez tartoznak:
SELECT varos.vnev, varos.kisterseg
FROM varos
WHERE varos.vnev <> "Budapest"
ORDER BY nepesseg DESC
LIMIT 3;

--Írjuk ki azon városok minden adatát, amelyeknél a kistérség neve nem egyezik meg a járáséval:
SELECT *
FROM varos
WHERE varos.kisterseg <> varos.jaras;

--Hány város tartozik a Budakeszi járáshoz? A válasz fejléce darab legyen:
SELECT COUNT(*) AS darab
FROM varos
WHERE varos.jaras = "Budakeszi";

--Hány város területe kisebb, mint 10 km2? A válasz fejléce kicsik legyen:
SELECT COUNT(*) AS kicsik
FROM varos
WHERE varos.terulet < 10;

--Írjuk azon városok nevét és lélekszámát, amelyek neve Kiskunnal kezdődik
SELECT varos.vnev, varos.nepesseg
FROM varos
WHERE varos.vnev LIKE "Kiskun%";

--Írjuk azon városok nevét és területét, amelyek neve pontosan 4 betű:
SELECT varos.vnev, varos.terulet
FROM varos
WHERE varos.vnev LIKE "____";

--A három legkisebb népességű város neve és járása:
SELECT varos.vnev, varos.jaras
FROM varos
ORDER BY varos.nepesseg ASC
LIMIT 3;

--Írassuk ki a Bács-Kiskun megyei városok nevét és népességét:
SELECT varos.vnev, varos.nepesseg
FROM varos INNER JOIN megye ON varos.megyeid = megye.id
WHERE megye.mnev = "Bács-Kiskun";

--Megyei jogú városok népesség szerint csökkenő sorban:
SELECT varos.vnev, varos.nepesseg
FROM varos INNER JOIN varostipus ON varos.vtipid = varostipus.id
WHERE varostipus.vtip LIKE "%megyei jogú város%"
ORDER BY varos.nepesseg DESC;

--Hány város van Fejér megyében:
SELECT COUNT(*) AS db
FROM varos INNER JOIN megye ON varos.megyeid = megye.id
WHERE megye.mnev = "Fejér";

--Melyik megyében összesen mennyi városlakó van:
SELECT megye.mnev, SUM(varos.nepesseg) AS lakosok
FROM varos INNER JOIN megye ON varos.megyeid = megye.id
GROUP BY megye.mnev;

--Mely települések tartoznak ugyanahhoz a járáshoz, mint Adony:
SELECT varos.vnev
FROM varos
WHERE varos.jaras = (
    SELECT varos.jaras
	FROM varos
	WHERE varos.vnev = "Adony");

--Bácsalmásnél kisebb népességű városok:
SELECT varos.vnev, varos.nepesseg
FROM varos
WHERE varos.nepesseg < (
    SELECT varos.nepesseg
    FROM varos
	WHERE varos.vnev = "Bácsalmás")

--Melyik városok vannak ugyanabban a megyében, mint Mohács? Mohács ne jelenjen meg!
SELECT varos.vnev
FROM varos
WHERE varos.megyeid = (
	SELECT varos.megyeid
	FROM varos
	WHERE varos.vnev = "Mohács")
AND varos.vnev <> "Mohács";


--Melyik megyékben van több város és mennyi, mint Csongrád megyében:
SELECT megye.mnev, COUNT(*)
FROM megye INNER JOIN varos ON megye.id = varos.megyeid
GROUP BY megye.mnev
HAVING COUNT(*) > (
    SELECT COUNT(*)
	FROM varos INNER JOIN megye ON megye.id = varos.megyeid
	WHERE megye.mnev = "Csongrád");

--Őstermelős feladat
SELECT DISTINCT partnerek.telepules
FROM partnerek
ORDER BY partnerek.telepules;

SELECT COUNT(*) AS alkalmak
FROM kiszallitasok INNER JOIN partnerek ON kiszallitasok.partnerid = partnerek.id
WHERE partnerek.telepules = "Vác";

SELECT kiszallitasok.karton AS legtobb
FROM kiszallitasok
WHERE kiszallitasok.datum LIKE "2016-05%"
ORDER BY kiszallitasok.karton DESC
LIMIT 1;

SELECT partnerek.telepules, COUNT(*)
FROM partnerek
GROUP BY partnerek.telepules
HAVING COUNT(*) > 1;

SELECT gyumolcslevek.gynev AS ital, SUM(kiszallitasok.karton * 6) AS dobozok
FROM gyumolcslevek INNER JOIN kiszallitasok ON gyumolcslevek.id = kiszallitasok.gyumleid
GROUP BY gyumolcslevek.gynev
ORDER BY dobozok DESC


--Kultúrtörténet
--Lekérdezés segítségével írassa ki azon csapatok nevét, amelyek neve a # karakterrel kezdődik!
SELECT csapat.nev
FROM csapat
WHERE csapat.nev LIKE "#%";


--A feladatsor táblát használva, lekérdezés segítségével jelenítse meg a feladatsor névadójának nevét, ha abban pontosan egy szóköz van!
SELECT feladatsor.nevado
FROM feladatsor
WHERE feladatsor.nevado LIKE "% %" AND feladatsor.nevado NOT LIKE "% % %";


--Készítsen lekérdezést, amely megadja, hogy ki a névadója a 2018. szilveszterkor aktív feladatsornak!
SELECT feladatsor.nevado
FROM feladatsor
WHERE feladatsor.kituzes < "2018-12-31" AND feladatsor.hatarido > "2018-12-31";


--Készítsen lekérdezést, amely meghatározza a végeredményt! A csapatok neve és az általuk elért összpontszám jelenjen meg, utóbbi szerint csökkenő sorrendben!
SELECT csapat.nev, SUM(megoldas.pontszam) AS osszpont
FROM megoldas INNER JOIN csapat ON megoldas.csapatid = csapat.id
GROUP BY csapat.nev
ORDER BY osszpont DESC;

--Eredetileg úgy tervezték, hogy minden feladatsor 150 pontos lesz. Néhány esetben a kitűzés után kellett módosítani a feladatsoron, így ez nem valósult meg. Adja meg lekérdezéssel azokat a feladatsorokat, amelyek nem 150 pontosak! A feladatsor névadóját, a művészeti ágat és a pontszámot jelenítse meg!
SELECT feladatsor.nevado, feladatsor.ag, SUM(feladat.pontszam) AS osszpont
FROM feladatsor INNER JOIN feladat ON feladatsor.id = feladat.feladatsorid
GROUP BY feladatsor.id
HAVING osszpont <> 150;

--Lekérdezés segítségével listázza ki azon csapatok nevét, amelyeknek volt maximális pontszámot érő feladata! Minden csapat neve egyszer jelenjen meg!
SELECT DISTINCT csapat.nev
FROM feladat INNER JOIN megoldas ON feladat.id = megoldas.feladatid INNER JOIN csapat ON megoldas.csapatid = csapat.id
WHERE feladat.pontszam = megoldas.pontszam;

--Bár a versenyzők lelkesek voltak és törekedtek minden feladatot megoldani, ennek ellenére előfordult, hogy nem minden feladatra adtak be megoldást. Készítsen lekérdezést, amelymegadja, hogy a „#win” csapat mely feladatsorokból hány feladatot nem adott be! Jelenítse meg a feladatsor névadóját és a be nem adott feladatok számát!
SELECT feladatsor.nevado, COUNT(*)
FROM feladatsor INNER JOIN feladat ON feladatsor.id = feladat.feladatsorid
WHERE feladat.id NOT IN(
	SELECT megoldas.feladatid
	FROM megoldas INNER JOIN csapat ON megoldas.csapatid = csapat.id
	WHERE csapat.nev = "#win")
GROUP BY feladatsor.id;


--Készítsen lekérdezést, amely megadja, hogy az „irodalom” művészeti ághoz tartozó feladatsorok közül melyeket kellett ugyanabban a hónapban beadni, mint amikor kitűzték? Adja meg a feladatsorok névadóját!
SELECT feladatsor.nevado
FROM feladatsor
WHERE MONTH(feladatsor.kituzes) = MONTH(feladatsor.hatarido) AND feladatsor.ag = "irodalom";

--Lekérdezés segítségével adja meg, melyik feladatsor megoldására volt a legkevesebb idő! A feladatsor névadóját jelenítse meg! Ha több ilyen feladatsor van, elegendő az egyiket megadnia.
SELECT feladatsor.nevado, DATEDIFF(feladatsor.hatarido, feladatsor.kituzes) AS napok
FROM feladatsor
ORDER BY napok ASC
LIMIT 1;


--Készítsen lekérdezést, amely megadja, hogy mely feladatoksorokat tűzték ki az előző beadási határidejét követő napon! A feladatsor névadóját és a kitűzés idejét jelenítse meg! A feladat megoldása során kihasználhatja, hogy egyszerre csak egy feladatsor volt aktív.
SELECT kovetkezo.nevado, kovetkezo.kituzes
FROM feladatsor AS elozo, feladatsor AS kovetkezo
WHERE DATEDIFF(kovetkezo.kituzes, elozo.hatarido) = 1;