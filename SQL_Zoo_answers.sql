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

/**
  ====The JOIN operation====
**/

SELECT matchid, player FROM goal
  WHERE teamid = 'GER'

SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012

SELECT team1, team2, player
FROM game JOIN goal
ON id = matchid
WHERE player LIKE 'Mario%'

SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam
  ON teamid = id
  WHERE gtime<=10

SELECT mdate, teamname
FROM game JOIN eteam
ON game.team1 = eteam.id
WHERE coach = 'Fernando Santos'

SELECT player
FROM goal JOIN game
ON goal.matchid = game.id
WHERE stadium = 'National Stadium, Warsaw'

SELECT DISTINCT player
  FROM game JOIN goal ON id = matchid
    WHERE team1 = 'GER' AND goal.teamid <> 'GER'
    OR game.team2 = 'GER' AND goal.teamid <> 'GER'

SELECT teamname, COUNT(player)
  FROM eteam JOIN goal ON id=teamid
 GROUP BY teamname

SELECT stadium, COUNT(player)
FROM game JOIN goal
ON id = matchid
GROUP BY stadium

SELECT matchid, mdate, COUNT(player)
FROM goal JOIN game ON matchid = id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid, mdate -- THIS ONE WAS FUCKING HARD!

SELECT matchid, mdate, COUNT(player)
FROM game JOIN goal
ON id = matchid
WHERE teamid = 'GER'
GROUP BY matchid, mdate

SELECT mdate, team1,
       SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
FROM game x LEFT JOIN goal ON x.id = matchid
WHERE x.id = matchid OR x.id
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2 -- I had to use LEFT JOIN for this, which I didn't expect to need at this point

/**
  ====More JOIN operations====
**/

SELECT id, title
FROM movie
WHERE yr = 1962

SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

SELECT id
FROM actor
WHERE name = 'Glenn Close';

SELECT id
FROM movie
WHERE title = 'Casablanca' ;

SELECT name
FROM actor
INNER JOIN casting
ON id = actorid
WHERE movieid = 11768;

SELECT name
FROM actor
INNER JOIN casting
ON actor.id = actorid
INNER JOIN movie
ON movieid = movie.id
WHERE title = 'Alien';

SELECT title
FROM movie
INNER JOIN casting
ON movie.id = movieid
INNER JOIN actor
ON actorid = actor.id
WHERE name = 'Harrison Ford';

SELECT title
FROM movie
INNER JOIN casting
ON movie.id = movieid
INNER JOIN actor
ON actorid = actor.id
WHERE name = 'Harrison Ford' AND ord != 1;

SELECT title, name
FROM movie
INNER JOIN casting
ON movie.id = movieid
INNER JOIN actor
ON actorid = actor.id
WHERE yr = 1962 AND ord = 1;

SELECT yr, COUNT(title) AS 'Movies Made'
FROM movie
INNER JOIN casting
 ON movie.id = casting.movieid
INNER JOIN actor
 ON casting.actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

FROM movie
INNER JOIN casting
 ON movie.id = casting.movieid
INNER JOIN actor
 ON casting.actorid = actor.id
WHERE ord = 1 AND movieid IN (
                            SELECT movieid FROM casting
                            WHERE actorid IN (
                            SELECT id FROM actor
                            WHERE name='Julie Andrews')
                            );

SELECT name
FROM actor
INNER JOIN casting ON actor.id = actorid
INNER JOIN movie ON movieid = movie.id
WHERE ord = 1
GROUP BY name
HAVING COUNT(actorid) >= 15

SELECT title, COUNT(actorid) AS 'No. Actors'
FROM movie
INNER JOIN casting ON movie.id = movieid
WHERE yr = 1978
GROUP BY title, 'No. Actors'
ORDER BY COUNT(actorid) DESC, title;

SELECT name
FROM actor
INNER JOIN casting ON actor.id = actorid
WHERE movieid IN (SELECT movieid FROM casting
                  INNER JOIN actor ON actorid = actor.id
                  WHERE name = 'Art Garfunkel')
AND name != 'Art Garfunkel';

/**
  ====Using Null====
**/

SELECT name
FROM teacher
WHERE dept IS NULL;

SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id);

SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)

SELECT teacher.name, dept.name
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id);

SELECT name, COALESCE(mobile, '07986 444 2266') AS 'mobile number'
FROM teacher;

SELECT teacher.name AS 'Teacher Name', COALESCE(dept.name, 'None') AS 'Dept Name'
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id;

SELECT COUNT(name), COUNT(mobile)
FROM teacher

SELECT dept.name AS 'Dept', COUNT(teacher.dept) AS 'Number of Staff'
FROM teacher
RIGHT JOIN dept ON teacher.dept = dept.id
GROUP BY dept.name;

SELECT teacher.name AS 'Teacher name',
       CASE WHEN dept = 1 OR dept = 2 THEN 'Sci'
       ELSE 'Art' END AS 'Title'
FROM teacher LEFT JOIN dept
ON teacher.dept = dept.id;

SELECT teacher.name AS Teacher,
       CASE WHEN dept = 1 OR dept = 2 THEN 'Sci'
            WHEN dept = 3 THEN 'Art'
            ELSE 'None' END AS 'Title'
FROM teacher LEFT JOIN dept
ON teacher.dept = dept.id;

/**
  ====Self join====
**/

SELECT COUNT(id)
FROM stops

SELECT id
FROM stops
WHERE name = 'Craiglockhart';

SELECT id, name
FROM stops
INNER JOIN route
ON id = stop
WHERE company = 'LRT' AND num = '4';

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2;

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

SELECT DISTINCT a.company, a.num
FROM route a INNER JOIN route b ON
    (a.company = b.company AND a.num = b.num)
    INNER JOIN stops stopa ON a.stop = stopa.id
    INNER JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Haymarket' AND stopb.name = 'Leith';

SELECT DISTINCT a.company, a.num
FROM route a INNER JOIN route b ON
    (a.company = b.company AND a.num = b.num)
    INNER JOIN stops stopa ON a.stop = stopa.id
    INNER JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross';

SELECT DISTINCT stopb.name,
       a.company, a.num
FROM route a INNER JOIN route b ON
    (a.company = b.company AND a.num = b.num)
    INNER JOIN stops stopa ON a.stop = stopa.id
    INNER JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart' AND a.company = 'LRT';

SELECT b.num AS '1st Bus', b.company AS 'Service',
    stopd.name AS 'Transfer Stop', d.num AS '2nd Bus', d.company AS 'Service'
  FROM route a INNER JOIN route b ON
  (a.num = b.num AND a.company = b.company)
    INNER JOIN stops stopa ON (a.stop = stopa.id)
    INNER JOIN stops stopb ON (b.stop = stopb.id)

  INNER JOIN route d ON (d.stop = stopb.id)

  INNER JOIN route c ON
  (c.num = d.num AND c.company = d.company)
    INNER JOIN stops stopc ON (c.stop = stopc.id)
    INNER JOIN stops stopd ON (d.stop = stopd.id)
WHERE stopa.name = 'Craiglockhart' AND stopc.name = 'Lochend'
ORDER BY b.num, b.company, stopd.name, d.num, d.company;   -- THIS WAS A TOUGH NUT TO BREAK!

-- or variation 2

  SELECT R2.num AS '1st Bus', R2.company AS 'Service',
         S4.name AS 'Transfer Stop', R4.num AS '2nd Bus',
         R4.company AS 'Service'
    FROM route R1, route R2, route R3, route R4,
         stops S1, stops S2, stops S3, stops S4
   WHERE S1.name = 'Craiglockhart' AND S1.id = R1.stop
         AND S2.id = R2.stop AND R1.num = R2.num
         AND R1.company = R2.company AND R3.stop = S3.id
         AND R4.stop = S4.id AND R3.num = R4.num
         AND R3.company = R4.company AND S3.name = 'Lochend'
         AND S2.id = S4.id
ORDER BY R2.num, R2.company, S4.name, R4.num, R4.company
