/*
=============================================================================================
IPL Data Analysis Project
Author: Shaipshi
Description: This project involves an end-to-end exploratory data analysis
			(EDA) of Indian Premier League (IPL) match data using SQL.
			The primary goal is to extract actionable insights from historical match 
			statistics to understand game trends, team performance, and the impact 
			of match-day decisions.
Database: PostgreSQL / MySQL Compatible
==============================================================================================
*/

CREATE DATABASE IPL_ANALYSIS;
USE IPL_ANALYSIS;
SHOW TABLES;
SELECT* FROM deliveries;
SELECT* FROM matches;

-- ============================================================================
--  EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================================================

-- Q1: Overview of the IPL dataset
-- GOAL: Total matches played per season
SELECT
    season,
    COUNT(*) AS total_matches
FROM matches
GROUP BY season
ORDER BY season DESC;

-- Q2: Which team has won the most IPL matches overall?
-- GOAL: Most successful team (by wins)
SELECT
    winner,
    COUNT(*) AS total_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 10;

-- Q3: Top 10 run scorers of all time
-- GOAL: Aggregate total runs per batsman across all seasons
SELECT
	batsman,
    SUM(batsman_runs) AS total_runs
FROM deliveries  
GROUP BY batsman
ORDER BY total_runs DESC
LIMIT 10;


-- Q4: Top wicket-taking bowlers
-- Goal: Rank bowlers by total wickets, excluding run-outs
SELECT
    bowler,
    COUNT(*) AS total_wickets
FROM deliveries
WHERE dismissal_kind != ''
 AND dismissal_kind != 'run out'
GROUP BY bowler
ORDER BY total_wickets DESC
LIMIT 10;


-- Q5: Does choosing to bat or field after winning the toss affect match outcome?
-- Goal:Toss decision impact on winning
SELECT 
	toss_decision,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS toss_winner_won,
    ROUND(100.0 * SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) / COUNT(*), 2) 
    AS win_percentage
FROM matches
WHERE winner IS NOT NULL
GROUP BY toss_decision;

-- Q6 Find the most impactful players across all IPL seasons
-- Goal:Most Player of the Match awards
SELECT
	player_of_match,
    COUNT(*) AS awards
FROM matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;

-- Q7: Highest team score in a single innings
-- Goal:JOIN matches + deliveries to find the highest ever team total
SELECT
    d.match_id,
	d.inning,
    d.batting_team,
    d.bowling_team,
    m.toss_winner,
    m.season,
    m.venue,
    SUM(d.total_runs) AS innings_total
FROM deliveries d
JOIN matches m ON d.match_id = m.id
GROUP BY d.match_id, d.batting_team, d.inning,d.bowling_team, m.season, m.venue, m.toss_winner
ORDER BY innings_total DESC
LIMIT 5;

-- Q8: Who scored the most runs in each IPL season
-- Goal: Season-wise top run scorer
SELECT
    season,batsman,total_runs
FROM (
    SELECT
        m.season,
        d.batsman,
        SUM(d.batsman_runs) AS total_runs,
        RANK() OVER (
            PARTITION BY m.season
            ORDER BY SUM(d.batsman_runs) DESC
        ) AS rnk
    FROM deliveries d
    JOIN matches m ON d.match_id = m.id
    GROUP BY m.season, d.batsman
) ranked
WHERE rnk = 1
ORDER BY season DESC;

-- Q9: Calculate how fast each batsman scores 
-- Goal: Batsman strike rate (min 200 balls)
SELECT
    batsman,
    SUM(batsman_runs) AS total_runs,
    COUNT(*) AS balls_faced,
    ROUND(SUM(batsman_runs) * 100.0 / COUNT(*), 2) AS strike_rate
FROM deliveries
GROUP BY batsman
HAVING balls_faced >= 200
ORDER BY strike_rate DESC
LIMIT 10;


-- Q10: How many times has CSK beaten MI?
-- Goal:Team head-to-head record
SELECT
    winner,
    COUNT(*) AS wins
FROM matches
WHERE
    (team1 = 'Chennai Super Kings' AND team2 = 'Mumbai Indians')
    OR
    (team1 = 'Mumbai Indians' AND team2 = 'Chennai Super Kings')
GROUP BY winner
ORDER BY wins DESC;


/*
===============================================================================
END OF PROJECT
1. The number of IPL matches has increased steadily season by season.
2. Mumbai Indians is the most successful team with the highest number of wins.
3. SK Raina is the all-time leading run scorer in IPL history.
4. Lasith Malinga is the highest wicket-taker excluding run outs.
5. Teams winning the toss and choosing to field win more often than batting first.
6. CH Gayle has won the most Player of the Match awards in IPL.
7. Chennai Super Kings posted the highest ever team score in a single innings.
8. DA Warner has the highest strike rate among batsmen with 200+ balls faced.
9. RR Pant has been the top run scorer in the most number of seasons.
10. Mumbai Indians dominates the head-to-head record against Chennai Super Kings.

===============================================================================
*/