-- # The Basics
-- 
-- ## Simple SELECTs
-- 1) Query all the data in the `pets` table.  
select *
from pets
-- 2) Query only the first 5 rows of the `pets` table.
SELECT *
FROM pets
LIMIT 5
-- 3) Query only the names and ages of the pets in the `pets` table.
select name, age
from pets
-- 4) Query the pets in the `pets` table, sorted youngest to oldest.
select *
from pets 
order by age ASC
-- 5) Query the pets in the `pets` table alphabetically.
select *
from pets 
order by name ASC
-- 6) Query all the male pets in the `pets` table.
select *
from pets 
where sex = 'M'
-- 7) Query all the cats in the `pets` table.
select *
from pets 
where species = 'cat'
-- 8) Query all the pets in the `pets` table that are at least 5 years old.
select *
from pets 
where age >= 5
-- 9) Query all the male dogs in the `pets` table. Do not include the sex or species column, since you already know them.
select name, age
from pets 
where species = 'dog' and sex = 'M'
-- 10) Get all the names of the dogs in the `pets` table that are younger than 5 years old.
select name
from pets
where age < 5
-- 11) Query all the pets in the `pets` table that are either male dogs or female cats.
select *
from  pets 
where sex = 'M' or 'F'
-- 12) Query the five oldest pets in the `pets` table.
select *
from pets 
order by age DESC
limit 5
-- 13) Get the names and ages of all the female cats in the `pets` table sorted by age, descending.
select name, age
from pets 
where sex = 'F' 
order by age DESC
-- 14) Get all pets from `pets` whose names start with P.
select *
from pets
where lower(name) like 'p%'
-- 15) Select all employees from `employees_null` where the salary is missing.
select *
from employees_null
where salary is NULL
-- 16) Select all employees from `employees_null` where the salary is below $35,000 or missing.
select *
from employees_null
where salary IS NULL OR salary < 35000 

-- 17) Select all employees from `employees_null` where the job title is missing. What do you see?
select *
from employees_null
where job is null 
--  The employee ID is 101, first and last name are unknown, job and start date are 'NULL', and salary is -1


-- 18) Who is the newest employee in `employees`? The most senior?
select *
from employees
order by startdate DESC

select *
from employees
order by startdate ASC
limit 1
--  The newest employee is Roger Conner who started on 24-05-2019
-- The most senior employee is Mary Nash.
 
-- 19) Select all employees from `employees` named Thomas.
select *
from employees
where lower(firstname) like 'thomas' 
-- 20) Select all employees from `employees` named Thomas or Shannon.
select *
from employees 
where lower(firstname) like 'thomas' or lower(firstname) like 'shannon'
-- 21) Select all employees from `employees` named Robert, Lisa, or any name that begins with a J. In addition, only show employees who are _not_ in sales. This will be a little bit of a longer query.
--     * _Hint:_ There will only be 6 rows in the result.
select *
from employees 
where 
	(lower(firstname) in ( 'robert' or 'lisa')
	or lower(firstname) like 'j%')
	and job != 'Sales'

-- 	## Column Operations
-- 22) Query the top 5 rows of the `employees` table to get a glimpse of these new data.
select *
from employees
limit 5

-- 23) Query the `employees` table, but convert their salaries to Euros. 
--     * _Hint:_ 1 Euro = 1.1 USD.
--     * _Hint2:_ If you think the output is ugly, try out the `ROUND()` function.
select *, round(salary /1.1 ,2)
from employees

-- 24) Repeat the previous problem, but rename the column `salary_eu`.
select *, round(salary *1.1 ,2) as salary_eu
from employees
-- 25) Query the `employees` table, but combine the `firstname` and `lastname` columns to be "Firstname, Lastname" format. Call this column `fullname`. For example, the first row should contain `Thompson, Christine` as `fullname`. Also, display the rounded `salary_eu` instead of `salary`.
--     * _Hint:_ The string concatenation operator is `||`
select lastname||','|| firstname as fullname, round(salary *1.1 ,2) as salary_eu
from employees 

-- 26) Query the `employees` table, but replace `startdate` with `startyear` using the `SUBSTR()` function. Also include `fullname` and `salary_eu`.
select lastname ||','|| firstname as fullname, round(salary *1.1 ,2) as salary_eu, substr(startdate,4) as startyear
from employees

-- 27) Repeat the above problem, but instead of using `SUBSTR()`, use `STRFTIME()`.
select lastname ||','|| firstname as fullname, round(salary *1.1 ,2) as salary_eu, strftime('%Y-%m-%d', 'now') as startyear
from employees

-- 28) Query the `employees` table, replacing `firstname`/`lastname` with `fullname` and `startdate` with `startyear`. 
-- Print out the salary in USD again, except format it with a dollar sign, comma separators, and no decimal. For example, the first row should read `$123,696`. This column should still be named `salary`.
--     * _Hint:_ Check out SQLite's `printf` function.
--     * _Hint2:_ The format string you'll need is `$%,.2d`. You should read more about such formatting strings as they're useful in Python, too!
select lastname ||','|| firstname as fullname, 
	strftime('%Y-%m-%d', 'now') as startyear, 
	format('$%,d', salary) AS salary
from employees

-- 
-- **Note:** For the next few problems, you'll probably want to use `CASE`/`WHEN` statements.
-- 
-- 29) Last year, only salespeople were eligible for bonuses. Create a column `bonus` that is "Yes" if you're eligible for a bonus, otherwise "No".
select *,
case 
	when job = 'Sales' then "Yes"
	else "No"
	end as bonuses
from employees

-- 30) This year, only sales people with a salary of $100,000 or higher are eligible for bonuses. Create a `bonus` column like in the last problem for salespeople with salaries at least $100,000.
select *, format('$%,d', salary) AS salary,
case 
	when job = 'Sales' and salary >= 100000 then "Yes"
	else "No"
	end as bonus
from employees

-- 31) Next year, the bonus structure will be a little more complicated. You'll create a `target_comp` column which represents an employee's target total compensation after their bonus. Here is the company's bonus structure:
-- 
-- * Salespeople who make more than $100,000 will be eligible for a 10% bonus.
-- * Salespeople who make less than $100,000 will be eligible for a 5% bonus.
-- * Administrators will also be eligible for a 5% bonus.
-- * Anyone who does not meet any of the above descriptions is not eligible for a bonus.
-- 
-- Create this `target_comp` column, making sure to format _both_ the `salary` and `target_comp` columns nicely (ie, with dollar signs and comma separators).

select*, format('$%,d', salary) AS salary, 	
CASE
        WHEN salary > 100000 THEN format('$%,d', salary * 1.10)
        WHEN salary < 100000 THEN format('$%,d', salary * 1.05)
        WHEN job = 'Administrator' THEN format('$%,d', salary * 1.05)
        ELSE format('$%,d', salary)
    END AS target_comp
FROM employees	