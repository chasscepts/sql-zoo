-------------------------- SELECT FROM WORLD ----------------------------

-- select population of germany
SELECT population FROM world
  WHERE name = 'Germany';

-- Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- country and the area for countries with an area between 200,000 and 250,000
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000;

-- Show the name for the countries that have a population of at least 200 million
SELECT name
  FROM world
  WHERE NOT population < 200000000;

-- Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name, gdp/population
  FROM world
  WHERE NOT population < 200000000;

-- Show the name and population in millions for the countries of the continent 'South America'.
SELECT name, population / 1000000
  FROM world
  WHERE continent = 'South America';

-- Show the name and population for France, Germany, Italy
SELECT name, population
  FROM world
  WHERE name IN ('France', 'Germany', 'Italy');

-- Show the countries which have a name that includes the word 'United'
SELECT name
  FROM world
  WHERE name LIKE '%United%';

-- Show the countries that are big by area or big by population. Show name, population and area.
SELECT name, population, area
  FROM world
  WHERE area > 3000000
  OR population > 250000000;

-- Exclusive OR (XOR). Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both.
SELECT name, population, area
  FROM world
  WHERE area > 3000000 AND NOT population > 250000000
  OR population > 250000000 AND NOT area > 3000000;

  -- For South America show population in millions and GDP in billions both to 2 decimal places.
SELECT name, ROUND(population / 1000000, 2), ROUND(gdp / 1000000000, 2)
  FROM world
  WHERE continent = 'South America';

-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND(gdp/population, -3)
  FROM world
  WHERE NOT gdp < 1000000000000;

-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name, capital
  FROM world
  WHERE LENGTH(name) = LENGTH(capital);

-- Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name, capital
  FROM world
  WHERE LEFT(name, 1) = LEFT(capital, 1)
  AND NOT name = capital;

-- Find the country that has all the vowels and no spaces in its name.
SELECT name
  FROM world
  WHERE name LIKE '%a%'
  AND name LIKE '%e%'
  AND name LIKE '%i%'
  AND name LIKE '%o%'
  AND name LIKE '%u%'
  AND NOT name LIKE '% %';

-------------------------- END SELECT FROM WORLD -----------------------------

-------------------------- SELECT FROM NOBEL ----------------------------

-- displays Nobel prizes for 1950
SELECT yr, subject, winner
  FROM nobel
  WHERE yr = 1950;

-- Show who won the 1962 prize for Literature.
SELECT winner
  FROM nobel
  WHERE yr = 1962
  AND subject = 'Literature';

-- Show the year and subject that won 'Albert Einstein' his prize.
SELECT yr, subject
  FROM nobel
  WHERE winner = 'Albert Einstein';

-- Give the name of the 'Peace' winners since the year 2000, including 2000.
SELECT winner
  FROM nobel
  WHERE subject = 'Peace'
  AND NOT yr < 2000;

-- Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT yr, subject, winner
  FROM nobel
  WHERE subject = 'Literature'
  AND yr BETWEEN 1980 AND 1989;

-- Show all details of the presidential winners
SELECT * FROM nobel
  WHERE winner IN (
    'Theodore Roosevelt',
    'Woodrow Wilson',
    'Jimmy Carter',
    'Barack Obama'
  );

-- Show the winners with first name John
SELECT winner
  FROM nobelA
  WHERE winner LIKE 'John%';

-- Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984
SELECT yr, subject, winner
  FROM nobel
  WHERE subject = 'Physics' AND yr = 1980
  OR subject = 'Chemistry' AND yr = 1984;

-- Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine
SELECT yr, subject, winner
  FROM nobel
  WHERE yr = 1980
  AND NOT subject IN ('Chemistry', 'Medicine');

-- Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004)
SELECT yr, subject, winner
  FROM nobel
  WHERE subject = 'Medicine' AND yr < 1910
  OR subject = 'Literature' AND NOT yr < 2004;

-- Find all details of the prize won by PETER GRÜNBERG
SELECT *
  FROM nobel
  WHERE winner = 'PETER GRÜNBERG';

-- Find all details of the prize won by EUGENE O'NEILL
SELECT *
  FROM nobel
  WHERE winner = 'EUGENE O''NEILL';

-- List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.
SELECT winner, yr, subject
  FROM nobel
  WHERE winner LIKE 'Sir%'
  ORDER BY yr DESC, winner;

-- Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject
  FROM nobel
  WHERE yr=1984
  ORDER BY subject IN ('Chemistry', 'Physics'), subject, winner;

----------------------- END SELECT FROM NOBEL -----------------------

----------------------- SELECT WITHIN SELECT ------------------------
-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia');

-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
  FROM world
  WHERE continent = 'Europe'
  AND gdp / population >
    (SELECT gdp / population
      FROM world
      WHERE name = 'United Kingdom');

-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent
  FROM world
  WHERE continent IN
    (SELECT continent
      FROM world
      WHERE name = 'Argentina'
      OR name = 'Australia')
  ORDER BY name;

--Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population
  FROM world
  WHERE population >
    (SELECT population
      FROM world
      WHERE name = 'Canada')
  AND population <
    (SELECT population
      FROM world
      WHERE name = 'Poland');

-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name, CONCAT((ROUND(population/
  (
    SELECT population
    FROM world
    WHERE name = 'Germany'
  ) * 100, 0)), '%') as percentage
  FROM world
  WHERE continent = 'Europe';

-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
  FROM world
  WHERE gdp > ALL (SELECT gdp
                 FROM world
                 WHERE continent = 'Europe'
                 AND gdp IS NOT NULL);

-- Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area
  FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent);

-- List each continent and the name of the country that comes first alphabetically.
SELECT continent, min(name) as name
  FROM world
  GROUP BY continent;

-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population
  FROM world
  WHERE continent IN (SELECT continent FROM world GROUP BY continent HAVING MAX(population) <= 25000000);

-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent
  FROM world w1
  WHERE population / 3 > ALL (SELECT population FROM world w2 WHERE w1.continent = w2.continent AND NOT w1.name = w2.name);

----------------------- END SELECT WITHIN SELECT ------------------------

------------------------------ SUM AND COUNT ----------------------------
-- Show the total population of the world.
SELECT SUM(population)
  FROM world;

-- List all the continents - just once each.
SELECT DISTINCT continent
  FROM world;

-- Give the total GDP of Africa
SELECT SUM(gdp)
  FROM world
  WHERE continent = 'Africa';

-- How many countries have an area of at least 1000000
SELECT COUNT(area)
  FROM world
  WHERE area >= 1000000;

-- What is the total population of ('Estonia', 'Latvia', 'Lithuania')
SELECT SUM(population)
  FROM world
  WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

-- For each continent show the continent and number of countries.
SELECT continent, COUNT(continent)
  FROM world
  GROUP BY continent;

-- For each continent show the continent and number of countries with populations of at least 10 million.
SELECT DISTINCT continent, COUNT(population)
  FROM world
  WHERE population >= 10000000
  GROUP BY continent;

-- List the continents that have a total population of at least 100 million.
SELECT continent
  FROM (SELECT continent, SUM(population) as sum FROM world GROUP BY continent) w
  WHERE sum > 100000000;

--------------------------- END SUM AND COUNT --------------------------

--------------------------- JOIN -------------------------------

-- Show the matchid and player name for all goals scored by Germany.
SELECT matchid, player FROM goal
  WHERE teamid = 'GER';

-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
  WHERE id = 1012;

-- show the player, teamid, stadium and mdate for every German goal.
SELECT goal.player, goal.teamid, game.stadium, game.mdate
  FROM goal JOIN game ON goal.matchid = game.id
  WHERE goal.teamid = 'GER';

-- Show the team1, team2 and player for every goal scored by a player called Mario
SELECT game.team1, game.team2, goal.player
  FROM goal JOIN game ON goal.matchid = game.id
  WHERE goal.player LIKE 'Mario%';

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
  FROM goal JOIN eteam on goal.teamid = eteam.id
  WHERE gtime<=10;

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
  FROM eteam JOIN game ON team1=eteam.id
  WHERE coach = 'Fernando Santos';

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
  FROM goal JOIN game ON matchid = id
  WHERE stadium = 'National Stadium, Warsaw';

-- show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id
  WHERE (team1='GER' OR team2='GER') AND NOT teamid = 'GER';

-- Show teamname and the total number of goals scored.
SELECT MAX(teamname) AS teamname, COUNT(teamid)
  FROM goal JOIN eteam ON teamid = id
  GROUP BY teamid
  ORDER BY teamname;

-- Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(player)
  FROM goal JOIN game ON matchid = id
  GROUP BY stadium;

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, MAX(mdate), COUNT(player)
  FROM game JOIN goal ON id = matchid
  WHERE team1 = 'POL' OR team2 = 'POL'
  GROUP BY matchid;

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(player)
  FROM goal JOIN game ON matchid = id
  WHERE teamid = 'GER'
  GROUP BY matchid, mdate;

-- List every match with the goals scored by each team
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
  FROM game JOIN goal ON matchid = id
  GROUP BY team1, team2, mdate
  ORDER BY mdate, matchid, team1, team2;

---------------------------- END JOIN -----------------------------

---------------------------- MORE JOIN ----------------------------

-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
  FROM movie
  WHERE yr=1962;

-- Give year of 'Citizen Kane'.
SELECT yr
  FROM movie
  WHERE title = 'Citizen Kane';

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
  FROM movie
  WHERE title LIKE '%Star Trek%'
  ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?
SELECT id
  FROM actor
  WHERE name = 'Glenn Close';

-- What is the id of the film 'Casablanca'
SELECT id
  FROM movie
  WHERE title = 'Casablanca';

-- Obtain the cast list for 'Casablanca'.
SELECT name
  FROM actor
    JOIN casting ON actor.id = casting.actorid
    JOIN movie on movie.id = casting.movieid
  WHERE movie.title = 'Casablanca';

-- Obtain the cast list for the film 'Alien'
SELECT name
  FROM actor
    JOIN casting ON actor.id = casting.actorid
    JOIN movie on movie.id = casting.movieid
  WHERE movie.title = 'Alien';

-- List the films in which 'Harrison Ford' has appeared
SELECT title
  FROM movie
    JOIN casting ON movie.id = casting.movieid
    JOIN actor ON actor.id = casting.actorid
  WHERE actor.name = 'Harrison Ford';

-- List the films where 'Harrison Ford' has appeared - but not in the starring role.
SELECT title
  FROM movie
    JOIN casting ON movie.id = casting.movieid
    JOIN actor ON actor.id = casting.actorid
  WHERE actor.name = 'Harrison Ford'
  AND NOT casting.ord = 1

-- List the films together with the leading star for all 1962 films.
SELECT movie.title AS title, actor.name as name
  FROM movie
    JOIN casting ON casting.movieid = movie.id
    JOIN actor ON casting.actorid = actor.id
  WHERE movie.yr = 1962
  AND casting.ord = 1;

-- Show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
  FROM movie
    JOIN casting ON movie.id=movieid
    JOIN actor   ON actorid=actor.id
  WHERE name='Rock Hudson'
  GROUP BY yr
  HAVING COUNT(title) > 2;

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT movie.title, actor.name
  FROM movie
    JOIN casting ON casting.movieid = movie.id
    JOIN actor ON casting.actorid = actor.id
  WHERE casting.movieid IN (
    SELECT casting.movieid
      FROM casting
        JOIN actor ON actor.id = casting.actorid
      WHERE actor.name = 'Julie Andrews'
  )
  AND casting.ord = 1;

-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name
  FROM (SELECT COUNT(movieid) AS movies, actorid
          FROM casting
          WHERE ord = 1
          GROUP BY actorid
  ) castgroups
  JOIN actor ON actorid = actor.id
  WHERE movies >= 15
  ORDER BY name;

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, actors
  FROM (SELECT movieid, COUNT(actorid) AS actors
          FROM casting
          GROUP BY movieid
       ) movie_group
  JOIN movie ON movie.id = movieid
  WHERE yr = 1978
  ORDER BY actors DESC, title;

-- List all the people who have worked with 'Art Garfunkel'.
SELECT name
  FROM movie
  JOIN casting ON movie.id = movieid
  JOIN actor ON actor.id = actorid
  WHERE movie.id IN (
    SELECT movieid
    FROM movie
      JOIN casting ON movie.id = movieid
      JOIN actor ON actor.id = actorid
    WHERE name = 'Art Garfunkel'
  )
  AND NOT name = 'Art Garfunkel';

---------------------------END MORE JOIN --------------------------
