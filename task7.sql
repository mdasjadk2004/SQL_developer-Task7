--complext select with joins------------------------------------
SELECT
  u.user_id,
  u.username,
  u.full_name,
  p.post_id,
  p.content,
  p.post_date,
  p.hashtags,
  i.interaction_type,
  i.interaction_date
FROM users u
JOIN posts p ON u.user_id = p.user_id
LEFT JOIN interactions i ON p.post_id = i.post_id
WHERE p.post_date >= TO_DATE('2024-01-01', 'YYYY-MM-DD')
ORDER BY p.post_date DESC;
------------------------------------------------------------------
SELECT
  u.user_id,
  u.username,
  u.full_name,
  p.post_id,
  p.content,
  p.post_date,
  p.hashtags,
  i.interaction_type,
  i.interaction_date
FROM users u
JOIN posts p ON u.user_id = p.user_id
LEFT JOIN interactions i ON p.post_id = i.post_id
WHERE p.post_date >= TO_DATE('2024-01-01', 'YYYY-MM-DD')
ORDER BY p.post_date DESC
/
------------------------------------------------------------------------------
SELECT * FROM user_post_interactions WHERE username LIKE 'kelly%';
------------------------------------------------------------------------------
SELECT view_name
FROM user_views
WHERE view_name = 'USER_POST_INTERACTIONS';
------------------------------------------------------------------------------
SELECT *
FROM user_post_interactions
FETCH FIRST 10 ROWS ONLY;
----------View for Active Users (Last 30 Days)-------------------------------
CREATE OR REPLACE VIEW active_users_last30 AS
SELECT
    u.user_id,
    u.username,
    u.full_name,
    u.join_date,
    COUNT(DISTINCT p.post_id) AS posts_count,
    COUNT(DISTINCT i.interaction_id) AS interactions_count
FROM users u
LEFT JOIN posts p 
    ON u.user_id = p.user_id
    AND p.post_date >= SYSDATE - 30
LEFT JOIN interactions i 
    ON u.user_id = i.user_id
    AND i.interaction_date >= SYSDATE - 30
WHERE (p.post_id IS NOT NULL OR i.interaction_id IS NOT NULL)
GROUP BY u.user_id, u.username, u.full_name, u.join_date;
/
--------- View with Security Limitation (Only Their Own Posts)---------------
CREATE OR REPLACE VIEW my_posts_secure AS
SELECT
    p.post_id,
    p.content,
    p.post_date,
    p.hashtags,
    COUNT(i.interaction_id) AS total_interactions
FROM posts p
LEFT JOIN interactions i 
    ON p.post_id = i.post_id
WHERE p.user_id = SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')  -- current session ka user_id
GROUP BY p.post_id, p.content, p.post_date, p.hashtags;
/
----------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW post_engagement_summary AS
SELECT
    p.post_id,
    p.content,
    p.post_date,
    p.hashtags,
    u.username,
    u.full_name,
    SUM(CASE WHEN i.interaction_type = 'Like' THEN 1 ELSE 0 END) AS like_count,
    SUM(CASE WHEN i.interaction_type = 'Comment' THEN 1 ELSE 0 END) AS comment_count,
    SUM(CASE WHEN i.interaction_type = 'Share' THEN 1 ELSE 0 END) AS share_count,
    COUNT(i.interaction_id) AS total_interactions
FROM posts p
JOIN users u 
    ON p.user_id = u.user_id
LEFT JOIN interactions i 
    ON p.post_id = i.post_id
GROUP BY p.post_id, p.content, p.post_date, p.hashtags, u.username, u.full_name;
------------------------------------------------------------------------
SELECT * 
FROM post_engagement_summary
WHERE like_count > 5
ORDER BY total_interactions DESC;
----------------------------------------------------------------------
SELECT * FROM post_engagement_summary ORDER BY total_interactions DESC;
---------------Hashtag Wise Post Count View--------------------------------
CREATE OR REPLACE VIEW hashtag_post_count AS
SELECT
    REGEXP_SUBSTR(p.hashtags, '[^,]+', 1, LEVEL) AS hashtag,
    COUNT(*) AS post_count
FROM posts p
CONNECT BY REGEXP_SUBSTR(p.hashtags, '[^,]+', 1, LEVEL) IS NOT NULL
   AND PRIOR post_id = post_id
   AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL
GROUP BY REGEXP_SUBSTR(p.hashtags, '[^,]+', 1, LEVEL);
/
SELECT * FROM hashtag_post_count ORDER BY post_count DESC;

