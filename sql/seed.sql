USE brewery;

-- Customers
INSERT INTO customers(name,type,phone) VALUES
('Mike Johnson','TAPROOM','917-555-1234'),
('Jessica Rivera','TAPROOM','718-555-2345'),
('Kevin O''Brien','WHOLESALE','212-555-3456'),
('Brooklyn Beer Hall','WHOLESALE','347-555-4567'),
('Queens Deli & Bar','WHOLESALE','646-555-5678');

-- Beers
INSERT INTO beers(name,style,abv_target,ibu_target) VALUES
('Brooklyn Lager','Lager',5.2,30),
('Blue Point Toasted Lager','Lager',5.5,28),
('Sixpoint Resin','IPA',9.1,103),
('Other Half Green City IPA','IPA',7.0,60),
('River Pale Ale','APA',5.5,35);

-- Recipe versions (one per beer)
INSERT IGNORE INTO recipe_versions(beer_id,version_no,created_on)
SELECT beer_id,1,'2025-09-01' FROM beers;

-- Batches
INSERT INTO batches(recipe_id,start_date,status)
SELECT recipe_id,'2025-09-10','READY' FROM recipe_versions;

-- Finished lots
INSERT INTO finished_lots(batch_id,package_type,pack_date,qty_on_hand,lot_code)
SELECT batch_id,'KEG','2025-09-15',25,CONCAT('LOT-',batch_id)
FROM batches;

-- Sales
INSERT INTO sales(customer_id,sale_date,channel,subtotal,tax,total) VALUES
(1,NOW(),'TAPROOM',40.00,3.50,43.50),
(2,NOW(),'TAPROOM',25.00,2.19,27.19),
(3,NOW(),'WHOLESALE',200.00,17.50,217.50),
(4,NOW(),'WHOLESALE',350.00,30.62,380.62),
(5,NOW(),'WHOLESALE',150.00,13.12,163.12);

-- Sale lines
INSERT INTO sale_lines(sale_id,line_no,lot_id,qty,unit_price) VALUES
(1,1,1,2,20.00),
(2,1,2,1,25.00),
(3,1,3,20,10.00),
(4,1,4,35,10.00),
(5,1,5,6,25.00);
