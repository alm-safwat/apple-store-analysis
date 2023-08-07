CREATE TABLE applestore_description_combined AS
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4

-- checking the number of unique apps in both tables.AppleStore
SELECT COUNT (DISTINCT id) AS unique_app
FROM AppleStore

SELECT COUNT (DISTINCT id) AS unique_apps
FROM applestore_description_combined

-- checking the missing values in the key fileds from both tables 

SELECT count (*) AS missing_values
FROM AppleStore
WHERE track_name is null or user_rating is NULL or prime_genre is null

SELECT count (*) AS missing_values
FROM applestore_description_combined
WHERE app_desc is null 

-- Finding out the number of apps per genreAppleStore
SELECT prime_genre, COUNT (*) AS numApps
FROM AppleStore
GROUP by prime_genre
order by numApps DESC

-- Finding out the apps ratings as well
SELECT min(user_rating) AS minRating,
		max(user_rating) AS maxRating,
        avg(user_rating) AS avgRating
From AppleStore

-- Determine if the paid apps have higher ratings than the free apps or not. 

SELECT CASE 
		WHEN price > 0 THEN 'Paid'
        Else 'Free' 
     End as app_type,
     avg(user_rating) AS avg_rating
FROM AppleStore
GROUP By app_type

--  Determining if apps that support more languages have higher ratings. 
select case 
		when lang_num < 10 then 'less tha 10 languages'
        when lang_num BETWEEN 10 and 30 then 'Between 10-30 languages'
       ELSE 'More than 30 languages'
       END as language_support,
       avg(user_rating) AS avg_rating
FROM AppleStore
GROUP by language_support
ORDER by avg_rating DESC

-- checking the genre with low ratings

SELEct prime_genre, avg(user_rating) AS avg_rating
FROM AppleStore
group by prime_genre
order by avg_rating ASC
LIMIT 10


-- Finding out if there are correlations between the length of app decription and the user rating 
SELECT CASE
		WHEN length(d.app_desc) < 500 THEN 'Short description'
        WHEN length(d.app_desc) BETWEEN 500 and 1000 THEN 'Medium description'
        ELse 'Long description'
        end as desc_length,
        avg(user_rating) AS avg_rating
FROM AppleStore AS a
LEFT JOIN applestore_description_combined as d 
ON a.id = d.id
GROUP By desc_length
order by avg_rating DESC

-- Finding out the top rated apps for each category
SELECT prime_genre, 
	   track_name, 
       user_rating
FROM (
	SELECT
  	prime_genre, 
  	track_name, 
  	user_rating,
  	RANK() OVER(PARTITION by prime_genre order by user_rating desc, rating_count_tot desc) AS rank
    FROM AppleStore
	) as a
where a.rank = 1



     
        