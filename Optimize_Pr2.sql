-- Bad Example
USE my_opt_db;

EXPLAIN
SELECT
    (SELECT CONCAT(product_name, ": ", cnt)
     FROM (SELECT product_name, COUNT(*) AS cnt
           FROM (SELECT o.order_id, o.order_date, p.product_id, p.product_name, c.first_name
                 FROM my_orders o
                 JOIN my_products p ON o.product_id = p.product_id
                 JOIN my_clients c ON o.client_id = c.client_id
                 WHERE o.order_date > '2023-01-01') AS sub1
           GROUP BY product_name) AS sub2
     WHERE cnt = (SELECT MIN(cnt)
                  FROM (SELECT COUNT(*) AS cnt
                        FROM (SELECT o.order_id, o.order_date, p.product_id, p.product_name, c.first_name
                              FROM my_orders o
                              JOIN my_products p ON o.product_id = p.product_id
                              JOIN my_clients c ON o.client_id = c.client_id
                              WHERE o.order_date > '2023-01-01') AS sub3
                        GROUP BY product_name) AS sub4)
     LIMIT 1) AS min_cnt,

    (SELECT CONCAT(product_name, ": ", cnt)
     FROM (SELECT product_name, COUNT(*) AS cnt
           FROM (SELECT o.order_id, o.order_date, p.product_id, p.product_name, c.first_name
                 FROM my_orders o
                 JOIN my_products p ON o.product_id = p.product_id
                 JOIN my_clients c ON o.client_id = c.client_id
                 WHERE o.order_date > '2023-01-01') AS sub1
           GROUP BY product_name) AS sub2
     WHERE cnt = (SELECT MAX(cnt)
                  FROM (SELECT COUNT(*) AS cnt
                        FROM (SELECT o.order_id, o.order_date, p.product_id, p.product_name, c.first_name
                              FROM my_orders o
                              JOIN my_products p ON o.product_id = p.product_id
                              JOIN my_clients c ON o.client_id = c.client_id
                              WHERE o.order_date > '2023-01-01') AS sub3
                        GROUP BY product_name) AS sub4)
     LIMIT 1) AS max_cnt;
-- Good Example

CREATE INDEX idx_my_orders_order_date ON my_orders(order_date);

EXPLAIN
WITH cte AS (
    SELECT o.order_id, o.order_date, p.product_id, p.product_name, c.first_name
    FROM my_orders o
    JOIN my_products p ON o.product_id = p.product_id
    JOIN my_clients c ON o.client_id = c.client_id
    WHERE o.order_date > '2023-01-01'
),
cnt_products AS (
    SELECT product_name, COUNT(*) AS cnt
    FROM cte
    GROUP BY product_name
)

SELECT
    (SELECT CONCAT(product_name, ": ", cnt) 
     FROM cnt_products 
     WHERE cnt = (SELECT MIN(cnt) FROM cnt_products) 
     LIMIT 1) AS min_cnt,

    (SELECT CONCAT(product_name, ": ", cnt) 
     FROM cnt_products 
     WHERE cnt = (SELECT MAX(cnt) FROM cnt_products) 
     LIMIT 1) AS max_cnt;
