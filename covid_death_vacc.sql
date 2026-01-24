select location , continent from covid_deaths
group by location, continent
order by location;

--select data that we are going to use and sort it by location and date
--show likelihood of dying if you contract covid in your  country 
select location, date , total_cases , new_cases ,total_deaths, population , (total_deaths/total_cases)* 100 as death_rate_percentage
from covid_deaths 
where location in ('Thailand','Myanmar')
order by 1,2; 


--looking at total cases vs population to see the spread of the virus
--show what percentage got covid in your country
select location , date , population , total_cases , total_deaths ,(total_cases/population)*100 as case_percentage 
from covid_deaths 
order by 2,1;

--looking at the  affected location with highest affected cases and percentage
select location ,population, max(total_cases ) highest_affection_count, max(total_deaths) ,max((total_cases/population))*100 as case_percentage 
from covid_deaths 
group by location,population
order by 5 desc;


--looking countries with highest death count 
select location , max(total_deaths) as total_death_count
from covid_deaths
where continent is not null --without this the united states is not number one because of null values
group by location
order by 2 desc;

select continent,max(total_deaths) as total_death_count
from covid_deaths
where continent is not null
group by continent
order by 2 desc;

select location,max(total_deaths) as total_death_count
from covid_deaths
where continent is  null
group by location
order by 2 desc;

--shouw continents with highest death count per population
select continent , location ,max(total_deaths) as total_death_count
from covid_deaths
where continent is not null
group by continent,location
order by 1,2 DESC ;

--convert date column to date type
ALTER TABLE covid_deaths
ALTER COLUMN date TYPE DATE
USING TO_DATE(date, 'DD/MM/YYYY');

--global numbers
select date,sum(new_cases) as total_new_cases ,sum(new_deaths),sum(new_deaths)/sum(new_cases)*100 as global_death_rate_percentage
from covid_deaths
where continent is not null
group by date
order by 1,2 ASC;

select * FROM covid_deaths;

select location ,life_expectancy as average_life_expectancy,avg(total_deaths/population)*100 as death_rate_percentage
from covid_deaths
where continent is not null
group by location,life_expectancy
order by 1,2 DESC
;

select * 
from covid_vaccinations;

--had to change the date because one is date type and the other is string type
alter table covid_vaccinations
alter column date type date 
using to_date(date,'DD/MM/YYYY'); 

select deth.continent,deth.location,deth.population ,deth.date , vacc.new_vaccinations
from covid_deaths deth
join covid_vaccinations vacc
on deth.location = vacc.location
and deth.date = vacc.date
where deth.continent is not null
order by 1,2,4;


--rolling sum of vaccinations per location
select deth.continent,deth.location,deth.population ,deth.date , vacc.new_vaccinations,sum(cast(vacc.new_vaccinations as int) )over(PARTITION BY deth.location order by deth.date) as rolling_sum_vaccinations
from covid_deaths deth
join covid_vaccinations vacc
on deth.location = vacc.location
and deth.date = vacc.date
where deth.continent is not null
order by 2,4;

--use cte to use  rolling_sum_vaccinations
WITH cte (continent , location , population , date , new_vaccinations ,rolling_sum_vaccinations) as
(
  select deth.continent,deth.location,deth.population ,deth.date , vacc.new_vaccinations,sum(cast(vacc.new_vaccinations as int) )over(PARTITION BY deth.location order by deth.date) as rolling_sum_vaccinations
from covid_deaths deth
join covid_vaccinations vacc
on deth.location = vacc.location
and deth.date = vacc.date
where deth.continent is not null
)
select continent , location , population , rolling_sum_vaccinations,(rolling_sum_vaccinations/population::numeric)*100 as vaccination_percentage
from cte-- have to be numeric to avoid integer division because I got zero
order by 2;



--same but using temp table
--important 
drop table if exists percen_people_vaccinated;
create table percen_people_vaccinated(
continent varchar(255),
location varchar(255),
population numeric,
date date,
new_vaccinations numeric,
rolling_sum_vaccinations numeric
)
insert into percen_people_vaccinated(
select deth.continent,deth.location,deth.population ,deth.date , vacc.new_vaccinations::numeric,sum(cast(vacc.new_vaccinations as int) )over(PARTITION BY deth.location order by deth.date) as rolling_sum_vaccinations
from covid_deaths deth
join covid_vaccinations vacc
on deth.location = vacc.location
and deth.date = vacc.date
where deth.continent is not null
)

select location , population , date , new_vaccinations ,(rolling_sum_vaccinations/population)*100 as vaccination_percentage
from percen_people_vaccinated


--create view to store data for visualization
;

create view per_people_cavv as 
select deth.continent,deth.location,deth.population ,deth.date , vacc.new_vaccinations,sum(cast(vacc.new_vaccinations as int) )over(PARTITION BY deth.location order by deth.date) as rolling_sum_vaccinations
from covid_deaths deth
join covid_vaccinations vacc
on deth.location = vacc.location
and deth.date = vacc.date
where deth.continent is not null
;


select *from per_people_cavv
