Select * from Covid_deaths$ where continent is Not Null order by 3,4 
--Select * from Covid_vaccinations$ order by 3,4
--Select location,date, population, total_cases, new_cases, total_deaths, new_deaths from Covid_deaths$
--order by 1,2

--Cases vs Deaths
Select location,date,population, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage from Covid_deaths$
where location like 'India'
order by 1,2

--Cases vs population
Select location,date, population, total_cases, (total_cases/population)*100 as infection_percentage from Covid_deaths$
where location like 'India'
order by 1,2

-- Countries with highest infection rate
Select location, population, max(total_cases) as Highest_infection_count, max((total_cases/population)*100) as Highest_infection_percentage from Covid_deaths$
group by location,population
order by 4 desc


-- Countries with highest death count
Select location, max(cast(total_deaths as int)) as Highest_death_count from Covid_deaths$
where continent is Not Null 
group by location
order by 2 desc

--Continents with highes death count
Select continent, max(cast(total_deaths as int)) as Highest_death_count from Covid_deaths$
where continent is Not Null 
group by continent
order by 2 desc

--Global numbers
Select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage 
from Covid_deaths$
where continent is Not Null
order by 1,2


--Total population vs Vaccination
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from Covid_deaths$ dea
join Covid_vaccinations$ vac
on dea.location=vac.location
where dea.continent is Not Null
and dea.date=vac.date
order by 2,3


--Use CTE
with popvsvac (continent,locatin,date,population,new_vaccinations, Rolling_people_vaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from Covid_deaths$ dea
join Covid_vaccinations$ vac
on dea.location=vac.location
where dea.continent is Not Null
and dea.date=vac.date
--order by 2,3
)

Select *, (Rolling_people_vaccinated/population)*100 from popvsvac


--Creating view to store data for later visualizations
Create view PercentPolulationVaccinated as --The incorrect syntax error on this line can be removed by putting create view query before CTE or by using GO command after CTE
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from Covid_deaths$ dea
join Covid_vaccinations$ vac
on dea.location=vac.location
where dea.continent is Not Null
and dea.date=vac.date
--order by 2,3


Select * from PercentPolulationVaccinated