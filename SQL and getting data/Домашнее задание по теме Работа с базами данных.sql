--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.

select distinct city from city c 



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.

select distinct city from city c 
where city like 'L%a' and city not like '% %'
order by city asc  




--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.

select payment_id, payment_date, amount 
from payment p 
where payment_date::date between '17-06-2005' and '19-06-2005'
and amount > 1.00
order by payment_date asc  



--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.


select payment_id, payment_date, amount 
from payment p 
order by payment_date desc limit 10


--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.

select last_name ||' '||first_name as "Фамилия и имя", email as "Электронная почта", length (email) as "Длина Email", last_update::date as "Дата"
from customer c 


--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.

select Lower (last_name) as "last_name", Lower (first_name) as "first_name", active
from customer c 
where (first_name like 'KELLY') or (first_name like 'WILLIE') and active = 1



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите информацию о фильмах, у которых рейтинг “R” и стоимость аренды указана от 
--0.00 до 3.00 включительно, а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.

select film_id, title, description, rating, rental_rate
from film f 
where (rating='R'and rental_rate between '0.00' and '3.00') or (rating='PG-13'and rental_rate>='4.00')
order by film_id asc  



--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.

select film_id, title, description 
from film f  
order by length (description) desc limit 3 



--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.

1 вариант:
select customer_id, email,
	split_part(email, '@', 1) "Email before @",
       split_part(email, '@', 2) "Email after @"
from customer c  

2 вариант:
select left (email, position('@' IN email)-1) as "Email before @",
		right(email, char_length(email)-position('@' IN email))  as "Email after @"
from customer c  



--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква строки должна быть заглавной, остальные строчными.

select	concat(upper(left(left(email, position('@' in email)-1), 1)), 
		lower(substring(left(email, position('@' in email)-1), 2, length(left(email, position('@' in email)-1))-1)))  as "Email before @",
		concat(upper(left(left(email, char_length(email)-position('@' in email)), 1)), 
		lower(substring(left(email, char_length(email)-position('@' in email)), 2, length(right(email, char_length(email)-position('@' in email)))-1)))  as "Email after @"
from customer



