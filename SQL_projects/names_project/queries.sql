-- Count number of names for each Gender
SELECT DISTINCT COUNT(Name) as 'names_count', Gender FROM NationalNames
GROUP BY Gender

-- Top 10 names for men
SELECT SUM(Count) as 'COUNT', Name FROM NationalNames
WHERE Gender = 'M'
GROUP BY Name
ORDER BY 1 DESC
LIMIT 10

-- Top 10 names for female
SELECT SUM(Count) as 'COUNT', Name FROM NationalNames
WHERE Gender = 'F'
GROUP BY Name
ORDER BY 1 DESC
LIMIT 10

-- Grabing names for female and male from years 1910-2014 with step=15
SELECT DISTINCT Name, Count,Year, Gender FROM NationalNames
WHERE Year in (1910,1925,1940,1955,1970,1985,2000,2014)
GROUP BY Year,Gender

-- Grabing popularity of specific names by years
SELECT Name,Year,Count FROM NationalNames
WHERE Gender == 'F' AND Name in ('Mary','Elizabeth','Jennifer','Linda','Emma','Jessica','Emily')

-- Grabing popularity of names for states in 2014
SELECT Name,State,Count,Gender FROM StateNames
WHERE Year = 2014
GROUP By State,Gender

-- Grabing popularity of names for states in 1945
SELECT Name,State,count,Gender FROM StateNames
WHERE Year = 1945
GROUP By State,Gender
-- It seems like variousity between most popular names for year 2014 is bigeeet

-- Counting percantage of top 10 names for men divided by all number of names in 1945 and 2014
SELECT Name,Count,
Sum(Count) * 100.0 / (SELECT Sum(Count) as 'COUNT' FROM NationalNames WHERE Gender = 'M' and Year = 1945) as name_percantage
FROM NationalNames
WHERE Gender = 'M' and Year = 1945
GROUP BY Count
ORDER BY 2 DESC
LIMIT 10

SELECT Name,Count,
Sum(Count) * 100.0 / (SELECT Sum(Count) as 'COUNT' FROM NationalNames WHERE Gender = 'M' and Year = 2014) as name_percantage
FROM NationalNames
WHERE Gender = 'M' and Year = 2014
GROUP BY Count
ORDER BY 2 DESC
LIMIT 10

-- Unique number of names by years
SELECT Count(Name) as number_of_unique_names, Year, Gender FROM NationalNames
GROUP BY Year, Gender

-- Checking origin (names from https://www.thebump.com/baby-names)
SELECT Year,Origin, Count(Origin) as 'NumberNames' FROM NationalNames
INNER JOIN NamesOrigin ON NationalNames.Name = NamesOrigin.Name
GROUP BY Year, Origin

/* Some origins were conected with others to make visualizations more transparent:
'Irish','Gaelic','Celtic' - 'Irish/Gaelic/Celtic'
'Finnish','Swedish','Norwegian','Norse','Danish' - Scandinavian
'Russian','Polish','Czech' - 'Slavic'
'Swahili','Ghanaian','Nigerian','African - 'African'
'Sanskrit','Indian' - 'Indian'
'Cambodian','Korean','Vietnamese','Chinese','Japanese' - 'East Asian'
'Aramaic','Hebrew' - 'Aramaic/Hebrew'
'Babylonian','Egyptian','Turkish','Yiddish' - 'Others'
'Spanish','Portuguese','Basque' - 'Iberian'
'Dutch','German' - 'Dutch/German' */
