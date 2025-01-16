use Retail

--product with the highest revenue
select oi.product_id,product_name,sum(price_at_purchase) total_sale  from products p
join order_items oi on p.product_id=oi.product_id
group by oi.product_id,product_name
order by total_sale desc

--product with the highest quanity sold
select oi.product_id,product_name,sum(quantity) quantity_sold   from products p
join order_items oi on p.product_id=oi.product_id
group by oi.product_id,product_name
order by quantity_sold desc

--average rating of each product category 
select category ,avg(cast(rating as decimal)) as Average_Rating
from products p join reviews r on p.product_id=r.product_id
group by category
order by Average_Rating desc

-- total sale by product's category
select category,sum(price_at_purchase) total_sale from products p
join order_items oi on p.product_id=oi.product_id
group by category
order by total_sale desc

--total quantity by product's category
select category,sum(quantity) total_quantity from products p
join order_items oi on p.product_id=oi.product_id
group by category
order by total_quantity desc

--total sale for each product 
select p.product_id,product_name,sum(price_at_purchase) total_sale from products p
join order_items oi on p.product_id=oi.product_id
join orders o on o.order_id=oi.order_id
join payment pay on pay.order_id=o.order_id
where transaction_status='Completed'
group by p.product_id,product_name
order by total_sale desc

-- Count of Orders by State
select state, count(*) count_order from (select customer_id,RIGHT(address,2) State from customers) state_group
join orders o on o.customer_id=state_group.customer_id
group by State 
order by count_order desc

--Sum of price for orders every month
select month(order_date) month ,round(sum(total_price),2) total_price_order from orders
group by month(order_date)
order by month


