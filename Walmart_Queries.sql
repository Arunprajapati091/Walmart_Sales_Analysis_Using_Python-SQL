SELECT * FROM walmart;

DROP TABLE walmart;
--
SELECT COUNT(*) FROM walmart;

SELECT  payment_method, count(*) 
FROM walmart
GROUP BY 1;

SELECT COUNT(DISTINCT branch)
FROM walmart 

SELECT MAX(quantity) 
FROM walmart;


--BUSINESS QUESTION

--Q.1 Find different payment method and number of transactions, number of qty sold

SELECT * FROM walmart;

SELECT payment_method, count(*) as n_transaction , sum(quantity) as n_quantity
FROM walmart
GROUP BY payment_method

--Q.2 Identify the highest-rated category in each branch, displaying the branch, category

SELECT * 
FROM(
	SELECT branch, category , max(rating) as highest_rating ,
		   dense_rank() over(partition by branch order by  max(rating) desc) as rnk
	FROM walmart
	group by 1,2
	ORDER BY 1, 3 DESC)
WHERE rnk = 1

	
-- Q.3 Identify the busiest day for each branch based on the number of transactions

SELECT * FROM walmart

SELECT * 
FROM (
		SELECT  branch, 
				TO_CHAR(date, 'Day') as day_of_week , 
				count(*) as n_transaction ,
				dense_rank() over(partition by branch order by count(*)  desc  ) rnk
		FROM walmart
		GROUP BY 1,2)
WHERE rnk = 1

--Q.3 Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

SELECT * FROM walmart

SELECT payment_method, sum(quantity) as total_quantity
FROM walmart
GROUP BY payment_method
ORDER BY 2 DESC

-- Q.5 Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.

SELECT * from walmart

SELECT  city, 
		avg(rating) average_rating , 
		min(rating) min_rating , 
		max(rating) max_rating
FROM walmart
GROUP BY city

-- Q.6 Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

SELECT * FROM walmart

SELECT  category, 
		sum(unit_price * quantity * profit_margin) as total_profit 
FROM walmart
GROUP BY category

-- Q.7 Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

SELECT * FROM walmart

WITH CTE AS
(SELECT  branch, 
		payment_method, 
		count(payment_method),
		rank() over(partition by branch order by count(payment_method) desc) as rnk
FROM walmart
GROUP BY 1,2 )

SELECT * 
FROM CTE 
WHERE rnk = 1


-- Q.8 Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT * FROM walmart

SELECT  COUNT(*) AS n_invoices,
		CASE WHEN EXTRACT(HOUR FROM (time::time)) < 12 then 'Morning'
			 WHEN EXTRACT(HOUR FROM (time::time)) between 12 and 17 then 'Afternoon'
			 ELSE 'Evening'
		end as day_time,
		branch
	   
FROM walmart 
GROUP BY 2,3


-- #9 Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

-- rdr == last_rev-cr_rev/ls_rev*100

SELECT * FROM walmart

WITH last_yr_rev as
(SELECT branch, 
	   sum(total) rev_2022
FROM walmart
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY 1),

Curr_yr_rev as

(SELECT branch, 
	   sum(total) rev_2023
FROM walmart
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY 1
)

SELECT  lr.branch, 
		lr.rev_2022 ,
		cr.rev_2023 ,
		(lr.rev_2022 - cr.rev_2023)::numeric / (lr.rev_2022 )::numeric * 100 as percent_dec_revenue
FROM last_yr_rev as lr
JOIN Curr_yr_rev AS cr
ON lr.branch = cr.branch
where lr.rev_2022 > cr.rev_2023
ORDER BY 4 DESC
limit 5


















