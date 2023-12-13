
-- 1. Gobal Number with sum of all 
 Select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathsPercentage 
 from coviddeathsr
 where continent is not null
 order by date ;
 
 -- 2. Continent Number with the TotslDeathCount
  Select location, max(total_deaths) as TotalDeathCount from coviddeathsr
 where continent is null and 
 location not in ("World","European Union","International")
 group by location
 order by TotalDeathCount desc ;
 
  -- 3. Looking at countries with highest infection rate
 
 select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
 from coviddeathsr 
 -- where Location in ("india", "china", "nepal", "brazil")
 group by location, population
 order by PercentagePopulationInfected desc;
 
 
  -- 4. Looking at countries with date and highest infection rate
 
 select Location, population,date, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
 from coviddeathsr 
 -- where Location in ("india", "china", "nepal", "brazil")
 group by location, population, date
 order by PercentagePopulationInfected desc;