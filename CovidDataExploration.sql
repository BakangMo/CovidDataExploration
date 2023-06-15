ALTER TABLE portfolioproject.dbo.CovidDeaths
ALTER COLUMN Total_cases bigint

SELECT SUM(Total_cases)
FROM portfolioproject.dbo.CovidDeaths

--Looking at the Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_cases, (Total_deaths/total_cases)*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
ORDER BY 1,2
--Results returned error;Operand data type nvarchar is invalid for divide operator.

--Convert the datatype to integer
ALTER TABLE portfolioproject.dbo.CovidDeaths
ALTER COLUMN Total_cases bigint

--Looking at the Total cases vs Total deaths
SELECT Location, date, total_cases, total_cases, (Total_deaths/total_cases)*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
ORDER BY 1,2
--Results return 0 values on DeathRate


--Convert to float
ALTER TABLE portfolioproject.dbo.CovidDeaths
ALTER COLUMN Total_cases FLOAT

ALTER TABLE portfolioproject.dbo.CovidDeaths
ALTER COLUMN Total_deaths FLOAT


--Looking at Total Cases vs Population

SELECT Location, date, Population,Total_cases, (total_cases/population)*100 AS InfectionRate
FROM portfolioproject.dbo.CovidDeaths
WHERE location='South Africa'
Order by 1,2

--Looking at countries with the highest infection rate compared to population

SELECT Location, Population, MAX(Total_cases) AS highest_infection, MAX((Total_cases/population)) *100 AS InfectionRate
FROM portfolioproject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location, Population
Order by InfectionRate DESC

--CREATING VIEW TO STORE DATA TO VISUALIZE LATER
CREATE VIEW InfectionRatePerCountry as
SELECT Location, Population, MAX(Total_cases) AS highest_infection, MAX((Total_cases/population)) *100 AS InfectionRate
FROM portfolioproject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location, Population


--Showing Countries with the heighest death count per population

SELECT Location, Population, MAX(total_deaths) AS Deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location, Population
Order by Deaths DESC

--CREATING VIEW FOR STORAGE TO VISUALIZE LATER

CREATE VIEW DeathCountPerCountry as 
SELECT Location, Population, MAX(total_deaths) AS Deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location, Population



--BREAKING DATA DOWN BY CONTINENTS

SELECT Location, Population, MAX(total_deaths) AS Deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE continent is null AND Location NOT in ( 'World','High Income','Upper middle income','Lower middle income','Low income')
GROUP BY Location, Population
Order by Deaths DESC

--CREATE VIEW

CREATE VIEW ContinentalData as
SELECT Location, Population, MAX(total_deaths) AS Deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE continent is null AND Location NOT in ( 'World','High Income','Upper middle income','Lower middle income','Low income')
GROUP BY Location, Population

--Total deaths by continents
SELECT Location, MAX(total_deaths) AS Deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE location in ('Africa', 'Asia', 'Oceania', 'Europe', 'North America', 'South America')
GROUP BY Location
Order by Deaths DESC

-- Total infections by continents

SELECT Location, MAX(total_cases) AS Cases
FROM portfolioproject.dbo.CovidDeaths
WHERE location in ('Africa', 'Asia', 'Oceania', 'Europe', 'North America', 'South America')
GROUP BY Location
Order by Cases DESC


--Total_cases vs Total_Deaths AS death rate

SELECT Location, MAX(total_cases) AS Cases, MAX(total_deaths) AS Deaths, MAX((total_deaths/total_cases))*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE location in ('Africa', 'Asia', 'Oceania', 'Europe', 'North America', 'South America')
GROUP BY Location
Order by DeathRate DESC

--CREATE VIEW
CREATE VIEW continentalDeathRate as
SELECT Location, MAX(total_cases) AS Cases, MAX(total_deaths) AS Deaths, MAX((total_deaths/total_cases))*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE location in ('Africa', 'Asia', 'Oceania', 'Europe', 'North America', 'South America')
GROUP BY Location

--BREAK DOWN AFRICA

--African INFECTION count by country

SELECT Location, MAX(total_cases) AS cases
FROM portfolioproject.dbo.CovidDeaths
WHERE continent ='Africa'
GROUP BY Location
Order by cases DESC

--African INFECTION RATE by country

SELECT Location,Population, MAX(total_cases) AS cases, MAX((total_cases/population))*100 AS InfectionRate
FROM portfolioproject.dbo.CovidDeaths
WHERE continent ='Africa'
GROUP BY Location, Population
Order by InfectionRate DESC

--African DEATH count by country

SELECT Location, MAX(total_deaths) AS deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE continent ='Africa'
GROUP BY Location
Order by deaths DESC

CREATE VIEW AfricanDaethCount as 
SELECT Location, MAX(total_deaths) AS deaths
FROM portfolioproject.dbo.CovidDeaths
WHERE continent ='Africa'
GROUP BY Location

--African DeathRate by Country-- Total Cases vs Total Deaths

SELECT Location,Population, MAX(total_cases) AS cases,MAX(total_deaths) AS Deaths, (MAX(total_deaths/total_cases))*100  AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE continent ='Africa'
GROUP BY Location, Population
Order by DeathRate DESC

CREATE VIEW AfricanDeathRate as
SELECT Location,Population, MAX(total_cases) AS cases,MAX(total_deaths) AS Deaths, (MAX(total_deaths/total_cases))*100  AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE continent ='Africa'
GROUP BY Location, Population

--LOOKING AT SOUTH AFRICA

--South african numbers

SELECT location, Population, MAX(Total_cases) AS cases,(MAX(total_cases/population))*100 AS infectionRate, MAX(Total_deaths) AS Deaths, (MAX(total_deaths/total_cases))*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE location= 'South Africa'
GROUP BY location, population

CREATE VIEW ZA_DATA as

SELECT location, Population, MAX(Total_cases) AS cases,(MAX(total_cases/population))*100 AS infectionRate, MAX(Total_deaths) AS Deaths, (MAX(total_deaths/total_cases))*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE location= 'South Africa'
GROUP BY location, population

-- LOOKING AT THE TOTAL CASES VS TOTAL DEATHS
SELECT Location, date, Total_cases, Total_deaths, (total_deaths/Total_cases)*100 AS DeathRate
FROM portfolioproject.dbo.CovidDeaths
WHERE location='South Africa'
Order by 1,2


--LOOKING AT VACCINATIONS

SELECT dth.continent, dth.location, dth.date, vac.new_vaccinations
FROM portfolioproject.dbo.CovidDeaths dth
JOIN PortfolioProject.dbo.CovidVaccinations vac
ON dth.location= vac.location
and dth.date= vac.date
WHERE dth.continent is not null
order by 2,3

--Rolling count of vaccinations

SELECT dth.continent, dth.location, dth.date, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dth.location  ORDER BY dth.location, dth.date) AS Rolling_vac_count
FROM portfolioproject.dbo.CovidDeaths dth
JOIN PortfolioProject.dbo.CovidVaccinations vac
ON dth.location= vac.location
and dth.date= vac.date
WHERE dth.continent is not null
order by 2,3

--USE CTE

WITH popvsvac (Continent, location, date,population, new_vaccination, Rolling_vac_count)
as 
(
SELECT dth.continent, dth.location, dth.date,dth.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dth.location  ORDER BY dth.location, dth.date) AS Rolling_vac_count
FROM portfolioproject.dbo.CovidDeaths dth
JOIN PortfolioProject.dbo.CovidVaccinations vac
ON dth.location= vac.location
and dth.date= vac.date
WHERE dth.continent is not null
)
SELECT *
FROM popvsvac

--TEMP TABLE

CREATE TABLE #Vaccination_Rate
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_vac_count numeric
)

insert into #Vaccination_Rate
SELECT dth.Continent, dth.Location, dth.Date,dth.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dth.location  ORDER BY dth.location, dth.date) AS rolling_vac_count
FROM portfolioproject.dbo.CovidDeaths dth
JOIN PortfolioProject.dbo.CovidVaccinations vac
ON dth.location= vac.location
and dth.date= vac.date
WHERE dth.continent is not null
ORDER BY 2,3

SELECT *
FROM #Vaccination_Rate

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

CREATE VIEW Vaccination_Rate as 
SELECT dth.continent, dth.location, dth.date,dth.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dth.location  ORDER BY dth.location, dth.date) AS Rolling_vac_count
FROM portfolioproject.dbo.CovidDeaths dth
JOIN PortfolioProject.dbo.CovidVaccinations vac
ON dth.location= vac.location
and dth.date= vac.date
WHERE dth.continent is not null

ALTER TABLE #vaccination_rate
ADD new_vaccinations numeric

SELECT new_vaccinations
FROM PortfolioProject.dbo.CovidVaccinations 

ALTER TABLE PortfolioProject.dbo.CovidVaccinations 
ALTER COLUMN new_vaccinationS FLOAT
