select rating, row_number() over (order by title) as "Номер по порядку", title, min (title) over (partition by rating order by rating) as "Первое название фильма", max (title) over (partition by rating order by rating) as "Последнее название фильма"
from film
order by rating, title