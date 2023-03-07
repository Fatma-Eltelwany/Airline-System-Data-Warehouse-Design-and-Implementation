--1
--What is the total profit?
select sum(profit) total_profit from reservation_fact;
--2
--What is the total profit for the year 2011?
select  years, sum(profit) total_profit from reservation_fact
join dates on reservation_date = date_id
where years = '2011'
group by years;
--3
--What is the distribution of frequent flyers over service classes?
select  service_class_id,  count(distinct passenger_id) passenger_count from freq_flyer_fact
group by  service_class_id 
order by passenger_count desc;
--4
--What is the number of frequent flyers who upgraded their class?
select count(distinct passenger_id) from freq_flyer_fact
where upgrade_date is not null;
--5
--What is the percentage of frequent flyers who respond to promotions?
select round((select count(distinct passenger_id) 
from freq_flyer_fact
where promotion is not null and response_to_promotion = 1)*100/(select count(distinct passenger_id) 
from freq_flyer_fact
where promotion is not null and response_to_promotion = 0)) ||'%' as response_pct from dual;
--6
-- How many frequent flyers filed a complaint?
select count(distinct c.passenger_id) complaints_count from customer_care_fact c
join passengers p on c.passenger_id = p.passenger_id
where interaction_id=2 and freq_flyer = 1;
--7
--What is the average time interval taken to respond to interactions?
select round(avg((resolution_date - contact_date)))||' days' average_resolution 
from customer_care_fact;
--8
-- Partition the flights into short flights and long flights.
select flight_id, case when  flight_miles > (select avg(flight_miles) from flight_fact)
then 'long flight'
else 'short flight'
end flight_type from flight_fact
order by flight_type;