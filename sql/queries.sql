USE brewery;

INSERT INTO sale_lines (sale_id,line_no,lot_id,qty,unit_price)
SELECT 
  (SELECT s.sale_id 
     FROM sales s JOIN customers c ON s.customer_id=c.customer_id
    WHERE c.name='Mike Johnson'
    ORDER BY s.sale_date DESC LIMIT 1) AS sale_id,
  1,
  (SELECT fl.lot_id FROM finished_lots fl WHERE fl.lot_code='LOT-BK-01' LIMIT 1),
  2,
  20.00
ON DUPLICATE KEY UPDATE
  qty=VALUES(qty), unit_price=VALUES(unit_price), lot_id=VALUES(lot_id);

INSERT INTO sale_lines (sale_id,line_no,lot_id,qty,unit_price)
SELECT 
  (SELECT s.sale_id 
     FROM sales s JOIN customers c ON s.customer_id=c.customer_id
    WHERE c.name='Jessica Rivera'
    ORDER BY s.sale_date DESC LIMIT 1),
  1,
  (SELECT fl.lot_id FROM finished_lots fl WHERE fl.lot_code='LOT-BP-01' LIMIT 1),
  1,
  25.00
ON DUPLICATE KEY UPDATE
  qty=VALUES(qty), unit_price=VALUES(unit_price), lot_id=VALUES(lot_id);

INSERT INTO sale_lines (sale_id,line_no,lot_id,qty,unit_price)
SELECT 
  (SELECT s.sale_id 
     FROM sales s JOIN customers c ON s.customer_id=c.customer_id
    WHERE c.name='Kevin O''Brien'
    ORDER BY s.sale_date DESC LIMIT 1),
  1,
  (SELECT fl.lot_id FROM finished_lots fl WHERE fl.lot_code='LOT-SP-01' LIMIT 1),
  20,
  10.00
ON DUPLICATE KEY UPDATE
  qty=VALUES(qty), unit_price=VALUES(unit_price), lot_id=VALUES(lot_id);

INSERT INTO sale_lines (sale_id,line_no,lot_id,qty,unit_price)
SELECT 
  (SELECT s.sale_id 
     FROM sales s JOIN customers c ON s.customer_id=c.customer_id
    WHERE c.name='Brooklyn Beer Hall'
    ORDER BY s.sale_date DESC LIMIT 1),
  1,
  (SELECT fl.lot_id FROM finished_lots fl WHERE fl.lot_code='LOT-OH-01' LIMIT 1),
  35,
  10.00
ON DUPLICATE KEY UPDATE
  qty=VALUES(qty), unit_price=VALUES(unit_price), lot_id=VALUES(lot_id);

INSERT INTO sale_lines (sale_id,line_no,lot_id,qty,unit_price)
SELECT 
  (SELECT s.sale_id 
     FROM sales s JOIN customers c ON s.customer_id=c.customer_id
    WHERE c.name='Queens Deli & Bar'
    ORDER BY s.sale_date DESC LIMIT 1),
  1,
  (SELECT fl.lot_id FROM finished_lots fl WHERE fl.lot_code='LOT-RP-01' LIMIT 1),
  6,
  25.00
ON DUPLICATE KEY UPDATE
  qty=VALUES(qty), unit_price=VALUES(unit_price), lot_id=VALUES(lot_id);
SELECT c.name AS customer, SUM(sl.qty * sl.unit_price) AS total_spent
FROM sale_lines sl
JOIN sales s     ON sl.sale_id = s.sale_id
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;
SELECT DATE(sale_date) AS day, channel, SUM(total) AS revenue
FROM sales
GROUP BY DATE(sale_date), channel
ORDER BY day DESC, channel;
SELECT b.name AS beer, fl.package_type, fl.lot_code, fl.qty_on_hand
FROM finished_lots fl
JOIN batches ba         ON fl.batch_id = ba.batch_id
JOIN recipe_versions rv ON ba.recipe_id = rv.recipe_id
JOIN beers b            ON rv.beer_id = b.beer_id
ORDER BY b.name, fl.package_type, fl.lot_code;
SELECT b.name AS beer, SUM(sl.qty) AS units_sold
FROM sale_lines sl
JOIN finished_lots fl ON sl.lot_id = fl.lot_id
JOIN batches ba       ON fl.batch_id = ba.batch_id
JOIN recipe_versions rv ON ba.recipe_id = rv.recipe_id
JOIN beers b            ON rv.beer_id = b.beer_id
GROUP BY b.name
ORDER BY units_sold DESC, b.name;
