# drop database if exists `covid_19_project`;
# I comment the above code out to avoid accident incase you ran all the codes by accident to avoid losing your database.

create database `covid_19_project`;

use covid_19_project;

# Tables are imported as Csv file
select * from death;
select * from vaccination;

select sum(total_deaths) from death where country ='nigeria';
select Country, date, total_cases, total_deaths from death where country =('nigeria') order by date;

select * from vaccination;

#Nigerian infection rate and population infected
select Country, population, max(total_cases) as Infection_rate_count, max(total_cases/population) * 100 as Population_infected
from death where country = ('nigeria') group by country, population;

#United states and united kingdom infection rate and population infected
select Country, population, max(total_cases) as Infection_rate_count, max(total_cases/population) * 100 as Population_percent_infected
from death where country = ( 'united states' and 'united kingdom') group by country, population order by country, population;

# Total cases by Months 
select Country, date, month(date) as Month, sum(total_cases) as Total_cases From death group by country, date, month(date)
 order by country, date, month(date);

# Average deaths by country.
select Country, population, avg(total_deaths) as Average_death
from death where country = ('nigeria'and 'united kingdom') group by country, population;

#Total cases by year
select Country, year(date) as year, sum(total_cases) as Total_cases From death group by country, year(date)
 order by country, year(date);

# Total deaths by year
select Country, year(date) as Year, sum(total_deaths) as Total_death From death group by country, year(date)
 order by country, year(date);

# Doing a table joins with date.
select * from death d join vaccination v on d.`date` = v.`date`;

# Total vaccinations by country
select d.Country, sum(total_vaccinations) as vaccination_count from death d join vaccination v on d.`date` = v.`date` group by country;

#Populations Vaccinated
select d.Country, d.population, max(total_vaccinations) as vaccination_count, max(total_vaccinations / d.population)*100 as Population_vaccinated
from death d join vaccination v on d.`date` = v.`date` group by country, d.population order by country, d.population;

# creating a new to table so as to drop a column without affecting the original table
Create table new_vaccination 
select * from Vaccination;

# Droping iso_code and Country
alter table new_vaccination
drop column iso_code,
drop column country,
drop column population;

select * from new_vaccination;

select * from death d join new_vaccination n on d.`date` = n.`date` ;

# View for Nigeria
create view Nigeria as 
select d.date,
 n.date as dates , Country,  Population, total_cases, new_cases, total_deaths, new_deaths, icu_patients, total_tests,
 tests_per_case, tests_units, total_vaccinations, new_vaccinations, cardiovasc_death_rate, 
 handwashing_facilities from death d join new_vaccination n on d.`date` = n.`date`
   where country = 'nigeria';
   
   select * from nigeria;
   
   #View for united states
   create view united_states as 
select d.date,
 n.date as dates , Country,  Population, total_cases, new_cases, total_deaths, new_deaths, icu_patients, total_tests,
 tests_per_case, tests_units, total_vaccinations, new_vaccinations, cardiovasc_death_rate, 
 handwashing_facilities from death d join new_vaccination n on d.`date` = n.`date`
   where country = 'united states';
   
   # View for United kingdom
   create view United_kingdom as 
select d.date,
 n.date as dates , Country,  Population, total_cases, new_cases, total_deaths, new_deaths, icu_patients, total_tests,
 tests_per_case, tests_units, total_vaccinations, new_vaccinations, cardiovasc_death_rate, 
 handwashing_facilities from death d join new_vaccination n on d.`date` = n.`date`
   where country = 'United kingdom';


# count of test units
select  count(tests_units)  from nigeria; #1094 test units

# sum of icu patients
select sum(icu_patients) from nigeria; # its 0 Non on icu

# Total test carried out
select sum(total_tests) from nigeria;

# % of populations tested
select population, max(total_tests/population)* 100 as populations_vaccinated
from nigeria group by population; #2.4% tested


# united states count of test units
select  count(tests_units)  from united_states; #1093 test units


 # sum of icu patients
select sum(icu_patients) from united_states; # 9702273 patients on icu

# Total test carried out
select sum(total_tests) from united_states; # 326330278 tested


# % of populations tested
select population, max(total_tests/population)* 100 as populations_vaccinated
from united_states group by population; # 1.5% of population tested


# united kingdom count of test units
select  count(tests_units)  from united_kingdom; # 1094 units


 # sum of icu patients
select sum(icu_patients) from united_kingdom; # 703291 icu patients

# Total test carried out
select sum(total_tests) from united_kingdom; # 326330278 tested


# % of populations tested
select population, max(total_tests/population)* 100 as populations_vaccinated
from united_kingdom group by population; # 7.8% of population tested