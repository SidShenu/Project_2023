SELECT * FROM portfolio_project.coviddeathsr;

-- 1. looking at Total cases vs Total deaths 

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathspercentage
 from coviddeathsr 
 -- where location -- like "%dia%"
 order by 1,2;
 
 -- 2. looking at Total cases vs Population 
select Location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
 from coviddeathsr 
 -- where location like "%states%"
 order by 1,2;
 
 -- 3. Looking at countries with highest infection rate
 
 select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
 from coviddeathsr 
 -- where Location in ("india", "china", "nepal", "brazil")
 group by location, population
 order by PercentagePopulationInfected desc;
 
 -- 4. Showing countries with the highest Death Count per population
 select Location, max(total_deaths) as TotalDeathsCount
 from coviddeathsr 
 where continent is not null
 group by location
 order by TotalDeathsCount desc;
 
 -- 5. before we had some null value in continent Let check it with continent is not null
 select * from coviddeathsr
 where continent is not null
 order by 3,5;
 
 -- Let's Break down Things down by continent
 -- 6. Showing continents with the highest death count per population
 
 Select continent, max(total_deaths) as TotalDeathCount from coviddeathsr
 where continent is not null 
 group by continent
 order by TotalDeathCount desc ;  -- Its wrong while taking continent columns for correct input. Let's check with the location columns.
 
 -- 7. Showing continents with the highest death count per population while take location as a continent.
 
 Select location, max(total_deaths) as TotalDeathCount from coviddeathsr
 where continent is null and 
 location not in ("World","European Union","International")
 group by location
 order by TotalDeathCount desc ;
 
 -- 8. Gobal Number with date wise
 Select date, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathsPercentage 
 from coviddeathsr
 where continent is not null
 group by date
 order by date ;
 
 -- 9. Gobal Number with sum of all 
 Select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathsPercentage 
 from coviddeathsr
 where continent is not null
 order by date ;
 
 -- 10.Looking at Total Population vs Vaccinations
 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 Sum(vac.new_vaccinations) Over (partition by dea.location order by dea.location, dea.date) as Rolling_Vac
 -- ,( Rolling_Vac / dea.population) * 100 as Rolling_Vac_Pec
 from coviddeathsr dea join covidvaccination vac
 on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null 
order by 2,3;

-- 11.USE CTE and also view 
create or replace view POPVSVAC as (
With POPVSVAC (continent, location, date, population, new_vaccinations, Rolling_Vac) as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 Sum(vac.new_vaccinations) Over (partition by dea.location order by dea.location, dea.date) as Rolling_Vac
 -- ,( Rolling_Vac / dea.population) * 100 as Rolling_Vac_Pec
 from coviddeathsr dea join covidvaccination vac
 on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null 
-- order by 2,3
)
Select *,(ROlling_Vac/population)* 100 as Roll_Vac_Per from POPVSVAC
);

