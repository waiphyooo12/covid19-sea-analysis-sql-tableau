🦠 COVID-19 Global Data Analysis (PostgreSQL)
📌 Summary

This project analyzes global COVID-19 cases, deaths, and vaccination trends using PostgreSQL.
It demonstrates my ability to clean raw data, write analytical SQL, and produce metrics ready for dashboards and decision-making — skills essential for Data Analyst / Analytics Engineer roles.

🎯 Business Questions Answered

How severe was COVID-19 across different countries and continents?

What percentage of a population was infected or died from COVID-19?

How did global death rates change over time?

How quickly did vaccination coverage grow per country?

🛠 Tech Stack

Database: PostgreSQL

Query Tool: pgAdmin

Language: SQL

Version Control: Git & GitHub

Editor: VS Code

📊 Dataset

Public COVID-19 datasets containing:

Daily cases & deaths

Population & life expectancy

Vaccination counts

Country & continent metadata

🔍 Key Analyses & SQL Skills
1️⃣ Data Cleaning & Preparation

Converted string dates to DATE type

Aligned schemas across datasets for accurate joins

Filtered out aggregated rows (World, income groups)

ALTER TABLE covid_deaths
ALTER COLUMN date TYPE DATE
USING TO_DATE(date, 'DD/MM/YYYY');


Skills: data cleaning, schema alignment, type casting

2️⃣ Infection & Death Rate Analysis

Calculated infection and fatality rates by country:

(total_deaths / total_cases) * 100 AS death_rate_percentage


Insights:

Compared COVID severity between countries (e.g., Thailand vs Myanmar)

Highlighted the importance of numeric casting to avoid integer division

Skills: aggregations, ratios, analytical thinking

3️⃣ Global Trend Analysis

Measured daily global cases, deaths, and death rates:

SUM(new_deaths) / SUM(new_cases) * 100 AS global_death_rate


Skills: grouping, filtering, time-series aggregation

4️⃣ Advanced Analytics with Window Functions

Calculated rolling (running) vaccination totals per country:

SUM(new_vaccinations::int)
OVER (PARTITION BY location ORDER BY date)


Why it matters:
Rolling metrics are critical for growth, adoption, and trend analysis.

Skills: window functions, partitioning, ordering

5️⃣ CTE for Vaccination Coverage

Used a CTE to calculate the percentage of population vaccinated over time:

(rolling_sum_vaccinations / population::numeric) * 100


Skills: CTEs, numeric precision, reusable logic

6️⃣ Production-Ready SQL Objects

Created:

Temporary tables for intermediate analysis

SQL Views for visualization tools (Tableau / Power BI)

CREATE VIEW per_people_cavv AS ...


Skills: analytics engineering mindset, BI-ready data modeling

📈 Key SQL Concepts Demonstrated

✔ JOINs
✔ GROUP BY & aggregations
✔ Window functions
✔ CTEs
✔ Temporary tables
✔ Views
✔ Data type optimization
✔ Real-world analytical logic

🚀 Why This Project Stands Out

Uses real, messy data

Applies production-style SQL patterns

Focuses on metrics used by decision-makers

Directly transferable to analytics & engineering roles

👩‍💻 Target Roles

Data Analyst

Analytics Engineer

Junior Data Engineer

🔮 Next Steps

Add indexes for performance optimization

Build a dashboard using Tableau or Power BI

Refactor queries into dbt-style models

Automate data validation checks

📬 Contact

If you’d like to discuss this project or my analytical approach, feel free to reach out via GitHub.
