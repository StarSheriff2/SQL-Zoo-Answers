-- Excercises taken from https://sqlzoo.net/

/**
  ====SELECT basics====
**/

/**1**/
SELECT population FROM world
WHERE name = 'Germany'

/**2**/
SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway','Denmark');

/**3**/
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000;

/**
  ====SELECT from WORLD Tutorial====
**/

SELECT name, continent, population FROM world

SELECT name
  FROM world
 WHERE population >= 200000000;

SELECT name, gdp/population AS 'per capita GDP'
FROM world
WHERE population >= 200000000;

SELECT name, population/1000000 AS 'Population in Millions'
FROM world
WHERE continent = 'South America';

SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

SELECT name
FROM world
WHERE name LIKE '%UNited%';

SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000;

SELECT name, population, area
FROM world
WHERE area > 3000000 AND population < 250000000 OR area < 3000000 AND population > 250000000;

SELECT name, ROUND(population/1000000,2) AS 'Popul. in Mil', ROUND(gdp/1000000000,2) AS 'GDP in Bil.'
FROM world
WHERE continent = 'South America';

SELECT name, ROUND((gdp/population)/1000) * 1000 AS 'per capita GDP'
FROM world
WHERE gdp >= 1000000000000;

SELECT name, capital
  FROM world
 WHERE LENGTH(name) = LENGTH(capital);

SELECT name, capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1) AND name != capital;

SELECT name
FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%' AND name NOT LIKE '% %';

/**
  ====SELECT from Nobel Tutorial====
**/

SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'

SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein'

SELECT winner
FROM nobel
WHERE yr >= 2000 AND subject = 'Peace'

SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Literature' AND yr BETWEEN 1980 AND 1989

SELECT * FROM nobel
WHERE winner
IN (
    'Theodore Roosevelt',
    'Woodrow Wilson',
    'Jimmy Carter',
    'Barack Obama'
    )

SELECT winner
FROM nobel
WHERE winner LIKE 'John%'

SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Physics' AND yr = 1980 OR subject = 'Chemistry' AND yr = 1984

SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine')

SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Medicine' AND yr < 1910 OR subject = 'Literature' AND yr >= 2004;

SELECT *
FROM nobel
WHERE winner = 'PETER GRÜNBERG'

SELECT *
FROM nobel
WHERE winner LIKE 'EUGENE O_NEILL'

SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC

/**
  ====SELECT within SELECT Tutorial====
**/

SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name = 'Russia')

SELECT name
FROM world
WHERE continent = 'Europe'
AND gdp/population > (SELECT gdp/population FROM world
  WHERE name = 'United Kingdom')

SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world
  WHERE name IN ('Argentina', 'Australia'))
ORDER BY name

SELECT name, population
FROM world
WHERE population > (SELECT population FROM world
  WHERE name = 'Canada')
AND population < (SELECT population FROM world
  WHERE name = 'Poland');

SELECT name AS Name, CONCAT(ROUND(population/(SELECT population FROM world
                      WHERE name = 'Germany')*100),
    '%') AS Percentage
FROM world
WHERE continent = 'Europe';

SELECT name
FROM world
WHERE gdp > ALL(SELECT gdp
                FROM world
                WHERE continent = 'Europe'
                AND gdp > 0);

SELECT continent, name, area
FROM world x
WHERE area >= ALL(
        SELECT area FROM world y
        WHERE y.continent = x.continent
        AND area > 0
        );

SELECT continent, name
FROM world x
WHERE name = (SELECT name FROM world y
              WHERE y.continent = x.continent
              ORDER BY name
              LIMIT 1);

SELECT name, continent, population
FROM world x
WHERE (
       SELECT MAX(population)
       FROM world y
       WHERE y.continent = x.continent
      ) <= 25000000;  -- THIS EXCERCISE WAS FUCKING HARD!

SELECT name, continent
FROM world x
WHERE population > ALL(SELECT population*3
                       FROM world y
                       WHERE y.continent = x.continent
                       AND y.name <> x.name); -- DAMN, THIS ONE WAS TRICKY!

/**
  ====SUM and COUNT====
**/

SELECT SUM(population)
FROM world

SELECT DISTINCT continent
FROM world

SELECT SUM(gdp) AS 'Total GDP'
FROM world
WHERE continent = 'Africa'

SELECT COUNT(name)
FROM world
WHERE area >= 1000000

SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

SELECT continent, COUNT(name)
FROM world x
GROUP BY continent

SELECT continent, COUNT(name) AS '>= 10 mil. People'
FROM world
WHERE population >= 10000000
GROUP BY continent


/**8**/
SELECT DISTINCT continent
FROM world x
WHERE (SELECT SUM(population)
       FROM world y
       WHERE y.continent = x.continent) >=
       100000000

-- or

SELECT continent
FROM world x
WHERE (SELECT SUM(population)
       FROM world y
       WHERE y.continent = x.continent) >=
       100000000
GROUP BY continent
