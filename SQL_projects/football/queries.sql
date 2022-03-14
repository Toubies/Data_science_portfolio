--- Change the weight from pounds to kgs
UPDATE Player
SET weight = round((weight/2.2046),2);

-- Count BMI of each Player
SELECT *,round(weight/((height*1/100)*(height*1/100)),2) as 'BMI' FROM Player;

-- Adding BMI to TABLE
ALTER TABLE Player
ADD COLUMN BMI REAL;

-- Adding Values
UPDATE Player
SET BMI = round(weight/((height*1/100)*(height*1/100)),2);

-- Check overall_rating of Players by DESC without null and overall > 90
SELECT * FROM Player;

SELECT DISTINCT player_name,date, Player_Attributes.overall_rating FROM Player
INNER JOIN Player_Attributes ON Player.player_api_id = Player_Attributes.player_api_id
WHERE Player_Attributes.overall_rating > 90
ORDER BY 3 DESC;

-- Show last attributes of Cristiano Ronaldo (30893)
SELECT * FROM Player_Attributes
WHERE player_api_id = 30893
ORDER BY 4 DESC
LIMIT 1;

-- Select the best left foot Player (Messi not included) for years 2014-2015
SELECT DISTINCT player_name,date, Player_Attributes.overall_rating,Player_Attributes.preferred_foot FROM Player
INNER JOIN Player_Attributes ON Player.player_api_id = Player_Attributes.player_api_id
WHERE Player_Attributes.preferred_foot = 'left' AND player_name != 'Lionel Messi' AND date BETWEEN 2014 and 2016
ORDER BY 3 DESC
LIMIT 1;

-- Which players have the biggest sum of goalkepper skills 
SELECT DISTINCT player_name,(gk_handling + gk_diving + gk_kicking + gk_positioning + gk_reflexes) as 'total_points' FROM Player_Attributes
INNER JOIN Player ON Player_Attributes.player_api_id = Player.player_api_id
ORDER BY 2 DESC;

-- Show matches for Poland Ekstraklasa (id 15722)
SELECT * FROM League;

SELECT season,stage,date,home_team_goal,away_team_goal, Home.team_long_name as 'Home_Team', Away.team_long_name as 'Away_Team' FROM Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722
ORDER BY 3;

-- Check if there are more goals in home or away globally 
SELECT sum(home_team_goal) as 'home_goals',sum(away_team_goal) as 'away_goals' FROM Match;

-- For Poland Ekstraklasa
SELECT sum(home_team_goal) as 'home_goals',sum(away_team_goal) as 'away_goals' FROM Match
LEFT JOIN League ON Match.league_id = League.id
WHERE league_id = 15722;

-- List all polish teams in database
SELECT DISTINCT team_long_name FROM Team
LEFT JOIN Match ON Team.team_api_id = Match.away_team_api_id
LEFT JOIN League ON Match.league_id = League.id
WHERE league_id = 15722
ORDER BY 1;

-- Matches with the highest number of total goals in match for Poland Ekstraklasa
SELECT season,stage,date,home_team_goal,away_team_goal,(home_team_goal+away_team_goal) as 'total_goals', 
Home.team_long_name as 'Home_Team', Away.team_long_name as 'Away_Team', l.name FROM Match
LEFT JOIN League as l ON l.id = Match.league_id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722
ORDER BY 6 DESC
LIMIT 5;

-- Show matches with the biggest differance of goals for Poland Ekstraklasa
SELECT season,stage,date,home_team_goal,away_team_goal,abs(home_team_goal-away_team_goal) as 'goal_differance',
Home.team_long_name as 'Home_Team', Away.team_long_name as 'Away_Team' FROM Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722
ORDER BY 6 DESC
LIMIT 5;

-- Goals table for each season for Poland Ekstraklasa
CREATE VIEW Goals AS
SELECT season,SUM(goals) as 'total_goals',Home_Team as 'Team_Name' FROM
(SELECT season,SUM(home_team_goal) as 'goals', Home.team_long_name as 'Home_Team'
From Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
WHERE league_id = 15722
GROUP BY team_long_name,season

UNION ALL

SELECT season,SUM(away_team_goal) as 'goals', Away.team_long_name as 'Away_Team' From Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722
GROUP BY team_long_name,season)
GROUP BY season,Team_Name
ORDER BY 1,2 DESC;

-- League table with score
CREATE VIEW League_score AS
SELECT season,team_name,SUM(score) as total_score,SUM(W) as W,SUM(D) as D,SUM(L) as L FROM
(SELECT season,stage,home_team as team_name,SUM(home_score) as score,W,D,L FROM
(SELECT season,stage,
Home.team_long_name as home_team, SUM(CASE
WHEN home_team_goal > away_team_goal THEN 3
WHEN home_team_goal = away_team_goal THEN 1 
ELSE 0 END) as home_score, 
SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE NULL END) as W,  
SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE NULL END) as D,
SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE NULL END) as L
FROM Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722
GROUP BY season,stage,home_team

UNION ALL

SELECT season,stage,Away.team_long_name as away_team, SUM(CASE
WHEN home_team_goal < away_team_goal THEN 3
WHEN home_team_goal = away_team_goal THEN 1 
ELSE 0 END) as away_score,
SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE NULL END) as W,  
SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE NULL END) as D,
SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE NULL END) as L
FROM Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722
GROUP BY season,stage,away_team)
GROUP BY season,team_name,stage)
GROUP BY season,team_name
ORDER BY 1,3 DESC;

SELECT * FROM Goals;

SELECT * FROM League_score;

-- Checking wrong results and comparing it with tables on the internet
SELECT season,stage,date,home_team_goal,away_team_goal, Home.team_long_name as 'Home_Team', Away.team_long_name as 'Away_Team' FROM Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722 AND (Home_Team = 'Polonia Bytom' Or Away_Team = 'Polonia Bytom') AND season = '2008/2009'
ORDER BY 3;

SELECT season,stage,date,home_team_goal,away_team_goal, Home.team_long_name as 'Home_Team', Away.team_long_name as 'Away_Team' FROM Match
LEFT JOIN League ON Match.league_id = League.id
LEFT JOIN Team AS Home on Home.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS Away on Away.team_api_id = Match.away_team_api_id
WHERE league_id = 15722 AND (Home_Team = 'Polonia Bytom' Or Away_Team = 'Polonia Bytom') AND season = '2010/2011'
ORDER BY 3;

SELECT DISTINCT team_long_name FROM Team
LEFT JOIN Match ON Team.team_api_id = Match.away_team_api_id
LEFT JOIN League ON Match.league_id = League.id
WHERE league_id = 15722 AND season = '2010/2011'
ORDER BY 1;

-- There are some wrong records in the data. Polonia Bytom was mixed with Górnik Zabrze records. It makes wrong score and goals results.

-- League Score with goals
SELECT g.season,t.team_api_id,ls.team_name,ls.total_score,ls.W,ls.D,ls.L,total_goals, round((total_goals/30.0),2) as avg_goals_by_match FROM Goals as g
INNER JOIN League_score AS ls ON  g.Team_Name = ls.team_name AND g.season = ls.season
INNER JOIN Team AS t ON g.Team_Name = t.team_long_name
GROUP BY g.season,ls.team_name
ORDER BY 1,4 DESC;