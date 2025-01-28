USE football_project;
SHOW TABLES;

DESCRIBE Capstone_football;

/* Adding appearance_id as primary key */

Alter table Capstone_football add primary key (appearance_id);

/* Adding a composite Key to ensure data uniqueness */
Alter table Capstone_football add primary key (game_id_x, player_id, date);

/* Inserting new Data */

insert into Capstone_football
(appearance_id, game_id_x, player_id, competition_id_x, yellow_cards, red_cards, goals, assists, minutes_played, season, round)
Values 
('0001', 101, 1001, 'C101', 1, 0, 2, 1, 90, 2024, 'Round 1');

/* Update data goals, assist for appearance_id given */

update Capstone_football
set goals = 3, assists = 1 where appearance_id = '0001';

select appearance_id, goals, assists, player_id, competition_id_x from Capstone_football where appearance_id = '0001';

select date from Capstone_football 
where game_id_x = 101 and player_id = 1001;

select * from Capstone_football;
-- 1. Get players with more than 2 goals
select distinct name from Capstone_football where goals > 2;

-- 2. Total goals scored in a specific season:
select season, SUM(goals) as total_goals, count(red_cards) as 'Total Red cards' from Capstone_football
group by season;

-- 3. List players sorted by minutes played in descending order:
SELECT player_id, minutes_played 
FROM Capstone_football 
ORDER BY minutes_played DESC;

-- 4. Get the top 5 players with the highest goals:
SELECT player_id, SUM(goals) AS total_goals 
FROM Capstone_football 
GROUP BY player_id 
ORDER BY total_goals DESC 
LIMIT 5;


-- 5. Find the average minutes played by players:
SELECT AVG(minutes_played) AS avg_minutes 
FROM Capstone_football;


-- 6. Get the average attendance per stadium:
SELECT stadium, AVG(attendance) AS avg_attendance 
FROM Capstone_football 
GROUP BY stadium;

-- 7. Team Performance:
SELECT home_club_name, away_club_name, home_club_goals, away_club_goals 
FROM Capstone_football 
WHERE season = 2024;

-- 8. Player Market Value Trends:
SELECT player_id, market_value_in_eur, highest_market_value_in_eur 
FROM Capstone_football 
WHERE market_value_in_eur > 5000000;

-- 9. Compare performances of home and away teams:
SELECT home_club_name, away_club_name, SUM(home_club_goals) AS home_goals, SUM(away_club_goals) AS away_goals 
FROM Capstone_football 
GROUP BY home_club_name, away_club_name;

select * from players limit 10;

-- 10. Players who scored more than the average goals across all matches
SELECT p.name AS player_name, SUM(cf.goals) AS total_goals
FROM Capstone_football cf
INNER JOIN players p ON cf.player_id = p.player_id
GROUP BY p.name
HAVING SUM(cf.goals) > (SELECT AVG(goals) FROM Capstone_football);

-- 11. Get players who scored in matches where attendance was above the average
SELECT DISTINCT p.player_id, p.name AS player_name, cf.appearance_id, cf.attendance
FROM Capstone_football cf
INNER JOIN players p ON cf.player_id = p.player_id
WHERE cf.attendance > (SELECT AVG(attendance) FROM Capstone_football)
ORDER BY cf.attendance DESC;


