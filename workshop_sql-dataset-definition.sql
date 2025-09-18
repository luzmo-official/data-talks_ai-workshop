SELECT
  po.*,
  -- Case statement to map sales codes into meaningful labels
  CASE 
      WHEN po.sales_code = 'S001' THEN 'No discount'
      WHEN po.sales_code = 'S020' THEN 'Vendor discount'
      WHEN po.sales_code = 'S500' THEN 'End-of-day discount'
      ELSE 'Other / Unknown'
  END AS sales_code_description,
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
JOIN stores s ON po.store_id = s.store_id