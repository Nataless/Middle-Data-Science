select customer_id, payment_id, payment_date, row_number() over (order by payment_date) as "Фильтр по дате",
	row_number() over (partition by customer_id order by payment_date) as "Фильтр по клиенту и дате",
	sum(p.amount) over (partition by p.customer_id order by p.payment_date, p.amount asc) as "Сумма",
	dense_rank() over (partition by p.customer_id order by amount desc)
from payment p
order by customer_id, dense_rank