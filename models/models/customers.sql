{{
  config(
    materialized='view'
  )
}}

with customers as (

	select
        customer_id,
        first_name,
        last_name

    from postgres.target_public.customer

),

rentals as(

    select
        rental_id,
        customer_id,
        rental_date

    from postgres.target_public.rental

),

customer_rentals as (

    select
        customer_id,

        min(rental_date) as first_rental_date,
        max(rental_date) as most_recent_rental_date,
        count(rental_id) as number_of_rentals

    from rentals

    group by 1
	
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_rentals.first_rental_date,
        customer_rentals.most_recent_rental_date,
        coalesce(customer_rentals.number_of_rentals, 0) as number_of_rentals

    from customers

    left join customer_rentals using (customer_id)
	
)

select * from final
order by customer_id