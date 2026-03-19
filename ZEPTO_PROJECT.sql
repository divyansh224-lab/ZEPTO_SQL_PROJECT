--created a primary key ---

alter table zepto
add sku_id int IDENTITY (1,1) PRIMARY KEY
--DATA EXPO---

--COUNTS OF ROWS --

select COUNT (*) from dbo.zepto

--SAMPLE DATA--
SELECT* FROM zepto

--NULL VALUE--
SELECT * FROM zepto
WHERE name is null
or Category is null
or mrp is null
or discountedSellingPrice is null
or availableQuantity is null
or outOfStock is null
or discountPercent is null
or weightInGms is null 
or quantity is null

--DIFFERENT PRODUCT CATEGORY --

SELECT DISTINCT category
from zepto
order by Category

-- how many product in/out of stock--

select outOfstock, COUNT (sku_id)
FROM zepto 
group by outOfStock

--product name present multiple times --

select name , count (sku_id)as 'NUMBERS OF skus'
from zepto
group by name 
having COUNT (sku_id) >1
order by COUNT (sku_id) desc

--data cleaning--
--product with price 0--

select *from zepto
where mrp=0 or discountedSellingPrice=0

delete from zepto
where mrp=0

--	QUESTUIN. 1- FIND THE TOP 10  BEST - VALUE PRODUCTS BASED ON DISCOUNT PERCENTAGES .--
select distinct name ,mrp,discountpercent
from zepto 
order by discountPercent desc
offset 0 rows
fetch next 10 rows only 
--OUESTION.2- WHAT PRODUCT IS OF HIGH MRP BUT OUT OG STOCK --
SELECT distinct name, mrp
from zepto
where outOfStock=  'True' and mrp > 3000
order by mrp desc
--	QUESTION 3-calculat estimated revenue of each category--
SELECT category,
sum(discountedsellingprice * availableQuantity) as total_revenue 
from zepto
group by Category
order by total_revenue
--	QUESTION.4-FIND ALL PRODUCT WHERE MRP IS GREATOR THAN 5000AND THE DISCOUNT IS LESS THAN 10%--
SELECT distinct name,mrp,discountPercent
from zepto where mrp >5000 and discountPercent< 10
order by mrp desc, discountPercent desc
-- QUESTION.5- IDENTIFY TOP5 CATEGORIES  OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENT --
SELECT category,
round(avg(discountPercent),2) as avg_discount
from zepto
group by Category
order by avg_discount
--QUESTION.6- FIND OUT THE PRICE PER GRAM FOR PRODUCT ABOVE 100 GRAM AND SHORT BY BEST VALUE--
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;
--QUESTION 7.GROUP THE PRODUCT INTO CATEGORIES LIKE ,LOW, MEDIUM BULK,--
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
     ELSE 'Bulk'
END AS weight_category
FROM zepto;
--WHAT THE TOTAL INVENTRY WEIGHT PER CATEGORY--
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight
