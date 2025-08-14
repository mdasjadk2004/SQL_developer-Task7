# SQL_developer-Task7
This project demonstrates how to create and use SQL Views in Oracle SQL Developer for data abstraction, reusability, and security.
We have used three datasets:

users.csv — contains user profile and join date details.
posts.csv — contains user posts with hashtags and post dates.
interactions.csv — contains likes, comments, and shares for posts.

The main objective was to:
Combine multiple tables with JOINs and filters.
Create complex, reusable SQL logic as Views.
Use aggregation to summarise data (counts of likes, comments, shares).
Show how views can also be used to limit sensitive data exposure.

Steps Performed
1. Importing Data
Imported users.csv, posts.csv, and interactions.csv into Oracle SQL Developer tables:
users, posts, interactions.

2. Understanding Tables vs. Views
Table: Stores actual data permanently in rows and columns.

View: A virtual table based on the result of a SELECT query. It doesn’t store data itself, but fetches from base tables each time it is queried.

3. Writing Complex SELECT Queries
Used INNER JOIN and LEFT JOIN between:
users → posts (author information)
posts → interactions (engagement data)
Applied filters (e.g., posts from 2024 onwards).
Implemented GROUP BY and CASE WHEN for aggregation.

4. Creating Views
We built multiple views such as:

a) post_engagement_summary
Summarises per post:
Like count
Comment count
Share count

Total interactions
b) active_users_last30
Shows only users who posted or interacted in the last 30 days, with counts.
c) hashtag_post_count
Splits comma-separated hashtags and counts how many posts use each hashtag.
d) public_user_profile
Displays public details (hiding sensitive counts) to demonstrate view-based security.
5. Using Views
Queried views like normal tables:
