-- ============================================================
-- Bank Marketing Campaign & Term Deposit Analytics
-- PostgreSQL analytical SQL
--
-- Expected table: bank_marketing
-- Target: y = 'yes' means term deposit subscribed
--
-- Notes:
-- 1. "default" is quoted because it is a reserved keyword.
-- 2. Macroeconomic columns contain periods and are quoted.
-- 3. duration is a post-contact variable; economic indicators are available for contextual analysis.
-- 4. These queries are descriptive/diagnostic; they do not claim causality.
-- ============================================================

-- ============================================================
-- 1. Overall campaign performance
-- ============================================================
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing;


-- ============================================================
-- 2. Subscription rate by job
-- ============================================================
SELECT
    job,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY job
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 3. Subscription rate by education
-- ============================================================
SELECT
    education,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY education
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 4. Subscription rate by marital status
-- ============================================================
SELECT
    marital,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY marital
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 5. Age-group performance
-- ============================================================
SELECT
    CASE
        WHEN age <= 30 THEN '<=30'
        WHEN age <= 40 THEN '31-40'
        WHEN age <= 50 THEN '41-50'
        WHEN age <= 60 THEN '51-60'
        ELSE '61+'
    END AS age_group,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY 1
ORDER BY
    CASE age_group
        WHEN '<=30' THEN 1
        WHEN '31-40' THEN 2
        WHEN '41-50' THEN 3
        WHEN '51-60' THEN 4
        ELSE 5
    END;


-- ============================================================
-- 6. Housing and personal-loan combination
-- ============================================================
SELECT
    housing,
    loan,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY housing, loan
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 7. Contact method effectiveness
-- ============================================================
SELECT
    contact,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY contact
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 8. Monthly campaign performance
-- ============================================================
WITH monthly AS (
    SELECT
        month,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers
    FROM bank_marketing
    GROUP BY month
)
SELECT
    month,
    customers,
    subscribers,
    ROUND(
        100.0 * subscribers / NULLIF(customers, 0), 2
    ) AS subscription_rate_pct
FROM monthly
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 9. Campaign-frequency buckets
-- ============================================================
WITH campaign_summary AS (
    SELECT
        CASE
            WHEN campaign BETWEEN 1 AND 2 THEN '1-2 Contacts'
            WHEN campaign BETWEEN 3 AND 5 THEN '3-5 Contacts'
            WHEN campaign BETWEEN 6 AND 10 THEN '6-10 Contacts'
            ELSE '11+ Contacts'
        END AS campaign_group,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers
    FROM bank_marketing
    GROUP BY 1
)
SELECT
    campaign_group,
    customers,
    subscribers,
    ROUND(
        100.0 * subscribers / NULLIF(customers, 0), 2
    ) AS subscription_rate_pct
FROM campaign_summary
ORDER BY
    CASE campaign_group
        WHEN '1-2 Contacts' THEN 1
        WHEN '3-5 Contacts' THEN 2
        WHEN '6-10 Contacts' THEN 3
        ELSE 4
    END;


-- ============================================================
-- 10. Campaign bucket: customer share and conversion
-- ============================================================
WITH campaign_summary AS (
    SELECT
        CASE
            WHEN campaign BETWEEN 1 AND 2 THEN '1-2 Contacts'
            WHEN campaign BETWEEN 3 AND 5 THEN '3-5 Contacts'
            WHEN campaign BETWEEN 6 AND 10 THEN '6-10 Contacts'
            ELSE '11+ Contacts'
        END AS campaign_group,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers
    FROM bank_marketing
    GROUP BY 1
)
SELECT
    campaign_group,
    customers,
    subscribers,
    ROUND(
        100.0 * subscribers / NULLIF(customers, 0), 2
    ) AS subscription_rate_pct,
    ROUND(
        100.0 * customers / SUM(customers) OVER (), 2
    ) AS customer_share_pct
FROM campaign_summary
ORDER BY customers DESC;


-- ============================================================
-- 11. Previous campaign outcome
-- ============================================================
SELECT
    poutcome,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY poutcome
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 12. Prior-contact status using pdays = 999 sentinel
-- ============================================================
SELECT
    CASE
        WHEN pdays = 999 THEN 'No prior contact'
        ELSE 'Contacted before'
    END AS prior_contact_status,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY 1
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 13. Rank job categories by subscription rate
-- Demonstrates RANK() and a CTE.
-- ============================================================
WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate_pct
    FROM bank_marketing
    GROUP BY job
)
SELECT
    job,
    customers,
    subscribers,
    ROUND(subscription_rate_pct, 2) AS subscription_rate_pct,
    RANK() OVER (ORDER BY subscription_rate_pct DESC) AS rate_rank
FROM job_summary
ORDER BY rate_rank, job;


-- ============================================================
-- 14. Dense-rank months by subscription rate
-- Demonstrates DENSE_RANK().
-- ============================================================
WITH month_summary AS (
    SELECT
        month,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate_pct
    FROM bank_marketing
    GROUP BY month
)
SELECT
    month,
    customers,
    subscribers,
    ROUND(subscription_rate_pct, 2) AS subscription_rate_pct,
    DENSE_RANK() OVER (ORDER BY subscription_rate_pct DESC) AS month_rank
FROM month_summary
ORDER BY month_rank, month;


-- ============================================================
-- 15. Row-number campaign segments within previous outcomes
-- Demonstrates ROW_NUMBER().
-- ============================================================
WITH segment_summary AS (
    SELECT
        poutcome,
        CASE
            WHEN campaign BETWEEN 1 AND 2 THEN '1-2 Contacts'
            WHEN campaign BETWEEN 3 AND 5 THEN '3-5 Contacts'
            WHEN campaign BETWEEN 6 AND 10 THEN '6-10 Contacts'
            ELSE '11+ Contacts'
        END AS campaign_group,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate_pct
    FROM bank_marketing
    GROUP BY poutcome, campaign_group
)
SELECT
    poutcome,
    campaign_group,
    customers,
    subscribers,
    ROUND(subscription_rate_pct, 2) AS subscription_rate_pct,
    ROW_NUMBER() OVER (
        PARTITION BY poutcome
        ORDER BY subscription_rate_pct DESC
    ) AS performance_order
FROM segment_summary
ORDER BY poutcome, performance_order;


-- ============================================================
-- 16. Compare each job segment with the overall benchmark
-- ============================================================
WITH overall AS (
    SELECT
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS overall_rate
    FROM bank_marketing
),
job_summary AS (
    SELECT
        job,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate
    FROM bank_marketing
    GROUP BY job
)
SELECT
    j.job,
    j.customers,
    j.subscribers,
    ROUND(j.subscription_rate, 2) AS subscription_rate_pct,
    ROUND(j.subscription_rate - o.overall_rate, 2)
        AS rate_vs_overall_pp
FROM job_summary j
CROSS JOIN overall o
ORDER BY rate_vs_overall_pp DESC;


-- ============================================================
-- 17. Subscriber contribution by job
-- Shows scale as well as rate.
-- ============================================================
WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers
    FROM bank_marketing
    GROUP BY job
)
SELECT
    job,
    customers,
    subscribers,
    ROUND(
        100.0 * subscribers
        / NULLIF(SUM(subscribers) OVER (), 0), 2
    ) AS share_of_all_subscribers_pct
FROM job_summary
ORDER BY share_of_all_subscribers_pct DESC;


-- ============================================================
-- 18. High-volume / low-conversion job segments
-- Median customer count is used as the volume benchmark.
-- ============================================================
WITH job_summary AS (
    SELECT
        job,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate
    FROM bank_marketing
    GROUP BY job
),
benchmarks AS (
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY customers)
            AS median_job_volume,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS overall_rate
    FROM bank_marketing
)
SELECT
    j.job,
    j.customers,
    j.subscribers,
    ROUND(j.subscription_rate, 2) AS subscription_rate_pct,
    CASE
        WHEN j.customers >= b.median_job_volume
             AND j.subscription_rate < b.overall_rate
            THEN 'High volume / low rate'
        WHEN j.customers >= b.median_job_volume
             AND j.subscription_rate >= b.overall_rate
            THEN 'High volume / high rate'
        WHEN j.customers < b.median_job_volume
             AND j.subscription_rate >= b.overall_rate
            THEN 'Lower volume / high rate'
        ELSE 'Lower volume / lower rate'
    END AS opportunity_type
FROM job_summary j
CROSS JOIN benchmarks b
ORDER BY
    CASE
        WHEN j.customers >= b.median_job_volume
             AND j.subscription_rate >= b.overall_rate THEN 1
        WHEN j.customers >= b.median_job_volume
             AND j.subscription_rate < b.overall_rate THEN 2
        WHEN j.customers < b.median_job_volume
             AND j.subscription_rate >= b.overall_rate THEN 3
        ELSE 4
    END,
    j.subscription_rate DESC;


-- ============================================================
-- 19. Campaign frequency + previous campaign outcome
-- ============================================================
SELECT
    poutcome,
    CASE
        WHEN campaign BETWEEN 1 AND 2 THEN '1-2 Contacts'
        WHEN campaign BETWEEN 3 AND 5 THEN '3-5 Contacts'
        WHEN campaign BETWEEN 6 AND 10 THEN '6-10 Contacts'
        ELSE '11+ Contacts'
    END AS campaign_group,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY poutcome, campaign_group
ORDER BY
    poutcome,
    CASE campaign_group
        WHEN '1-2 Contacts' THEN 1
        WHEN '3-5 Contacts' THEN 2
        WHEN '6-10 Contacts' THEN 3
        ELSE 4
    END;


-- ============================================================
-- 20. Contact method by month
-- Helps separate channel patterns from monthly campaign mix.
-- ============================================================
WITH channel_month AS (
    SELECT
        contact,
        month,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers
    FROM bank_marketing
    GROUP BY contact, month
)
SELECT
    contact,
    month,
    customers,
    subscribers,
    ROUND(
        100.0 * subscribers / NULLIF(customers, 0), 2
    ) AS subscription_rate_pct,
    RANK() OVER (
        PARTITION BY month
        ORDER BY 100.0 * subscribers / NULLIF(customers, 0) DESC
    ) AS channel_rank_within_month
FROM channel_month
ORDER BY month, channel_rank_within_month;


-- ============================================================
-- 21. Economic indicators by subscription outcome
-- ============================================================
SELECT
    y AS subscription,
    COUNT(*) AS customers,
    ROUND(AVG("emp.var.rate"), 2) AS avg_emp_var_rate,
    ROUND(AVG("euribor3m"), 2) AS avg_euribor_3m,
    ROUND(AVG("nr.employed"), 2) AS avg_nr_employed
FROM bank_marketing
GROUP BY y
ORDER BY y;


-- ============================================================
-- 22. Post-contact duration analysis
-- duration is intentionally kept separate from pre-contact targeting.
-- ============================================================
SELECT
    CASE
        WHEN duration <= 300 THEN '<=5 min'
        WHEN duration <= 600 THEN '5-10 min'
        ELSE '>10 min'
    END AS duration_group,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY 1
ORDER BY
    CASE duration_group
        WHEN '<=5 min' THEN 1
        WHEN '5-10 min' THEN 2
        ELSE 3
    END;


-- ============================================================
-- 23. Age group + contact method
-- ============================================================
SELECT
    CASE
        WHEN age <= 30 THEN '<=30'
        WHEN age <= 40 THEN '31-40'
        WHEN age <= 50 THEN '41-50'
        WHEN age <= 60 THEN '51-60'
        ELSE '61+'
    END AS age_group,
    contact,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS subscription_rate_pct
FROM bank_marketing
GROUP BY age_group, contact
HAVING COUNT(*) >= 100
ORDER BY subscription_rate_pct DESC;


-- ============================================================
-- 24. Top combined campaign segments
-- Minimum 100 customers reduces noisy small groups.
-- ============================================================
WITH segment_summary AS (
    SELECT
        job,
        contact,
        poutcome,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate
    FROM bank_marketing
    GROUP BY job, contact, poutcome
)
SELECT
    job,
    contact,
    poutcome,
    customers,
    subscribers,
    ROUND(subscription_rate, 2) AS subscription_rate_pct,
    RANK() OVER (ORDER BY subscription_rate DESC) AS segment_rank
FROM segment_summary
WHERE customers >= 100
ORDER BY segment_rank
LIMIT 20;


-- ============================================================
-- 25. Final business scorecard
-- One reusable output for campaign review.
-- ============================================================
WITH segment_summary AS (
    SELECT
        CASE
            WHEN campaign BETWEEN 1 AND 2 THEN '1-2 Contacts'
            WHEN campaign BETWEEN 3 AND 5 THEN '3-5 Contacts'
            WHEN campaign BETWEEN 6 AND 10 THEN '6-10 Contacts'
            ELSE '11+ Contacts'
        END AS campaign_group,
        poutcome,
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE y = 'yes') AS subscribers,
        100.0 * COUNT(*) FILTER (WHERE y = 'yes')
            / NULLIF(COUNT(*), 0) AS subscription_rate
    FROM bank_marketing
    GROUP BY campaign_group, poutcome
)
SELECT
    campaign_group,
    poutcome,
    customers,
    subscribers,
    ROUND(subscription_rate, 2) AS subscription_rate_pct,
    RANK() OVER (ORDER BY subscription_rate DESC) AS segment_rank
FROM segment_summary
WHERE customers >= 100
ORDER BY segment_rank, customers DESC;
