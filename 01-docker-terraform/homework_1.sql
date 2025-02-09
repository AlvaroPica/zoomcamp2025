

-- Question 3

with distances_bins as (
	select	
		case
			when trip_distance <= 1 then 'up_to_1'
			when trip_distance <= 3 then 'btw_1_to_3'
			when trip_distance <= 7 then 'btw_3_to_7'
			when trip_distance <= 10 then 'btw_7_to_10'
			else 'over_10'
		end as distance_bins
	from  homework_green_tripdata 
	where tpep_pickup_datetime >= '2019-01-01' 
	and tpep_pickup_datetime  < '2019-11-01'
)

select
	distance_bins,
	count(1)
from distances_bins
group by distance_bins
order by 2 desc;

-- Question 4

with longest_per_date as (

	select 
		tpep_pickup_datetime::date as trip_date,
		max(trip_distance) as max_date_distance
	from homework_green_tripdata hgt 
	group by 1
	
)

select 
	*
from longest_per_date
order by max_date_distance desc


-- Question 5

with top_location as (
	select
		hgt."PULocationID",
		z."Zone",
		hgt.total_amount
	from homework_green_tripdata hgt 
	left join zones z
		on z."LocationID" = hgt."PULocationID"
	where tpep_pickup_datetime::date = '2019-10-18' 
		and total_amount > 13.000
)
select
	"Zone", 
	count(total_amount) 
from top_location
group by 1 order by 2 desc


-- Question 6

with pickup_location_data as (
	select
		hgt.*,
		pu_z."Zone" as pickup_zone,
		drop_z."Zone" as drop_zone,
		row_number(*) over (order by tip_amount desc) as n_rank
	from homework_green_tripdata hgt 
	left join zones pu_z
		on pu_z."LocationID" = hgt."PULocationID"
	left join zones drop_z
		on drop_z."LocationID" = hgt."DOLocationID"
	where date_trunc('month',tpep_pickup_datetime)::date = '2019-10-01' 
		and pu_z."Zone" = 'East Harlem North'
)

select * from pickup_location_data
where n_rank <= 5
order by n_rank asc 