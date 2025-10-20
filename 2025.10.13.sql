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


