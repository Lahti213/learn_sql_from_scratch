/* Count of distinct campaigns*/
SELECT COUNT(DISTINCT utm_campaign) AS Campaigns
FROM page_visits;

/*Count of distinct sources*/
SELECT COUNT(DISTINCT utm_source) AS Sources
FROM page_visits;

/*Sources for each campaign*/
SELECT DISTINCT utm_source AS Source, utm_campaign AS Campaign
FROM page_visits
ORDER BY utm_source ASC;

/*Page names*/
SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;

/*First touch (count) by source and campaign*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
       ft.first_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
  )
  SELECT ft_attr.utm_source AS Source,
  			 ft_attr.utm_campaign AS Campaign,
         COUNT(*) AS 'First Touch Count'
  FROM ft_attr
  GROUP BY 1, 2
  ORDER BY 3 DESC;

/*Last touch (count) by source and campaign*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
       lt.last_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS Source,
  		 lt_attr.utm_campaign AS Campaign,
       COUNT(*) AS 'Last Touch Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*Count of distinct users visiting purchase page.*/
SELECT COUNT(DISTINCT user_id) AS 'Users visiting Purchase page'
FROM page_visits
WHERE page_name = '4 - purchase';

/*Last-touches on purchase page by campaign.*/
WITH last_touch_purch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr_purch AS (
SELECT lt.user_id,
       lt.last_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM last_touch_purch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr_purch.utm_source AS Source,
  		 lt_attr_purch.utm_campaign AS Campaign,
       COUNT(*) AS 'Last Touch Count'
FROM lt_attr_purch
GROUP BY 1, 2
ORDER BY 3 DESC;