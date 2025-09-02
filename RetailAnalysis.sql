-- Join Sales with Calendar
Select * from Sales s join Calendar c on s.Date=c.Date;

---- 
-- Profit by Product Line
Select "Product line" ,sum(Quantity*(Price-"Unit Cost")) as profit
from Sales s 
group by "Product line" 
order by profit desc;

---- 
-- Profit by Product Line and Product Type
Select "Product line","Product type" ,sum(Quantity*(Price-"Unit Cost")) as profit
from Sales s 
group by "Product line","Product type" 
order by profit desc;

---- 
-- Profit Proportion by Order Method Type
SELECT "Order method type",
  SUM(Quantity * (Price - "Unit Cost")) / T.total_profit AS profit_proportion
FROM Sales AS s JOIN (
  SELECT
    SUM(Quantity * (Price - "Unit Cost")) AS total_profit
  FROM Sales
) AS T
GROUP BY "Order method type"
ORDER BY profit_proportion DESC;

---- 
-- Count of Orders by Order Method Type
Select "Order method type", count(*) as method_count 
from Sales s
group by "Order method type" 
order by method_count desc;

---- 
-- Monthly Profit Trend
Select "MonthNumber", sum(Quantity*(Price-"Unit Cost")) as profit
from Sales s
join Calendar c
on s.Date=c.Date
group by MonthNumber
order by profit desc;

---- 
-- Second Most Profitable Product Type by Country
select * 
from (
  select "Country","Product type",profit,
         rank() over (partition by "Country" order by profit desc ) as ranking 
  from (
    Select "Country","Product type",sum(Quantity*(Price-"Unit Cost")) as profit
    from (
      Select *,(Quantity*(Price-"Unit Cost")) as profit
      from Sales 
    ) s
    join Region r on s."Retailer country"=r."Country"
    group by "Country","Product type"
    order by Country,profit desc
  )
)
where ranking=2
order by Country;

---- 
-- Yearly Profit Trend
Select c.year,sum(Quantity*(Price-"Unit Cost")) 
from Sales s join Calendar c on s.Date=c.Date
group by c.year;

---- 
-- Ranking Product Types by Profit within Each Product Line
SELECT 
    "Product line",
    "Product type",
    profit,
    RANK() OVER (
        PARTITION BY "Product line" 
        ORDER BY profit DESC
    ) AS ranking
FROM (
    SELECT
        "Product line",
        "Product type",
        SUM(Quantity * (Price - "Unit Cost")) AS profit
    FROM Sales s
    GROUP BY "Product line", "Product type"
) t
ORDER BY "Product line", ranking;

---- 
-- Profit Margin by Country
Select "Retailer country" ,(profit/revenue) margin
from (
  select "Retailer country" ,
         Sum(Quantity*(Price -"Unit Cost")) profit,
         Sum(Quantity*Price) revenue 
  from Sales 
  group by "Retailer country" 
) s;

---- 
-- Profit Margin by Year
Select year ,(profit/revenue) margin
from (
  select strftime('%Y', Date) year ,
         Sum(Quantity*(Price -"Unit Cost")) profit,
         Sum(Quantity*Price) revenue 
  from Sales 
  group by year 
) s;

---- 
-- Quantity Sold by Order Method Type and Product Line
SELECT 
    "Order method type",
    "Product line",
    Quantity
FROM (
    SELECT
        "Order method type",
        "Product line",
        SUM(Quantity * (Price - "Unit Cost")) AS profit,
        SUM(Quantity) as Quantity
    FROM Sales s
    GROUP BY "Order method type", "Product line"
) t
ORDER BY "Order method type";

---- 
-- Sales Visit Orders: Quantity and Profit by Product Line
Select "Order method type",
    "Product line", Quantity,(Quantity * (Price - "Unit Cost")) AS profit 
from Sales s
where "Order method type"='Sales visit';

---- 
-- Web Orders: Quantity and Profit by Product Line
Select "Order method type",
    "Product line", Quantity,(Quantity * (Price - "Unit Cost")) AS profit 
from Sales s
where "Order method type"='Web';

---- 
-- Average Quantity per Order Method Type
select "Order method type", avg(Quantity)
from Sales s
group by "Order method type";

---- 
-- Order Method Distribution by Country
select "Retailer country","Order method type",COunt(*) as value
from Sales s
group by "Retailer country","Order method type"
order by "Retailer country" asc,value desc;

---- 
-- Profit Margin by Product Type
Select "Product type" ,(profit/revenue) margin
from (
  select "Product type" ,
         Sum(Quantity*(Price -"Unit Cost")) profit,
         Sum(Quantity*Price) revenue 
  from Sales 
  group by "Product type" 
) s;

---- 
-- Profit and Cost Ranking by Country and Product Line
select "Country","Product line",profit,
       rank() over (partition by "Country" order by profit desc ) as ranking,
       rank() over (partition by "Country" order by cost desc ) cost_rank 
from (
  Select "Country","Product line",
         sum(Quantity*(Price-"Unit Cost")) as profit,
         avg("Unit Cost") as cost
  from (
    Select *,(Quantity*(Price-"Unit Cost")) as profit
    from Sales 
  ) s
  join Region r on s."Retailer country"=r."Country"
  group by "Country","Product line"
  order by Country,profit desc
);

---- 
-- Average Unit Cost by Country and Product Line
select "Retailer country","Product line",avg("Unit Cost") cost 
from Sales s
group by "Retailer country","Product line"
order by "Retailer country",cost desc;

---- 
-- Monthly Sales Trend
Select strftime('%Y', Date) year,strftime('%m', Date) month, sum(Quantity*Price) sales
from Sales s
group by year,month;
