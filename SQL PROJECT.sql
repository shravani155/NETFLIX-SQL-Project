/*
===============================================
             NETFLIX SQL PROJECT
===============================================

👤 Author        : Shravani Kathilkar
📅 Date          : June 2025
📝 Description   : 
   This project explores the Netflix dataset using PostgreSQL.
   It solves 15 business problems through SQL queries such as:
   - Movie vs TV Show analysis
   - Most common ratings
   - Content trends by year and country
   - Actor/director appearances
   - Content categorization by keywords

📦 Dataset Table : netflix

===============================================
*/


-- Netflix Project

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

SELECT * FROM netflix;


SELECT 
    COUNT(*) as total_content
FROM netflix;


SELECT 
    dISTINCT Type 
FROM netflix;

SELECT * FROM netflix;

-- 15 Business Problems 

-- 1. Count the number of Movies vs TV shows

SELECT
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
       
   

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;


-- 5. Identify the Longest Movie

SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

-- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

-- 8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
  
-- 9. Count the Number of Content Items in Each Genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

-- 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- 12. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

/*
==============================
         SUMMARY SHEET
==============================

Business Questions Solved:
--------------------------
1. Count the number of Movies vs TV Shows
2. Find the most common rating for Movies and TV Shows
3. List all Movies released in a specific year (2020)
4. Top 5 countries with most Netflix content
5. Identify the longest movie by duration
6. Content added in the last 5 years
7. Movies/TV Shows by director 'Rajiv Chilaka'
8. TV Shows with more than 5 seasons
9. Count content items in each genre
10. Average content released in India per year
11. List all Documentaries
12. Find content without a director
13. Count of movies featuring 'Salman Khan' in the last 10 years
14. Top 10 actors in Indian Netflix content
15. Categorize content as 'Good' or 'Bad' by keywords

==============================
End of SQL Project
==============================
*/
