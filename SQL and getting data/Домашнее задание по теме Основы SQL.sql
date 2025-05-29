--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.


select concat(c.last_name,' ', c.first_name) as "Customer name", a."address", ci."city", co."country"
from customer c
join address a on a.address_id = c.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.


select s.store_id as "ID магазина", count(c.customer_id) as "Количество покупателей"
from store s 
join customer c on c.store_id = s.store_id
group by s.store_id


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select s.store_id as "ID магазина", count(c.customer_id) as "Количество покупателей"
from store s 
join customer c on c.store_id = s.store_id
group by s.store_id
having count(c.customer_id) > 300



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select s.store_id, count(c.customer_id) as "Количество покупателей",  ci.city as "Город", concat(st.last_name, ' ', st.first_name) as "Имя сотрудника"
from store s 
join customer c on c.store_id = s.store_id
join address a on a.address_id = s.address_id
join city ci on ci.city_id = a.city_id
join staff st on st.store_id = s.store_id
group by s.store_id, ci.city_id, st.staff_id 
having count(c.customer_id) > 300



--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select  concat(c.last_name, ' ', c.first_name) as "Фамилия и имя покупателя", count(r.rental_id) as "Количество фильмов"
from customer c 
join rental r on r.customer_id = c.customer_id
group by c.customer_id
order by count(rental_id) desc
limit 5



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select concat(c.last_name, ' ', c.first_name) as "Фамилия и имя покупателя", count(r.rental_id) as "Количество фильмов", round(sum(p.amount)) as "Общая стоимость платежей", 
min(p.amount) as "Минимальная стоимость платежа", max(p.amount) as "Максимальная стоимость платежа"
from customer c 
join rental r on r.customer_id = c.customer_id
join payment p on r.customer_id =  p.customer_id and p.rental_id = r.rental_id 
group by c.customer_id




--ЗАДАНИЕ №5
--Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы 
--в результате не было пар с одинаковыми названиями городов. Решение должно быть через Декартово произведение.
 

select c.city as "Город 1", c1.city as " Город 2"
from city c
cross join city c1
where c.city != c1.city


--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и 
--дате возврата (поле return_date), вычислите для каждого покупателя среднее количество 
--дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.
 
select r.customer_id as "ID покупателя", round(avg(date_part('day', return_date - rental_date::date))::numeric, 2) as "Среднее количество дней на возврат"
from rental r
group by r.customer_id
order by r.customer_id



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.





--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью него фильмы, которые отсутствуют на dvd дисках.





--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".








