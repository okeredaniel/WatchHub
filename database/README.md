WatchHub Database
Owned by: Bolu
Engine: MySQL 8+
Setup (local)
Make sure MySQL is installed and running.
From this folder, run:
```bash
   mysql -u root -p < schema.sql
   mysql -u root -p watchhub < seed_data.sql
   ```
`schema.sql` creates the `watchhub` database and all tables from scratch
(it drops any existing `watchhub` database first, so don't run it against
a database you care about).
To try out the example queries, open `queries.sql` in a MySQL client
(MySQL Workbench, DBeaver, or `mysql` CLI) and run individual statements —
they're grouped by feature with comments.
Tables
Table	Purpose
`users`	Accounts for shoppers and admins (`role` column)
`watches`	Product catalogue
`orders`	One row per checkout
`order_items`	Line items belonging to an order
`cart`	Items currently in a user's cart (not yet ordered)
`wishlist`	Items a user has saved for later
`reviews`	Ratings/comments on watches, with a `flagged` column for moderation
Full column list and types are in `schema.sql` — every column has a comment
where its purpose isn't obvious from the name.
Notes for teammates
Auth: `password_hash` should store a bcrypt (or similar) hash, never
plaintext. The seed data uses placeholder strings — don't use those as
real test logins.
Admin access: seed data includes one admin account —
`admin@watchhub.com` (`role = 'admin'`). Use this to test the admin panel.
Prices: stored as `DECIMAL(10,2)`, not float, to avoid rounding
errors on money.
order_items.price: this is the price at the time of purchase, copied
from `watches.price`. Don't join to `watches.price` for historical order
totals — use `order_items.price` instead, since catalogue prices can change
after an order is placed.
Deleting a watch: blocked by a foreign key (`ON DELETE RESTRICT`) if
it has any order history, so past orders never lose their referenced
product. You can delete a watch that's never been ordered.
cart/wishlist uniqueness: each is constrained to one row per
`(user_id, watch_id)` pair — adding an already-carted item should
increment quantity, not insert a duplicate row (see `queries.sql`'s
`ON DUPLICATE KEY UPDATE` example).
Questions?
Contact me, or check `queries.sql` first, most "how do I get X"
questions about the data are already answered there.
