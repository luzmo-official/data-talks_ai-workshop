DROP table IF EXISTS product_orders;
DROP table IF EXISTS products;
DROP table IF EXISTS customers;
DROP table IF EXISTS stores;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'luzmo_readonly_user') THEN
        ALTER DEFAULT PRIVILEGES IN SCHEMA public 
        REVOKE SELECT ON TABLES FROM luzmo_readonly_user;
        REVOKE USAGE ON SCHEMA public FROM luzmo_readonly_user;
        REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM luzmo_readonly_user;
        DROP ROLE luzmo_readonly_user;
    END IF;
END
$$;


/*
----------------------------
----------------------------
-- Create database schema --
----------------------------
----------------------------
*/

/* Dimension table: products */
CREATE TABLE products (
    product_id BIGSERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    product_category TEXT,
    product_release_date DATE
);

/* Dimension table: customers */
CREATE TABLE customers (
    customer_id BIGSERIAL PRIMARY KEY,
    customer_first_name TEXT NOT NULL,
    customer_last_name TEXT NOT NULL,
    customer_email TEXT UNIQUE NOT NULL,
    customer_date_of_birth DATE
);

/* Dimension table: stores */
CREATE TABLE stores (
    store_id BIGSERIAL PRIMARY KEY,
    store_name TEXT NOT NULL,
    store_country TEXT NOT NULL
);

/* Fact table: product_orders */
CREATE TABLE product_orders (
    order_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customers(customer_id) ON DELETE SET NULL,
    product_id BIGINT REFERENCES products(product_id) ON DELETE SET NULL,
    store_id BIGINT REFERENCES stores(store_id) ON DELETE SET NULL,
    quantity INT NOT NULL,
    total_amount NUMERIC(12,2),
    total_cost NUMERIC(12,2),
    sales_code TEXT NOT NULL,
    expected_delivery_date DATE,
    order_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

/* Indexes for faster joins/queries */
CREATE INDEX idx_orders_customer ON product_orders(customer_id);
CREATE INDEX idx_orders_product ON product_orders(product_id);
CREATE INDEX idx_orders_store ON product_orders(store_id);


/*
----------------------------
----------------------------
--    Insert mock data    --
----------------------------
----------------------------
*/

-- Updated products with 6 categories and more specific names
INSERT INTO products (product_name, product_category, product_release_date) VALUES
  -- Food & Beverages
  ('Organic Carrots', 'Food & Beverages', '2023-05-10'),
  ('Fresh Apples', 'Food & Beverages', '2023-06-01'),
  ('Ripe Bananas', 'Food & Beverages', '2023-06-05'),
  ('Premium Orange Juice', 'Food & Beverages', '2022-11-15'),
  ('Green Tea Leaves', 'Food & Beverages', '2022-08-05'),
  ('Arabica Coffee Beans', 'Food & Beverages', '2022-07-20'),
  ('Basmati Rice', 'Food & Beverages', '2022-03-10'),
  ('Whole Wheat Pasta', 'Food & Beverages', '2022-04-12'),
  ('Fresh Milk', 'Food & Beverages', '2023-01-25'),
  ('Aged Cheddar Cheese', 'Food & Beverages', '2023-02-14'),
  ('Greek Yogurt', 'Food & Beverages', '2023-03-02'),
  ('Artisan Bread Loaf', 'Food & Beverages', '2023-01-05'),
  ('Buttery Croissant', 'Food & Beverages', '2023-01-07'),
  ('Cherry Tomatoes', 'Food & Beverages', '2023-06-11'),
  ('Sweet Onions', 'Food & Beverages', '2023-06-15'),
  ('Extra Virgin Olive Oil', 'Food & Beverages', '2022-12-01'),
  
  -- Snacks & Treats
  ('Sea Salt Potato Chips', 'Snacks & Treats', '2023-04-15'),
  ('Dark Chocolate Bar', 'Snacks & Treats', '2023-03-20'),
  ('Mixed Nuts', 'Snacks & Treats', '2023-02-28'),
  ('Granola Bars', 'Snacks & Treats', '2023-01-15'),
  ('Popcorn Kernels', 'Snacks & Treats', '2022-12-10'),
  
  -- Electronics
  ('iPhone 15 Pro', 'Electronics', '2022-11-25'),
  ('MacBook Air M2', 'Electronics', '2023-02-10'),
  ('Wireless Headphones', 'Electronics', '2023-04-18'),
  ('Smart Watch', 'Electronics', '2023-03-05'),
  ('Tablet Computer', 'Electronics', '2022-10-15'),
  
  -- Clothing & Accessories
  ('Cotton T-Shirt', 'Clothing & Accessories', '2022-05-21'),
  ('Running Sneakers', 'Clothing & Accessories', '2023-03-12'),
  ('Denim Jeans', 'Clothing & Accessories', '2022-08-30'),
  ('Winter Jacket', 'Clothing & Accessories', '2022-11-01'),
  ('Leather Belt', 'Clothing & Accessories', '2023-01-20'),
  
  -- Health & Beauty
  ('Mint Toothpaste', 'Health & Beauty', '2022-09-18'),
  ('Moisturizing Shampoo', 'Health & Beauty', '2022-10-02'),
  ('Face Cream', 'Health & Beauty', '2023-02-14'),
  ('Vitamin Supplements', 'Health & Beauty', '2022-12-05'),
  ('Hand Sanitizer', 'Health & Beauty', '2023-01-10'),
  
  -- Home & Garden
  ('LED Light Bulbs', 'Home & Garden', '2022-07-15'),
  ('Kitchen Towels', 'Home & Garden', '2023-03-01'),
  ('Plant Seeds', 'Home & Garden', '2023-04-20'),
  ('Cleaning Spray', 'Home & Garden', '2022-11-10'),
  ('Storage Baskets', 'Home & Garden', '2023-02-25');

-- Expanded customers
INSERT INTO customers (customer_first_name, customer_last_name, customer_email, customer_date_of_birth) VALUES
  ('Alice', 'Smith', 'alice.smith@example.com', '1990-02-15'),
  ('Bob', 'Johnson', 'bob.johnson@example.com', '1985-09-22'),
  ('Charlie', 'Lee', 'charlie.lee@example.com', '1995-12-05'),
  ('Diana', 'Martinez', 'diana.martinez@example.com', '1992-07-18'),
  ('Ethan', 'Brown', 'ethan.brown@example.com', '1988-11-30'),
  ('Fiona', 'Davis', 'fiona.davis@example.com', '1993-01-10'),
  ('George', 'Wilson', 'george.wilson@example.com', '1979-06-25'),
  ('Hannah', 'Miller', 'hannah.miller@example.com', '2000-03-05'),
  ('Ian', 'Taylor', 'ian.taylor@example.com', '1998-04-14'),
  ('Julia', 'Anderson', 'julia.anderson@example.com', '1991-09-08'),
  ('Kevin', 'Thomas', 'kevin.thomas@example.com', '1987-02-27'),
  ('Laura', 'Moore', 'laura.moore@example.com', '1996-12-21'),
  ('Michael', 'White', 'michael.white@example.com', '1994-05-02'),
  ('Nina', 'Clark', 'nina.clark@example.com', '1989-08-19'),
  ('Oscar', 'Hall', 'oscar.hall@example.com', '1982-01-11'),
  ('Paula', 'Allen', 'paula.allen@example.com', '1997-10-23'),
  ('Quentin', 'Young', 'quentin.young@example.com', '1990-07-29'),
  ('Rachel', 'Hernandez', 'rachel.hernandez@example.com', '1992-04-06'),
  ('Sam', 'King', 'sam.king@example.com', '1984-12-09'),
  ('Tina', 'Wright', 'tina.wright@example.com', '1999-11-17');

-- Updated stores - generic but fun names across more countries
INSERT INTO stores (store_name, store_country) VALUES
  ('Happy Mart', 'USA'),
  ('Sunny Store', 'USA'),
  ('Quick Stop', 'USA'),
  ('Mega Market', 'Canada'),
  ('Maple Leaf', 'Canada'),
  ('Royal Store', 'United Kingdom'),
  ('Thames Market', 'United Kingdom'),
  ('Eiffel Tower', 'France'),
  ('Champs Store', 'France'),
  ('Bavarian Market', 'Germany'),
  ('Sakura Store', 'Japan'),
  ('Tokyo Central', 'Japan'),
  ('Tango Mart', 'Argentina'),
  ('Buenos Aires', 'Argentina');


-- Generate realistic daily orders from Jan 2024 to current date
-- Each day has 0-15 random orders
WITH daily_orders AS (
  SELECT 
    date_series.order_date,
    -- Random number of orders per day (0-15)
    (random() * 15)::int AS daily_order_count
  FROM (
    SELECT generate_series(
      DATE '2024-01-01', 
      CURRENT_DATE, 
      INTERVAL '1 day'
    )::date AS order_date
  ) date_series
),
order_details AS (
  SELECT 
    daily_orders.order_date,
    daily_orders.daily_order_count,
    -- Generate individual orders for each day
    generate_series(1, GREATEST(daily_orders.daily_order_count, 1)) AS order_num
  FROM daily_orders
  WHERE daily_orders.daily_order_count > 0
)
INSERT INTO product_orders (
  customer_id,
  product_id,
  store_id,
  quantity,
  total_amount,
  total_cost,
  sales_code,
  expected_delivery_date,
  order_timestamp
)
SELECT
  -- Random customer (1-20)
  (random() * 19 + 1)::int AS customer_id,
  -- Random product (1-40, since we now have 40 products)
  (random() * 39 + 1)::int AS product_id,
  -- Random store (1-14, since we now have 14 stores)
  (random() * 13 + 1)::int AS store_id,
  -- Random quantity (1-10)
  (random() * 9 + 1)::int AS quantity,
  -- Random pricing based on product and quantity
  ROUND(((random() * 50 + 5) * ((random() * 9 + 1)::int))::numeric, 2) AS total_amount,
  ROUND(((random() * 30 + 3) * ((random() * 9 + 1)::int))::numeric, 2) AS total_cost,
  -- Random sales codes
  CASE (random() * 4)::int
    WHEN 0 THEN 'S001'
    WHEN 1 THEN 'S020'
    WHEN 2 THEN 'S500'
    ELSE 'S900'
  END AS sales_code,
  -- Delivery date 3-7 days after order
  od.order_date + (random() * 4 + 3)::int AS expected_delivery_date,
  -- Random time during the day
  od.order_date + make_time(
    FLOOR(random() * 24)::int, 
    FLOOR(random() * 60)::int, 
    FLOOR(random() * 60)::int
  ) AS order_timestamp
FROM order_details od
ORDER BY od.order_date, od.order_num;

/*
------------------------------
------------------------------
-- Set up read-only db user --
------------------------------
------------------------------
*/

/* replace 'luzmo_readonly_user' and 'SuperSecretPassword123' with your own */
CREATE USER luzmo_readonly_user WITH PASSWORD 'SuperSecretPassword123';

/* grant usage on public schema */
GRANT USAGE ON SCHEMA public TO luzmo_readonly_user;

/* grant SELECT privileges on all tables in the 'public' schema */
/* IMPORTANT NOTE: 
    This will give access to all tables in the public schema. 
    If necessary, adapt it to only grant access to the tables you want to expose.
*/
GRANT SELECT ON ALL TABLES IN SCHEMA public TO luzmo_readonly_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO luzmo_readonly_user;


/*
-- Query to create a "denormalized" view on top of the fact and dimension tables
-- This will be used to create a SQL dataset in Luzmo: https://academy.luzmo.com/article/78zgjjfs

SELECT
  po.*,
  c.customer_first_name,
  c.customer_last_name,
  c.customer_email,
  c.customer_date_of_birth,
  p.product_name,
  p.product_category,
  p.product_release_date,
  s.store_name,
  s.store_country
FROM product_orders po
JOIN customers c ON po.customer_id = c.customer_id
JOIN products p ON po.product_id = p.product_id
JOIN stores s ON po.store_id = s.store_id;

*/