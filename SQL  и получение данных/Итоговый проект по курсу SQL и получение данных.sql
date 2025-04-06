1. Сколько суммарно каждый тип самолета провел в воздухе, если брать завершенные перелеты.

select *
from (select q1.model, sum (age(q1.actual_arrival, q1.actual_departure)) over (partition by q1.model order by q1.model) as "Суммарная продолжительность"
from (select a.aircraft_code, a.model, f.status, f.actual_departure, f.actual_arrival, age (f.actual_arrival, f.actual_departure) as "Время в полете"
from aircrafts a 
join flights f on f.aircraft_code  = a.aircraft_code
where status = 'Arrived'
group by 1, 2, 3, 4, 5, 6) q1 
group by q1.model, q1.actual_arrival, q1.actual_departure) q2
group by 1,2
order by 1 asc

2. Сколько было получено посадочных талонов по каждой брони
select q1.book_ref as "Брони", count (q1.boarding_no) as "Посадочные талоны (количество)"
from
(select bp.ticket_no, bp.boarding_no, t.book_ref
from boarding_passes bp 
join tickets t on t.ticket_no = bp.ticket_no 
group by 1, 2, 3) q1
group by q1.boarding_no, q1.book_ref 

3. Вывести общую сумму продаж по каждому классу билетов
select "Класс обслуживания",  "Стоимость продаж"
from 
(select fare_conditions as "Класс обслуживания", sum (tf.amount) over (partition by fare_conditions) as "Стоимость продаж"
from ticket_flights tf 
group by 1, tf.amount) q1
group by "Класс обслуживания", "Стоимость продаж"
order by "Стоимость продаж" desc
4. Найти маршрут с наибольшим финансовым оборотом
select q1.flight_no, q1.amount
from (select r.flight_no, r.departure_airport, r.departure_city, r.arrival_airport, r.departure_city, tf.flight_id, tf.amount 
from routes r 
join flights f on f.flight_no =r.flight_no
join ticket_flights tf on tf.flight_id = f.flight_id
group by 1, 2, 3, 4, 5, 6, 7 
order by amount desc) q1
group by 1, 2
order by amount desc limit 2
5. Найти наилучший и наихудший месяц по бронированию билетов (количество и сумма)
select q1.m, count (q1.ticket_no) as quantity, sum (q1.amount) as monthly_sum
from (select date_trunc('month', b.book_date) as m, t.ticket_no, amount
from ticket_flights tf 
join tickets t on t.ticket_no = tf.ticket_no
join bookings b on b.book_ref=t.book_ref 
group by 1, 2, 3
order by 1) q1
group by 1
order by quantity desc limit 1

6. Между какими городами пассажиры не делали пересадки? Пересадкой считается нахождение пассажира в промежуточном аэропорту менее 24 часов.

with cte_bp3 as (with cte_bp2 as 
(with cte_bp as (select ticket_no, count (*) 
from ticket_flights tf 
group by 1
having count (*) > 1
order by 2 desc) 
select ticket_no, flight_id
from cte_bp
join boarding_passes using (ticket_no))
select ticket_no, flight_id, departure_airport, departure_city, arrival_airport, arrival_city, actual_departure, actual_arrival
from cte_bp2
join flights_v using (flight_id))
select distinct departure_city, arrival_city
from cte_bp3
where actual_arrival - actual_departure < interval '24 hour'

