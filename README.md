# 🏏 IPL Cricket Data Analysis — SQL Project

A beginner-level data analyst portfolio project using **Indian Premier League (IPL)** ball-by-ball and match data. This project uses **MySQL** to answer 10 real business questions about team performance, player stats, and match trends across multiple IPL seasons.

---

## 📁 Dataset

- **Source:** [Kaggle — IPL Dataset by nowke9](https://www.kaggle.com/datasets/nowke9/ipldata)
- **Tables Used:**
  - `matches.csv` — Match-level data (teams, venue, toss, winner, season)
  - `deliveries.csv` — Ball-by-ball data (batsman, bowler, runs, wickets)

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| MySQL Workbench | Writing and running SQL queries |
| MySQL 8.0 | Local database engine |
| GitHub | Version control and portfolio sharing |

---

## 🗂️ Project Structure

```
ipl-sql-analysis/
│
├── datasets/
│   ├── matches.csv
│   └── deliveries.csv
│
├── queries/
│   ├── 01_matches_per_season.sql
│   ├── 02_most_wins_by_team.sql
│   ├── 03_top_run_scorers.sql
│   ├── 04_top_wicket_takers.sql
│   ├── 05_toss_impact_on_winning.sql
│   ├── 06_player_of_match_awards.sql
│   ├── 07_highest_team_score.sql
│   ├── 08_batsman_strike_rate.sql
│   ├── 09_season_wise_top_scorer.sql
│   └── 10_head_to_head_record.sql
│
└── README.md
```

---

## ❓ Business Questions Answered

| # | Question | SQL Concepts Used |
|---|----------|-------------------|
| 1 | Total matches played per season | GROUP BY, COUNT |
| 2 | Most successful team by wins | GROUP BY, ORDER BY |
| 3 | Top 10 run scorers of all time | SUM, GROUP BY |
| 4 | Top 10 wicket-taking bowlers | WHERE, COUNT, filter |
| 5 | Does toss decision impact winning? | CASE WHEN, ROUND, percentage |
| 6 | Most Player of the Match awards | COUNT, GROUP BY |
| 7 | Highest team score in a single innings | JOIN, SUM, GROUP BY |
| 8 | Batsman strike rate (min 200 balls) | HAVING, ROUND, formula |
| 9 | Season-wise top run scorer | Window function — RANK() OVER PARTITION BY |
| 10 | Head-to-head record between two teams | WHERE with OR, GROUP BY |

---

## 💡 Key Insights

1. The number of IPL matches has increased steadily season by season.
2. Mumbai Indians is the most successful team with the highest number of wins.
3. Virat Kohli is the all-time leading run scorer in IPL history.
4. Lasith Malinga is the highest wicket-taker excluding run outs.
5. Teams winning the toss and choosing to field win more often than batting first.
6. AB de Villiers has won the most Player of the Match awards in IPL.
7. Royal Challengers Bangalore posted the highest ever team score in a single innings.
8. Andre Russell has the highest strike rate among batsmen with 200+ balls faced.
9. Virat Kohli has been the top run scorer in the most number of seasons.
10. Mumbai Indians dominates the head-to-head record against Chennai Super Kings.

---

## 📌 Sample Query

**Toss Decision Impact on Winning:**

```sql
SELECT
    toss_decision,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS toss_winner_won,
    ROUND(
        100.0 * SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS win_pct
FROM matches
WHERE winner IS NOT NULL
GROUP BY toss_decision;
```

**Result:** Teams that won the toss and chose to **field** had a higher win percentage (~54%) compared to those who chose to **bat first**.

---

## 🚀 How to Run This Project

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/nowke9/ipldata)
2. Open **MySQL Workbench** and create a new schema called `ipl_analysis`
3. Import `matches.csv` and `deliveries.csv` using Table Data Import Wizard
4. Open any `.sql` file from the `queries/` folder and run it

---

## 👤 Author

SHAIPSHI
- LinkedIn: https://www.linkedin.com/in/shaipshi-verya-1b918a162/
- GitHub: https://github.com/shaipshiverya

---

## 📃 License

This project is open source and available under the [MIT License](LICENSE).
