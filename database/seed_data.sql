-- ============================================================
-- WatchHub Seed Data
-- Run AFTER schema.sql. Gives teammates realistic test data.
-- Note: password_hash values below are placeholders, not real
-- bcrypt hashes -- swap in real hashed passwords once auth is wired up.
-- ============================================================

USE watchhub;

-- ------------------------------------------------------------
-- users  (id 1 = admin, id 2-5 = regular shoppers)
-- ------------------------------------------------------------
INSERT INTO users (name, email, password_hash, role, address) VALUES
('Admin User',   'admin@watchhub.com',   '$2b$12$placeholderadminhash', 'admin', '1 Aptech Way, Lagos'),
('Chidinma Eze', 'chidinma@example.com', '$2b$12$placeholderhash0001',  'user',  '12 Allen Ave, Lagos'),
('Tunde Bakare', 'tunde@example.com',    '$2b$12$placeholderhash0002',  'user',  '45 Ring Road, Ibadan'),
('Amara Obi',    'amara@example.com',    '$2b$12$placeholderhash0003',  'user',  '9 Marina St, Lagos'),
('Segun Alao',   'segun@example.com',    '$2b$12$placeholderhash0004',  'user',  '3 GRA, Enugu');

-- ------------------------------------------------------------
-- watches
-- ------------------------------------------------------------
INSERT INTO watches (name, brand, type, price, stock, description, images) VALUES
('Rolex Submariner Date',   'Rolex',    'Analog',     8500.00, 5,  'Iconic diving watch with date function and ceramic bezel.', 'rolex_sub_1.jpg,rolex_sub_2.jpg'),
('Omega Seamaster 300',     'Omega',    'Analog',     5200.00, 8,  'Classic dive watch, water resistant to 300m.',              'omega_seamaster_1.jpg'),
('Casio G-Shock GA-2100',   'Casio',    'Digital',    99.99,   40, 'Shock-resistant sports watch, carbon core guard.',          'gshock_1.jpg,gshock_2.jpg'),
('Apple Watch Series 10',   'Apple',    'Smartwatch', 399.00,  25, 'Latest generation smartwatch with health tracking.',        'apple_watch_1.jpg'),
('Seiko 5 Sports SRPD',     'Seiko',    'Analog',     250.00,  20, 'Automatic movement, affordable everyday watch.',            'seiko5_1.jpg'),
('Fossil Gen 6',            'Fossil',   'Smartwatch', 229.00,  15, 'Wear OS smartwatch with fitness tracking.',                 'fossil_gen6_1.jpg'),
('Tag Heuer Carrera',       'Tag Heuer','Analog',     4300.00, 3,  'Chronograph racing watch with sapphire crystal.',           'tagheuer_carrera_1.jpg'),
('Garmin Fenix 7',          'Garmin',   'Smartwatch', 699.00,  10, 'Rugged multisport GPS smartwatch.',                         'garmin_fenix7_1.jpg'),
('Citizen Eco-Drive',       'Citizen',  'Analog',     180.00,  30, 'Solar-powered, never needs a battery.',                     'citizen_ecodrive_1.jpg'),
('Timex Weekender',         'Timex',    'Analog',     45.00,   50, 'Simple, affordable everyday casual watch.',                 'timex_weekender_1.jpg');

-- ------------------------------------------------------------
-- orders + order_items
-- Order 1: Chidinma bought a Casio + Seiko (delivered)
-- Order 2: Tunde bought an Apple Watch (shipped)
-- ------------------------------------------------------------
INSERT INTO orders (user_id, total, status) VALUES
(2, 349.99, 'delivered'),
(3, 399.00, 'shipped');

INSERT INTO order_items (order_id, watch_id, quantity, price) VALUES
(1, 3, 1, 99.99),   -- Casio G-Shock
(1, 5, 1, 250.00),  -- Seiko 5 Sports
(2, 4, 1, 399.00);  -- Apple Watch

-- ------------------------------------------------------------
-- cart  (items currently sitting in carts, not yet ordered)
-- ------------------------------------------------------------
INSERT INTO cart (user_id, watch_id, quantity) VALUES
(4, 6, 1),   -- Amara: Fossil Gen 6
(4, 9, 2),   -- Amara: 2x Citizen Eco-Drive
(5, 1, 1);   -- Segun: Rolex Submariner (dreaming big)

-- ------------------------------------------------------------
-- wishlist
-- ------------------------------------------------------------
INSERT INTO wishlist (user_id, watch_id) VALUES
(2, 1),  -- Chidinma wishes for the Rolex
(2, 7),  -- Chidinma wishes for the Tag Heuer
(3, 8);  -- Tunde wishes for the Garmin Fenix

-- ------------------------------------------------------------
-- reviews
-- ------------------------------------------------------------
INSERT INTO reviews (user_id, watch_id, rating, comment, flagged) VALUES
(2, 3, 5, 'Tough as nails, exactly what I needed for the gym.', FALSE),
(2, 5, 4, 'Great value automatic watch, slightly loose strap.', FALSE),
(3, 4, 5, 'Battery life is better than I expected.', FALSE),
(4, 9, 3, 'Solid but the face is smaller than it looks in photos.', FALSE),
(5, 1, 1, 'This is spam, buy watches at fakelink dot com', TRUE);
