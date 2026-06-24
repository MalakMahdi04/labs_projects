-- # Joins
-- 
-- This file contains several exercises on joins. These topics are a step more involved and confusing than in the previous two files.
-- * [Tutorial on Joins](https://www.sqlitetutorial.net/sqlite-join/)
-- 
-- Here are a few other important notes I'd like you read before beginning:
-- * Make sure you read each question thoroughly.
-- * Don't skip problems, as some problems may rely on previous problems being done correctly.
-- * Make sure you are saving your answers as you go, as some answers will simply be reworkings of previous answers.
-- * A View is a virtual table that represents the result of a stored SELECT query. Unlike a physical table, it does not store data, but it can be queried like a table.
-- 
-- ## Joins
-- 
-- 62) Which employee made which sale? Join the `employees` table onto the `transactions` table by `employee_id`. You only need to include the employee's first/last name from `employees`.
select employees.firstname, employees.lastname, transactions.*
from transactions
inner join employees
on transactions.employee_id = employees.id

-- 63) What is the name of the employee who made the most in sales? Find this answer by doing a join as in the previous problem. Your resulting query will be difficult for someone else to read.
select employees.firstname, employees.lastname, transactions.*, sum(unit_price * quantity) as total_revenue
from transactions
inner join employees
on transactions.employee_id = employees.id
order by total_revenue desc 
limit 1 
-- The employee who made the most sales is Christopher Carlson

-- 64) Solve the previous problem by joining `employees` onto the `trans_by_employee` view.
select employees.firstname, employees.lastname, trans_by_employee.*
from trans_by_employee
inner join employees
on trans_by_employee.employee_id = employees.id

-- 65) Next, the company will try to give bonuses based on performance. Show all employees who've made more in sales than 1.5 times their salary.
select employees.firstname, employees.lastname, transactions.*, sum(unit_price * quantity) as total_revenue,
case 
	when sum(unit_price * quantity) > 1.5* employees.salary then "Yes"
	else "No"
end as bonus
from employees
inner join transactions
on transactions.employee_id = employees.id

-- 66) Do we have potentially erroneous rows? Find all transactions which occurred _before_ the employee was even hired! (Make sure each transaction only occupies one row).
select transactions.*, employees.firstname, employees.lastname, employees.startdate
from transactions
inner join employees
	on transactions.employee_id = employees.id 
where transactions.orderdate < employees.startdate

-- 67) Among all transactions that occurred from 2015 to 2019, create a table that is the monthly revenue of our company versus the total trading volume of Yum! in that month. Format the columns nicely. (Hint: look at the views) That is, a sample row of your result might look like this:
-- 
-- ```
-- | year | month | company_revenue | yum_trade_volume |
-- |------|-------|-----------------|------------------|
-- | 2017 |    03 |        $100,000 |      125,000,000 |
-- ```
-- 
-- * _Hint:_ You don't need any `WHERE` statements here. You can get the right answer simply by changing what kind of join you do!
select 
	strftime("%Y", trans.orderdate) as year, 
	strftime("%m", trans.orderdate) as month, 
	yum_by_month.tot_volume as yum_trade_volume,
	sum(trans.unit_price * trans.quantity) as company_revenue
from transactions as trans
LEFT JOIN yum_by_month
on strftime("%Y", trans.orderdate) = yum_by_month.year and strftime("%m", trans.orderdate) = yum_by_month.month 
where year between "2015" and "2019"
group by yum_by_month.year, yum_by_month.month