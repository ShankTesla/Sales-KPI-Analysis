/* Average deal size with respect to each order and customer id and product id? */

select order_id, customer_id, product_id, sales, quantity, (SUM(sales)/SUM(quantity)) as Avg_deal_size
from sample_superstore
group by order_id, customer_id, product_id, sales, quantity
order by Avg_deal_size desc;

/* The highest avg deal was made by order_id CA-2014-145317 with customer_id SM-20320
with product id TEC-MA-10002412 with avg deal size of 3778.08 */

/* Average revenue per product */

select product_id, product_name, sales, AVG(sales) as Average_revenue_per_product
from sample_superstore 
group by product_id, product_name, sales
order by Average_revenue_per_product desc;

/* The highest average revenue was made by TEC-MA-10002412, Cisco TelePresence System EX90 Videoconferencing Unit with 22638.48
and the lowest average revenue was made by OFF-AP-10002906, Hoover Replacement Belt for Commercial Guardsman Heavy-Duty Upright Vacuum with only 0.444 */

/* Gross margin per product */

select product_id, product_name, sales, profit, (SUM(profit)/ SUM(sales)) as gross_margin_per_product
from sample_superstore 
group by product_id, product_name, sales, profit
order by gross_margin_per_product asc;

/* looks like majority of them have a gross margin of 0.5 on high end and under -1.5 on lower end */

/* Number of units sold per day and/or year */
select date_trunc('year', order_date) as years,  SUM(quantity) as Number_of_units_sold_per_day
from sample_superstore 
group by years, order_id
order by Number_of_units_sold_per_day desc;

/* Most units sold was on 20th september 2017 and on yearly basis it was 2017 with 52 total */

/*Sales capacity per month*/

select to_char(date_trunc('month', "order_date"), 'Mon') as months, (SUM(sales)/COUNT(to_char(date_trunc('month', "order_date"), 'Mon'))) as Sales_capacity_per_month
from sample_superstore 
group by months
order by Sales_capacity_per_month desc

/* Most sales per month was on March  with sales capacity of 294.548 on average */

/* Sales per department */
select category, subcategory, AVG(sales) as Average_sales_per_department
from sample_superstore 
group by category, subcategory
order by Average_sales_per_department desc;

/* The best performing category on average is technology and within it the best sub category is copiers with 2198.941617647058 average sales 
 it makes sense because copiers is one of the most important machine to have regardless of what you own as a company */

/* Win/loss ratio percentage: */

select SUM(sales) as Total_sales, SUM(profit) as Total_profit, (SUM(profit)/SUM(sales))*100 as WinLossPercentage
from sample_superstore;

/*  Win/loss ratio percentage so far 12.467217240315902 */

/* Customer purchase frequency */

with cte as (
  select 
    customer_id,
    order_date,
    ROW_NUMBER() over (partition by customer_id order by order_date) as order_num,
    date_trunc('month', order_date) as order_month
  from 
    sample_superstore 
)
select 
  customer_id,
  count(distinct order_month) as purchase_frequency
from cte
where order_num > 1
group by customer_id
order by purchase_frequency desc;

/* we can see customer id PG-18820 has the highest purchase frequency of 12 along with KB-16585, DK-12835, SM-20950 with the same */



