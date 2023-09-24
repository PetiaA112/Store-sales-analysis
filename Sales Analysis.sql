
                                                                         --STORE SALES ANALYSIS 2019

																	
															
																		 


SELECT *
  FROM [Project].[dbo].[Sales analysis ]



                                                                      --Overivew of sales table 

---------------------------------------------------------------------------------------------------------------------------------------------																  
-- Total profit before expenses : 34492035.7974904      
-- Total expenses :               12954872.931231        
-- Profit after expenses :        21438067.902579
-- Total number of transaction :  185948
-- Total quantity sold :          209079 
-- Number of unique products :    19
--------------------------------------------------------------------------------------------------------------------------------------------

                                                                --Performamce overview of each quarter 


																-- Quarter 1 ( January - March ) 

select sum(margin) 
from [Sales analysis ] -- 21438067.902579

select sum(turnover) as total_sales_before_expenses, sum(cost_price) as total_expenses , sum(margin) as total_margin, (sum(margin) /  21438067.902579 ) * 100 as percent_of_total_profit
from [Sales analysis ]
where order_id between 141234 and 176557
-- 19.78 % of total margin 


                                                                -- Quarter 2 ( April - June )

select sum(turnover) as total_sales_before_expenses, sum(cost_price) as total_expenses , sum(margin) as total_margin, (sum(margin) /  21438067.902579 ) * 100 as percent_of_total_profit
from [Sales analysis ]
where order_id between 176558 and 222909
-- 26.4 % of total margin 

                                                              -- Quarter 3 ( July - September )

select sum(turnover) as total_sales_before_expenses, sum(cost_price) as total_expenses , sum(margin) as total_margin, (sum(margin) /  21438067.902579 ) * 100 as percent_of_total_profit
from [Sales analysis ]
where order_id between 222910 and 259357
-- 20.2 % of total margin 

                                                              -- Quarter 4 ( October - December )

select sum(turnover) as total_sales_before_expenses, sum(cost_price) as total_expenses , sum(margin) as total_margin, (sum(margin) /  21438067.902579 ) * 100 as percent_of_total_profit
from [Sales analysis ]
where order_id between 259358 and 319670
-- 33.4 % of total margin 
-------------------------------------------------------------------------------------------------------




                                                          --Whcih month tend to be most proffitable ? 

select month, sum(turnover) as total_sales_before_expenses, sum(cost_price) as total_expenses, sum( margin ) as total_margin,  (sum(margin) /  21438067.902579  ) * 100 as percent_of_total_profit
from [Sales analysis ]
group by month
order by percent_of_total_profit desc
-- December as most proffitable 13.8 % of total profit
-- January as least 5.2 % of total profit 
------------------------------------------------------------------------------------------------------------------------------------


                                                    --which day of the week tend to be most proffitable ?

select day, sum( margin ) as total_profit,  count( order_id) as total_puchasing, sum(quantity_ordered) as total_quantity_purchased 
from [Sales analysis ]
group by day
order by total_profit desc
-- Tuesday tent to be most proffitable
-- Thursday tend to be least proffitable
-----------------------------------------------------------------------------------------------------------------------------------


                                                    --which category has made most contribution to revenue ? 

select sum(margin)
from [Sales analysis ] -- 21438067.902579  will be used as reference to calculate revenue contribution in %  ( total profit / 21438067.902579) * 100 


select  category, count( order_id) as num_of_purchases,  sum(margin) as total_profit 
into dbo.sales_by_category
from [Sales analysis ]
group by category
order by total_profit desc  --creating table sales by category

alter table sales_by_category
add revenue_contribution_percent float

update sales_by_category
set revenue_contribution_percent = (  total_profit / 21438067.902579) * 100 
                                                     
select *
from sales_by_category 
-- HIGHEST Sports category has revenue contribution of 25.10 % 
-- LOWEST Clothing lowest 24.95 %
---------------------------------------------------------------------------------------------------------------------------
                                                   
												 ----which city has the most transactions and contribution to revenue ? 

select purchase_city ,  count(order_id) as total_purchases, sum( cost_price ) as total_expenses, sum(margin) as total_sales
into dbo.total_purchase_by_city -- creating table purchase_by_city
from [Sales analysis ]
group by purchase_city
order by total_purchases desc

alter table total_purchase_by_city
add  revenue_contribution_percent_by_city float

 
 update total_purchase_by_city
 set revenue_contribution_percent_by_city =  ( total_sales / 21438067.902579) * 100

select *
from total_purchase_by_city
order by revenue_contribution_percent_by_city desc
-- San Francisco has the highest number of transaction and highest revenue contribution of 23.10 % 
-- Austin lowest transaction count and contribution of 5.26 %
-- In the same time San Francisco has the highest total expeses as it relevant to the number of products sold 
-----------------------------------------------------------------------------------------------------------------------------------



                                                              --Which products made the most and least revenue before expnses ? 

  -- Which product has the highest profit before expenses ? 
  select product, sum(turnover ) as total_profit_before_expenses
  into dbo.profit_by_product_before_expenses -- creating table profit by product before expenses 
  from [Sales analysis ]
  group by product

  select sum(total_profit_before_expenses)
  from profit_by_product_before_expenses -- 34492035.7974904
  
   alter table profit_by_product_before_expenses
  add percent_of_profit_before_exp float

  update profit_by_product_before_expenses
  set percent_of_profit_before_exp = (total_profit_before_expenses / 34492035.7974904 ) * 100

  select *
  from profit_by_product_before_expenses
  order by percent_of_profit_before_exp desc
  -- HIGHEST  Macbook Pro Laptop - 8037600  which is 23.2 % of total profit before expenses 
  -- LOWEST AAA Batteries (4-pack) - 92740 which is 0.2 % of total profit before expenses 
 -------------------------------------------------------------------------------------------------------------


                                                                         --Which products has the highest and lowest expenses ? 

select product, sum(cost_price) as total_expenses
into dbo.total_expenses_by_product -- adding new table total expenses by product 
from [Sales analysis ]
group by product


select sum(cost_price) 
from [Sales analysis ] -- 12954872.931231

alter table total_expenses_by_product
add percent_of_total_expenses float

update total_expenses_by_product
set percent_of_total_expenses =  ( total_expenses / 12954872.931231 ) * 100


select *
from total_expenses_by_product
order by percent_of_total_expenses desc
-- HIGHEST  Macbook Pro Laptop - 2650164 or 20.3 % of total expenses 
-- LOWEST AAA Batteries (4-pack) - 30858.295098424 or  0.23 % of total expenses 
---------------------------------------------------------------------------------------------------------------------

                                                                             -- Which product has the highest and lowest margin 

select product, sum(margin) as profit_after_expenses
into dbo.total_profit_by_product_after_exp -- new table total profit by product after expenses 
from [Sales analysis ]
group by product


select sum(margin) 
from [Sales analysis ] -- 21438067.902579

alter table total_profit_by_product_after_exp
add percent_of_totl_profit_after_exp float


update total_profit_by_product_after_exp
set percent_of_totl_profit_after_exp =  ( profit_after_expenses / 21438067.902579 ) * 100

select *
from total_profit_by_product_after_exp
order by percent_of_totl_profit_after_exp desc
-- HIGHEST  Macbook Pro Laptop - 5385192 or 25.1 % of total profit after expenses
-- LOWEST AAA Batteries (4-pack)  46370 or 0.21 % of total profit after expenses
-----------------------------------------------------------------------------------------------------------------------


                                                                                                --Summary 

-- Most of the sales falls into  quarter 4 ( October - December ) which is  33.4 % of total sales 
-- Quarter 1 has the lowest of 19.78 %  of total sales 

-- December as most proffitable 13.8 % of total profit
-- January as least 5.2 % of total profit 

-- Tuesday tent to be most proffitable
-- Thursday tend to be least proffitable  

-- San Francisco has the highest number of transaction and highest revenue contribution of 23.10 %  of total profit
-- Austin lowest transaction count and contribution of 5.26 % of total profit




                                                                                 -- Category and product overview

-- HIGHEST Sports category has revenue contribution of 25.10 % of total profit
-- LOWEST Clothing lowest 24.95 % of total profit 

-- HIGHEST  Macbook Pro Laptop - 8037600  which is 23.2 % of total profit before expenses 
-- LOWEST AAA Batteries (4-pack) - 92740 which is 0.2 % of total profit before expenses 

-- HIGHEST  Macbook Pro Laptop - 2650164 or 20.3 % of total expenses 
-- LOWEST AAA Batteries (4-pack) - 30858.295098424 or  0.23 % of total expenses 

-- HIGHEST  Macbook Pro Laptop - 5385192 or 25.1 % of total profit after expenses
-- LOWEST AAA Batteries (4-pack)  46370 or 0.21 % of total profit after expenses
