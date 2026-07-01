-- ============================================================
-- WatchHub Reusable Queries
-- Grouped by feature. `?` = parameterized placeholder --
-- swap for your backend framework's param syntax as needed.
-- ============================================================


-- ============================================================
-- AUTH
-- ============================================================

-- Register a new user
INSERT INTO users (name, email, password_hash, address)
VALUES (?, ?, ?, ?);

-- Look up user by email for login
SELECT id, name, email, password_hash, role
FROM users
WHERE email = ?;

-- Update password (password recovery)
UPDATE users
SET password_hash = ?
WHERE email = ?;


-- ============================================================
-- BROWSE / SEARCH WATCHES
-- ============================================================

-- List all watches (paginated)
SELECT id, name, brand, type, price, stock, images
FROM watches
ORDER BY created_at DESC
LIMIT ? OFFSET ?;

-- Filter by brand, type, and price range, sorted dynamically
-- (build the ORDER BY / WHERE clauses in code based on active filters)
SELECT id, name, brand, type, price, stock, images
FROM watches
WHERE (? IS NULL OR brand = ?)
  AND (? IS NULL OR type = ?)
  AND price BETWEEN ? AND ?
ORDER BY price ASC;

-- Search by keyword (name or brand)
SELECT id, name, brand, type, price, stock, images
FROM watches
WHERE name LIKE CONCAT('%', ?, '%')
   OR brand LIKE CONCAT('%', ?, '%');

-- Sort by popularity (most ordered watches)
SELECT w.id, w.name, w.brand, COUNT(oi.id) AS times_ordered
FROM watches w
LEFT JOIN order_items oi ON oi.watch_id = w.id
GROUP BY w.id
ORDER BY times_ordered DESC;

-- Get full product detail page for one watch
SELECT id, name, brand, type, price, stock, description, images
FROM watches
WHERE id = ?;


-- ============================================================
-- CART
-- ============================================================

-- Add item to cart (increment quantity if it already exists)
INSERT INTO cart (user_id, watch_id, quantity)
VALUES (?, ?, ?)
ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity);

-- Update quantity for a specific cart item
UPDATE cart
SET quantity = ?
WHERE user_id = ? AND watch_id = ?;

-- Remove one item from cart
DELETE FROM cart
WHERE user_id = ? AND watch_id = ?;

-- Clear entire cart (e.g. after checkout)
DELETE FROM cart
WHERE user_id = ?;

-- Get cart contents with line totals + cart total
SELECT c.watch_id, w.name, w.price, c.quantity,
       (w.price * c.quantity) AS line_total
FROM cart c
JOIN watches w ON w.id = c.watch_id
WHERE c.user_id = ?;


-- ============================================================
-- WISHLIST
-- ============================================================

-- Add to wishlist
INSERT IGNORE INTO wishlist (user_id, watch_id)
VALUES (?, ?);

-- Remove from wishlist
DELETE FROM wishlist
WHERE user_id = ? AND watch_id = ?;

-- List wishlist items
SELECT w.id, w.name, w.brand, w.price, w.images
FROM wishlist wl
JOIN watches w ON w.id = wl.watch_id
WHERE wl.user_id = ?;

-- Move a wishlist item into the cart
START TRANSACTION;
INSERT INTO cart (user_id, watch_id, quantity)
VALUES (?, ?, 1)
ON DUPLICATE KEY UPDATE quantity = quantity + 1;
DELETE FROM wishlist WHERE user_id = ? AND watch_id = ?;
COMMIT;


-- ============================================================
-- ORDERS
-- ============================================================

-- Create an order (checkout step 1)
INSERT INTO orders (user_id, total, status)
VALUES (?, ?, 'pending');

-- Add each cart item as an order_item (checkout step 2, repeat per item)
INSERT INTO order_items (order_id, watch_id, quantity, price)
VALUES (?, ?, ?, ?);

-- Decrement stock after order is placed
UPDATE watches
SET stock = stock - ?
WHERE id = ? AND stock >= ?;

-- Order history for a user
SELECT id, total, status, created_at
FROM orders
WHERE user_id = ?
ORDER BY created_at DESC;

-- Order tracking / detail view (order + its line items)
SELECT o.id AS order_id, o.status, o.total, o.created_at,
       oi.watch_id, w.name, oi.quantity, oi.price
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN watches w ON w.id = oi.watch_id
WHERE o.id = ? AND o.user_id = ?;

-- Admin: update order status
UPDATE orders
SET status = ?
WHERE id = ?;


-- ============================================================
-- REVIEWS & RATINGS
-- ============================================================

-- Add a review
INSERT INTO reviews (user_id, watch_id, rating, comment)
VALUES (?, ?, ?, ?);

-- List reviews for a watch, sorted by newest
SELECT r.id, u.name AS reviewer, r.rating, r.comment, r.created_at
FROM reviews r
JOIN users u ON u.id = r.user_id
WHERE r.watch_id = ? AND r.flagged = FALSE
ORDER BY r.created_at DESC;

-- List reviews sorted by helpfulness (highest rating first, as a proxy)
SELECT r.id, u.name AS reviewer, r.rating, r.comment, r.created_at
FROM reviews r
JOIN users u ON u.id = r.user_id
WHERE r.watch_id = ? AND r.flagged = FALSE
ORDER BY r.rating DESC, r.created_at DESC;

-- Average rating for a watch (for product detail page)
SELECT ROUND(AVG(rating), 1) AS avg_rating, COUNT(*) AS review_count
FROM reviews
WHERE watch_id = ? AND flagged = FALSE;

-- Flag a review (user-reported issue)
UPDATE reviews
SET flagged = TRUE
WHERE id = ?;


-- ============================================================
-- ADMIN PANEL
-- ============================================================

-- List all users (admin user management)
SELECT id, name, email, role, created_at
FROM users
ORDER BY created_at DESC;

-- List all orders across all users
SELECT o.id, u.name AS customer, o.total, o.status, o.created_at
FROM orders o
JOIN users u ON u.id = o.user_id
ORDER BY o.created_at DESC;

-- Add a new watch to the catalog
INSERT INTO watches (name, brand, type, price, stock, description, images)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- Update a watch's details
UPDATE watches
SET name = ?, brand = ?, type = ?, price = ?, stock = ?, description = ?
WHERE id = ?;

-- Delete a watch (blocked if it has order history, since order_items
-- uses ON DELETE RESTRICT -- this is intentional, to protect order records)
DELETE FROM watches
WHERE id = ?;

-- View flagged reviews for moderation
SELECT r.id, u.name AS reviewer, w.name AS watch, r.rating, r.comment, r.created_at
FROM reviews r
JOIN users u ON u.id = r.user_id
JOIN watches w ON w.id = r.watch_id
WHERE r.flagged = TRUE
ORDER BY r.created_at DESC;
