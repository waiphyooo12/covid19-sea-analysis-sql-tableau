Select *
from coviddeaths;
-- Southeast Asia countries

WHERE location IN (
'Thailand','Vietnam','Malaysia','Indonesia','Philippines',
'Singapore','Myanmar','Cambodia','Laos','Brunei'
)

select 
    location,
    date,
    population,
    total_cases,
    (total_cases/population)*100 as infection_percentage
from coviddeaths
where location IN (
'Thailand','Vietnam','Malaysia','Indonesia','Philippines',
'Singapore','Myanmar','Cambodia','Laos','Brunei'
)
order by location, date;

select 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 as death_rate
from coviddeaths
where location IN (
'Thailand','Vietnam','Malaysia','Indonesia','Philippines'
)
order by location, date;

select 
    location,
    max(total_cases) as highest_cases,
    max(total_deaths) as highest_deaths,
    max((total_cases/population))*100 as infection_rate
from coviddeaths
where location IN (
'Thailand','Vietnam','Malaysia','Indonesia','Philippines',
'Singapore','Myanmar','Cambodia','Laos','Brunei'
)
group by location, population
order by infection_rate desc;

select *
from covidvaccinations;

select location , date , population
from coviddeaths
where location in (
'Thailand','Vietnam','Malaysia','Indonesia','Philippines',
'Singapore','Myanmar','Cambodia','Laos','Brunei')
order by location , date;


SELECT
    deth.location,
    deth.date,
    deth.population,

    SUM(vacc.new_vaccinations)
    OVER (
        PARTITION BY deth.location
        ORDER BY deth.date
    ) AS rolling_vaccinations,

    (
        SUM(vacc.new_vaccinations)
        OVER (
            PARTITION BY deth.location
            ORDER BY deth.date
        ) / deth.population
    ) * 100 AS vaccination_percentage

FROM coviddeaths deth

JOIN covidvaccinations vacc
    ON deth.location = vacc.location
    AND deth.date = vacc.date

WHERE deth.location IN (
    'Thailand',
    'Vietnam',
    'Malaysia',
    'Indonesia',
    'Philippines'
)

ORDER BY deth.location, deth.date;

select *,
case 
    when location = 'Thailand' then 'Focus Country'
    else 'Other SEA'
end as country_group
from coviddeaths
where location ='Thailand';

create view sea_covid_summary as
select 
    location,
    date,
    population,
    total_cases,
    total_deaths,
    (total_cases/population)*100 as infection_rate,
    (total_deaths/total_cases)*100 as death_rate
from coviddeaths
where location IN (
'Thailand','Vietnam','Malaysia','Indonesia',
'Philippines','Singapore','Myanmar',
'Cambodia','Laos','Brunei'
);

select *
from sea_covid_summary;

create view sea_vaccination_progress as
select 
    deth.location,
    deth.date,
    deth.population,
    vacc.new_vaccinations,
    sum(vacc.new_vaccinations )
    over(partition by deth.location order by deth.date)
    as rolling_vaccinations
from coviddeaths deth
join covidvaccinations vacc
on deth.location = vacc.location
and deth.date = vacc.date
where deth.location IN (
'Thailand','Vietnam','Malaysia','Indonesia',
'Philippines','Singapore','Myanmar',
'Cambodia','Laos','Brunei'
);

select *
from sea_vaccination_progress;

SHOW VARIABLES LIKE 'secure_file_priv';
SELECT *
INTO OUTFILE '/tmp/sea_covid_summary.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM sea_covid_summary;