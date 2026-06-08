CREATE OR REPLACE TABLE `marketing-analysis-498500.advertising_data.unified_ads` AS

WITH combined_ads AS (

    -- Facebook Ads
    SELECT
        CAST(date AS DATE) AS date,
        'Facebook' AS platform,

        campaign_id,
        campaign_name,
        ad_set_id AS group_id,
        ad_set_name AS group_name,

        impressions,
        clicks,
        spend,
        conversions,

        NULL AS conversion_value,

        video_views,
        NULL AS video_watch_25,
        NULL AS video_watch_50,
        NULL AS video_watch_75,
        NULL AS video_watch_100,

        engagement_rate,
        reach,
        frequency,

        NULL AS likes,
        NULL AS shares,
        NULL AS comments,

        NULL AS google_ctr,
        NULL AS avg_cpc,
        NULL AS quality_score,
        NULL AS search_impression_share

    FROM `marketing-analysis-498500.advertising_data.facebook_ads`


    UNION ALL


    -- Google Ads
    SELECT
        CAST(date AS DATE) AS date,
        'Google' AS platform,

        campaign_id,
        campaign_name,
        ad_group_id AS group_id,
        ad_group_name AS group_name,

        impressions,
        clicks,
        cost AS spend,
        conversions,

        conversion_value,

        NULL AS video_views,
        NULL AS video_watch_25,
        NULL AS video_watch_50,
        NULL AS video_watch_75,
        NULL AS video_watch_100,

        NULL AS engagement_rate,
        NULL AS reach,
        NULL AS frequency,

        NULL AS likes,
        NULL AS shares,
        NULL AS comments,

        ctr AS google_ctr,
        avg_cpc,
        quality_score,
        search_impression_share

    FROM `marketing-analysis-498500.advertising_data.google_ads`


    UNION ALL


    -- TikTok Ads
    SELECT
        CAST(date AS DATE) AS date,
        'TikTok' AS platform,

        campaign_id,
        campaign_name,
        adgroup_id AS group_id,
        adgroup_name AS group_name,

        impressions,
        clicks,
        cost AS spend,
        conversions,

        NULL AS conversion_value,

        video_views,
        video_watch_25,
        video_watch_50,
        video_watch_75,
        video_watch_100,

        NULL AS engagement_rate,
        NULL AS reach,
        NULL AS frequency,

        likes,
        shares,
        comments,

        NULL AS google_ctr,
        NULL AS avg_cpc,
        NULL AS quality_score,
        NULL AS search_impression_share

    FROM `marketing-analysis-498500.advertising_data.tiktok_ads`
)

SELECT
    date,

   FORMAT_DATE('%A', date) AS day_name,

CAST(FORMAT_DATE('%u', date) AS INT64) AS day_number,

CONCAT('0', FORMAT_DATE('%u', date), ' ', FORMAT_DATE('%A', date)) AS day_label,

CASE
    WHEN FORMAT_DATE('%u', date) IN ('6', '7') THEN 'Weekend'
    ELSE 'Weekday'
END AS week_type,

    platform,
    campaign_id,
    campaign_name,
    group_id,
    group_name,

    impressions,
    clicks,
    spend,
    conversions,
    conversion_value,

    video_views,
    video_watch_25,
    video_watch_50,
    video_watch_75,
    video_watch_100,

    engagement_rate,
    reach,
    frequency,

    likes,
    shares,
    comments,

    CASE
    WHEN platform = 'TikTok' THEN COALESCE(likes, 0) + COALESCE(shares, 0) + COALESCE(comments, 0)
    WHEN platform = 'Facebook' THEN ROUND(impressions * engagement_rate)
    ELSE NULL
END AS engagement_count,

    google_ctr,
    avg_cpc,
    quality_score,
    search_impression_share

FROM combined_ads;
