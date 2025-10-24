--Output the number of movies in each category, sorted descending.

select c.name, count (fc.film_id)
from category c
left join film_category fc using(category_id)
group by c.name
order by count (fc.film_id) desc;


--Output the 10 actors whose movies rented the most, sorted in descending order.

SELECT a.first_name||' '||a.last_name as actor_name, 
        count(r.rental_id)
from actor as a
join film_actor as fa USING(actor_id)
join film as f using(film_id)
join inventory as i using(film_id)
join rental as r using(inventory_id)
group by actor_name
order by count(r.rental_id) desc
limit 10;

--Output the category of movies on which the most money was spent.

SELECT c.name as film_categoty, 
        sum(amount)
from category as c
join film_category as fc USING(category_id)
join film as f using(film_id)
join inventory as i using(film_id)
join rental as r using(inventory_id)
join payment as p using(rental_id)
group by c.name
order by sum(amount) desc
limit 1;

--Print the names of movies that are not in the inventory. Write a query without using the IN operator.

select * from
(select film_id, title, inventory_id from film
left join inventory using(film_id))
where inventory_id is NULL

--Output the top 3 actors who have appeared the most in movies in the “Children” category. If several actors have the same number of movies, output all of them.

SELECT a.first_name||' '||a.last_name as actor_name, 
        count(a.actor_id), c.name
from actor as a
join film_actor as fa USING(actor_id)
join film_category as fc using(film_id)
join category as c using(category_id)
where c.name='Children'
group by actor_name, c.name
order by  count(a.actor_id) desc
limit 3;


--Output cities with the number of active and inactive customers (active - customer.active = 1). Sort by the number of inactive customers in descending order.

select city,
count(case active
			when 1 then 1 end) as active_customer,
count(case active
			when 0 then 1 end) as inactive_customer
from city as ci
join address a using (city_id)
join customer c using (address_id)
group by city
order by inactive_customer desc


--Output the category of movies that have the highest number of total rental hours in the city (customer.address_id in this city) and that start with the letter “a”. Do the same for cities that have a “-” in them. Write everything in one query.

select c.name, city,
max(round(Extract(epoch from return_date-rental_date)/3600, 2)) as hours
from category c
join film_category using (category_id)
join film using (film_id)
join inventory using (film_id)
join rental using (inventory_id)
join customer using (customer_id)
join address using (address_id)
join city using (city_id)
where city like 'A%'
group by c.name, city

union

select c.name, city,
max(round(Extract(epoch from return_date-rental_date)/3600, 2)) as hours
from category c
join film_category using (category_id)
join film using (film_id)
join inventory using (film_id)
join rental using (inventory_id)
join customer using (customer_id)
join address using (address_id)
join city using (city_id)
where city like '%-%'
group by c.name, city