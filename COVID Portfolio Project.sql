Select *
From PortfolioProject..CovidDeaths
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- lets pick the data that we are going to use
Select location, date, total_cases, new_cases, total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

-- we are going to be looking at total_cases VS total_deaths
-- Showcases the percentage of Deaths due to covid with respect to Countries
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%States%'
order by 1,2

-- Let's have a look at total_cases VS Population
-- Displays how much percentage of the population was infected with the Covid
Select location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
From PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2

Select location, date, population, total_cases,  (total_cases/population)*100 as CovidPercentage
From PortfolioProject..CovidDeaths
--where location like '%States%'
order by 1,2

-- Lets look at the countries with the highest Covid Rate VS Population
Select location, population, MAX(total_cases) as HighestCovidCount, MAX((total_cases/population))*100 as CovidPercentage
From PortfolioProject..CovidDeaths
--where location like '%India%'
Group by location, population
order by CovidPercentage desc

-- display countries with highest death counts VS population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null 
Group by location
order by TotalDeathCount desc

-- LET"S BREAK THIINGS DOWN BY CONTINENT
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Global Numbers
Select date, SUM(new_cases) --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- where location like '%India%'
Where continent is not null
Group by date
order by 1,2

Select date, SUM(new_cases), SUM(cast(new_deaths as int))
From PortfolioProject..CovidDeaths
-- Where location like '%India%'
Where continent is not null
Group by date
order by 1,2

Select date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%India%'
Where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%India%'
Where continent is not null
--Group by date
order by 1,2


-- We are going to looking at Total Population VS Vaccinations
-- Main Query

with PopVsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac
-- end

Select *
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	 and dea.date = vac.date



	 -- TEMP Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date DateTime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating a view for the later Visualizations
Drop view if exists PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
--order by 2,3


-- query for view
SELECT TOP (1000) [Continent]
		,[Location]
		,[Date]
		,[Population]
		,[New_vaccinations]
		,[RollingPeopleVaccinated]
		,[PercentPopulationVaccinated]
	FROM [PortfolioProject].[dbo].[PercentPopulationVaccinated]

--

Select *
From PercentPopulationVaccinated
		


