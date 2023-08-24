select
    customer_id,
    first_name,
    last_name

from {{ source('linux_pl', 'customer') }}