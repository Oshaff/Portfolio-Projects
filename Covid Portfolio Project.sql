Select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Looking at the Total Cases vs Total Deaths
-- Shows Likelihood of dying if you contract covid in USA

Select Location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, population, ((total_cases/population)*100) as Covid_Infection_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Countries with Highest Infection Rates compared to Population

Select Location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Covid_Infection_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
Group by location, population
order by Covid_Infection_Percentage desc

-- Showing Countries with the Highest Death Count Per Population

Select Location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by Total_Death_Count desc

-- Showing Contient with Highest Death count

Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths
where continent is null and location not like '%income%'
Group by location
order by Total_Death_Count desc

-- Global Numbers

-- Total daily cases/daily deaths across the world

Select date, Sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Total cases and deaths across world

Select Sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Pop. vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccination_Total
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Creating View to store data for later visualizations

Create View Rolling_Vaccination_Total as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccination_Total
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null

select *
from Rolling_Vaccination_Total
