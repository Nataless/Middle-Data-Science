--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

select film_id, title, special_features
from film 
where special_features && array['Behind the Scenes']



--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select film_id, title, special_features
from film 
where special_features::text like '%Behind the Scenes%' 


select film_id, title, array_agg(unnest) as special_features
from (
	select title, unnest(special_features), film_id
	from film) t 
where unnest = 'Behind the Scenes'
group by film_id, title


--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

with cte as (
	select film_id, title, special_features
	from film 
	where special_features && array['Behind the Scenes']
)
select c.customer_id, count(cte.film_id) as film_count
from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join cte on cte.film_id = i.film_id 
group by c.customer_id
order by c.customer_id 




--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

select r.customer_id, count(f.film_id) as film_count
from (select film_id, title, special_features
	from film 
	where special_features && array['Behind the Scenes']) f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
group by r.customer_id
order by r.customer_id 



--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view task_5 as
	select r.customer_id, count(f.film_id) as film_count
	from (select film_id, title, special_features
		from film 
		where special_features && array['Behind the Scenes']) f
	left join inventory i on f.film_id = i.film_id
	left join rental r on i.inventory_id = r.inventory_id
	group by r.customer_id
	order by r.customer_id


refresh materialized view task_5

--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания: 
--поиск значения в массиве затрачивает меньше ресурсов системы;
C оператором special_features (задание 1)

--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.
С использованием CTE (задание 3)




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день





