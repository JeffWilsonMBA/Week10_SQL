## Question 1a

use sakila;

SELECT first_name, last_name
FROM actor;

## Question 1b

SELECT first_name, last_name
	,CONCAT(first_name, last_name) AS full_name
FROM actor;

## Question 2a

SELECT actor_id, first_name, last_name
FROM actor
  WHERE first_name IN ('Joe');

## Questions 2b

SELECT actor_id, first_name, last_name
FROM actor
  WHERE last_name LIKE ('%GEN%');

## Question 2c

SELECT last_name, first_name
FROM actor
  WHERE last_name LIKE ('%LI%');

## Question 2d

SELECT country_id, country
FROM country
  WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
  
## Question 3a add column middle_name between first_name and last_name

ALTER TABLE actor
    ADD middle_name varchar(50);
ALTER TABLE actor MODIFY middle_name varchar(50) AFTER first_name;
SELECT * FROM actor LIMIT 1;

## Question 3b - change datatype to blobs

ALTER TABLE actor MODIFY middle_name BLOB(100);ALTER TABLE actor MODIFY middle_name BLOB(100);

## Question 3c - drop column

ALTER TABLE actor
DROP COLUMN middle_name;
SELECT * FROM actor LIMIT 1;

## Questions 4a - List last names of actors and how many actors have the same last name

SELECT last_name, COUNT(*) AS unique_count
FROM actor
WHERE last_name IS NOT NULL
GROUP BY last_name;

## Questions 4b - Show last names that are in the table more than once

SELECT last_name, COUNT(*) AS unique_count
FROM actor
WHERE last_name IS NOT NULL
GROUP BY last_name
HAVING count(*) > 1;

## Question 4c - Change Groucho to Harpo

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'GROUCHO' 
  AND last_name = 'WILLIAMS';
UPDATE actor 
	SET first_name = 'HARPO'
WHERE actor_id = 172;
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id = '172'; 

## Question 4c - Change Groucho to Harpo

SELECT actor_id, first_name, last_name FROM actor WHERE actor_id = '172';
UPDATE actor 
	SET first_name = 'GROUCHO'
WHERE actor_id = 172;
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id = '172' 

## Question 5a - Create address table (commented out)

DESCRIBE address;

# CREATE TABLE address (
#  address_id smallint(5) AUTO_INCREMENT NOT NULL,
#  address VARCHAR(50) NOT NULL,
#  address2 VARCHAR(50),
#  district VARCHAR(20) NOT NULL,
#  city_id smallint(5) NOT NULL,
#  postal_code varchar(10),
#  phone varchar(20) NOT NULL,
#  location VARCHAR(30) NOT NULL,
#  last_update TIMESTAMP NOT NULL,
#  PRIMARY KEY (address_id),
#  FOREIGN KEY (city_id) REFERENCES city(city_id) 
# );

## Question 6a - join staff and adress to display first and last names and addresses of staff

SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;

## Question 6b - Display the total amount rung up by each staff member in August of 2005

SELECT s.first_name, s.last_name, p.payment_date, sum(p.amount)
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '2005-08%'
GROUP BY s.staff_id;

## Question 6c - List each film and the number of actors in each film

SELECT f.title, count(fa.actor_id)
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title;

## Question 6d - Number of copies of 'Hunchback Immpossible' in inventory

SELECT f.title, count(i.inventory_id)
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

## Questions 6e - Total paid by customer

SELECT c.first_name, c.last_name, sum(p.amount)
FROM customer c
JOIN payment p
on c.customer_id = p.customer_id
GROUP BY c.last_name
ORDER BY c.last_name;

## Question 7a - All movies that start with either Q or K in English

SELECT f.title, l.name
FROM film f
JOIN language l
ON f.language_id = l.language_id
WHERE (l.name = 'English') AND (f.title LIKE 'Q%' OR f.title LIKE 'K%');

## Question 7b - All actors in 'Alone Trip'

SELECT f.title, a.first_name, a.last_name
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
WHERE f.title = 'Alone Trip';

## Question 7c - Names and email addresses of all Canadaian customers

SELECT c.first_name, c.last_name, c.email, co.country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

## Question 7d - All films categorized as family

SELECT f.title, cat.name
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category cat
ON fc.category_id = cat.category_id
WHERE cat.name = 'Family';

## Question 7e - The most frequesntly rented movies in decending order

SELECT f.title, COUNT(p.payment_id)
FROM payment p
JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY COUNT(p.payment_id) DESC;

## Question 7f - Sales by store

SELECT store.store_id, sum(p.amount)
FROM payment p
JOIN staff 
ON p.staff_id = staff.staff_id
JOIN store
ON staff.store_id = store.store_id
GROUP BY store.store_id;

## Question 7g - Store ID, city, and country

SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city c
ON c.city_id = a.city_id
JOIN country co
ON c.country_id = co.country_id;

## Question 7h - Top 5 genres by revenue

SELECT cat.name, SUM(p.amount)
FROM payment p
JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category fc
ON i.film_id = fc.film_id
JOIN category cat
ON cat.category_id = fc.category_id
GROUP BY cat.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

## Question 8a - Create view top_five_genres from 7h above

CREATE 
VIEW `sakila`.`top_five_genres` AS
    SELECT 
        `cat`.`name` AS `name`, SUM(`p`.`amount`) AS `SUM(p.amount)`
    FROM
        ((((`sakila`.`payment` `p`
        JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
        JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `sakila`.`film_category` `fc` ON ((`i`.`film_id` = `fc`.`film_id`)))
        JOIN `sakila`.`category` `cat` ON ((`cat`.`category_id` = `fc`.`category_id`)))
    GROUP BY `cat`.`name`
    ORDER BY SUM(`p`.`amount`) DESC
    LIMIT 5
   ; 

## Question 8b - Run top_five_genres view

SELECT * FROM top_five_genres;

## Question 8c - Drop top_five_genres view

Drop view top_five_genres;
