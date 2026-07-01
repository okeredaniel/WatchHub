-- ============================================================
-- WatchHub Database Schema
-- Owner: Boluwatife
-- Engine: MySQL 8+ (InnoDB, utf8mb4)
-- ============================================================

DROP DATABASE IF EXISTS watchhub;
CREATE DATABASE watchhub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE watchhub;

-- ------------------------------------------------------------
-- users
-- Stores account info for both shoppers and admins.
-- ------------------------------------------------------------
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    address       VARCHAR(255),
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- watches
-- The product catalog.
-- ------------------------------------------------------------
CREATE TABLE watches (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    brand       VARCHAR(100) NOT NULL,
    type        VARCHAR(50)  NOT NULL,          -- e.g. Analog, Digital, Smartwatch
    price       DECIMAL(10,2) NOT NULL,
    stock       INT NOT NULL DEFAULT 0,
    description TEXT,
    images      TEXT,                            -- comma-separated image URLs
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_brand (brand),
    INDEX idx_type (type),
    INDEX idx_price (price)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- orders
-- One row per checkout.
-- ------------------------------------------------------------
CREATE TABLE orders (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    total      DECIMAL(10,2) NOT NULL,
    status     ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled')
               NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_order_user (user_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- order_items
-- Line items within an order. price is captured at purchase
-- time so later price changes on `watches` don't rewrite history.
-- ------------------------------------------------------------
CREATE TABLE order_items (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    watch_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE RESTRICT,
    INDEX idx_oi_order (order_id),
    INDEX idx_oi_watch (watch_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- cart
-- Active, unpurchased items per user. One row per (user, watch).
-- ------------------------------------------------------------
CREATE TABLE cart (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL,
    watch_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_cart_user_watch (user_id, watch_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- wishlist
-- Saved-for-later items. One row per (user, watch).
-- ------------------------------------------------------------
CREATE TABLE wishlist (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL,
    watch_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_wishlist_user_watch (user_id, watch_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- reviews
-- Ratings/comments on watches. `flagged` supports moderation
-- from the admin panel.
-- ------------------------------------------------------------
CREATE TABLE reviews (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    watch_id   INT NOT NULL,
    rating     TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT,
    flagged    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE,
    INDEX idx_reviews_watch (watch_id)
) ENGINE=InnoDB;
