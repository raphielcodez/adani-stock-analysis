#   1. BASIC DATASET PROFILE

-- Total number of records

SELECT COUNT(*) AS total_records
FROM adani_cleaned;


-- Number of unique companies

SELECT
    COUNT(DISTINCT symbol) AS number_of_companies
FROM adani_cleaned;


-- Number of unique company names

SELECT
    COUNT(DISTINCT company) AS number_of_companies
FROM adani_cleaned;


-- Date range

SELECT
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM adani_cleaned;


# 2. COMPANY COVERAGE

-- Number of observations for each company

SELECT
    symbol,
    company,
    COUNT(*) AS trading_days
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    trading_days DESC;


-- Start and end date for every company

SELECT
    symbol,
    company,
    MIN(date) AS start_date,
    MAX(date) AS end_date,
    COUNT(*) AS observations
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    start_date;


#  3. DATA QUALITY CHECKS

-- Check for missing values in closing price

SELECT
    COUNT(*) AS missing_close_values
FROM adani_cleaned
WHERE close IS NULL;


-- Check for missing values in open price

SELECT
    COUNT(*) AS missing_open_values
FROM adani_cleaned
WHERE open IS NULL;


-- Check for missing values in high price

SELECT
    COUNT(*) AS missing_high_values
FROM adani_cleaned
WHERE high IS NULL;


-- Check for missing values in low price

SELECT
    COUNT(*) AS missing_low_values
FROM adani_cleaned
WHERE low IS NULL;


-- Check for missing volume

SELECT
    COUNT(*) AS missing_volume_values
FROM adani_cleaned
WHERE volume IS NULL;


-- Show records with missing values

SELECT *
FROM adani_cleaned
WHERE
    close IS NULL
    OR open IS NULL
    OR high IS NULL
    OR low IS NULL
    OR volume IS NULL;


#  4. DUPLICATE CHECK

-- Look for duplicate company/date combinations

SELECT
    symbol,
    date,
    COUNT(*) AS duplicate_count
FROM adani_cleaned
GROUP BY
    symbol,
    date
HAVING COUNT(*) > 1
ORDER BY
    duplicate_count DESC;


#  5. BASIC PRICE STATISTICS

-- Average closing price by company

SELECT
    symbol,
    company,
    AVG(close) AS average_close_price
FROM adani_cleaned
WHERE close IS NOT NULL
GROUP BY
    symbol,
    company
ORDER BY
    average_close_price DESC;


-- Highest closing price recorded

SELECT
    symbol,
    company,
    MAX(close) AS highest_close
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    highest_close DESC;


-- Lowest closing price recorded

SELECT
    symbol,
    company,
    MIN(close) AS lowest_close
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    lowest_close;


#   6. DAILY PRICE RANGE

-- Average daily trading range

SELECT
    symbol,
    company,
    AVG(high - low) AS average_daily_range
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    average_daily_range DESC;


-- Largest single-day trading range

SELECT
    symbol,
    company,
    date,
    open,
    high,
    low,
    close,
    (high - low) AS daily_range
FROM adani_cleaned
WHERE
    high IS NOT NULL
    AND low IS NOT NULL
ORDER BY
    daily_range DESC;



#7. TRADING VOLUME ANALYSIS

-- Average daily trading volume

SELECT
    symbol,
    company,
    AVG(volume) AS average_daily_volume
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    average_daily_volume DESC;


-- Median volume

SELECT
    symbol,
    company,
    AVG(volume) AS median_volume
FROM (
    SELECT
        symbol,
        company,
        volume,
        ROW_NUMBER() OVER (
            PARTITION BY symbol
            ORDER BY volume
        ) AS row_num,
        COUNT(*) OVER (
            PARTITION BY symbol
        ) AS total_rows
    FROM adani_cleaned
    WHERE volume IS NOT NULL
) ranked
WHERE row_num IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
)
GROUP BY
    symbol,
    company
ORDER BY
    median_volume DESC;


-- Highest-volume trading days

SELECT
    symbol,
    company,
    date,
    volume
FROM adani_cleaned
WHERE volume IS NOT NULL
ORDER BY
    volume DESC
LIMIT 20;


/* ============================================================
   8. CORPORATE ACTIONS
   ============================================================ */

-- Number of dividend events

SELECT
    symbol,
    company,
    COUNT(*) AS dividend_events
FROM adani_cleaned
WHERE dividends > 0
GROUP BY
    symbol,
    company
ORDER BY
    dividend_events DESC;


-- Total dividends recorded

SELECT
    symbol,
    company,
    SUM(dividends) AS total_dividends
FROM adani_cleaned
GROUP BY
    symbol,
    company
ORDER BY
    total_dividends DESC;


-- Stock split events

SELECT
    symbol,
    company,
    COUNT(*) AS split_events
FROM adani_cleaned
WHERE stock_splits > 0
GROUP BY
    symbol,
    company
ORDER BY
    split_events DESC;


# 9. DAILY RETURNS

-- Average daily return

SELECT
    symbol,
    company,
    AVG(daily_return) AS average_daily_return
FROM adani_cleaned
WHERE daily_return IS NOT NULL
GROUP BY
    symbol,
    company
ORDER BY
    average_daily_return DESC;


-- Highest daily return

SELECT
    symbol,
    company,
    date,
    daily_return
FROM adani_cleaned
WHERE daily_return IS NOT NULL
ORDER BY
    daily_return DESC
LIMIT 20;


-- Lowest daily return

SELECT
    symbol,
    company,
    date,
    daily_return
FROM adani_cleaned
WHERE daily_return IS NOT NULL
ORDER BY
    daily_return
LIMIT 20;


# 10. POSITIVE VS NEGATIVE TRADING DAYS


SELECT
    symbol,
    company,
    
    COUNT(*) AS total_days,

    SUM(
        CASE
            WHEN daily_return > 0 THEN 1
            ELSE 0
        END
    ) AS positive_days,

    SUM(
        CASE
            WHEN daily_return < 0 THEN 1
            ELSE 0
        END
    ) AS negative_days,

    SUM(
        CASE
            WHEN daily_return = 0 THEN 1
            ELSE 0
        END
    ) AS unchanged_days

FROM adani_cleaned

WHERE daily_return IS NOT NULL

GROUP BY
    symbol,
    company

ORDER BY
    positive_days DESC;


#  11. PERCENTAGE OF POSITIVE DAYS


SELECT
    symbol,
    company,

    COUNT(*) AS trading_days,

    SUM(
        CASE
            WHEN daily_return > 0 THEN 1
            ELSE 0
        END
    ) AS positive_days,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN daily_return > 0 THEN 1
                ELSE 0
            END
        ) /
        COUNT(*),
        2
    ) AS positive_day_percentage

FROM adani_cleaned

WHERE daily_return IS NOT NULL

GROUP BY
    symbol,
    company

ORDER BY
    positive_day_percentage DESC;



# 12. VOLATILITY


-- Historical standard deviation of daily returns

SELECT
    symbol,
    company,
    STDDEV_SAMP(daily_return) AS daily_volatility
FROM adani_cleaned
WHERE daily_return IS NOT NULL
GROUP BY
    symbol,
    company
ORDER BY
    daily_volatility DESC;


-- Annualized historical volatility
-- Assumes approximately 252 trading days per year

SELECT
    symbol,
    company,

    STDDEV_SAMP(daily_return)
        * SQRT(252) AS annualized_volatility

FROM adani_cleaned

WHERE daily_return IS NOT NULL

GROUP BY
    symbol,
    company

ORDER BY
    annualized_volatility DESC;


#   13. EXTREME PRICE MOVEMENTS


-- Days with returns greater than +10%

SELECT
    symbol,
    company,
    date,
    daily_return
FROM adani_cleaned
WHERE daily_return > 0.10
ORDER BY
    daily_return DESC;


-- Days with returns below -10%

SELECT
    symbol,
    company,
    date,
    daily_return
FROM adani_cleaned
WHERE daily_return < -0.10
ORDER BY
    daily_return;


#   14. YEARLY PERFORMANCE

SELECT
    symbol,
    company,
    yaer,

    AVG(daily_return) AS average_daily_return,

    STDDEV_SAMP(daily_return)
        * SQRT(252) AS annualized_volatility,

    AVG(volume) AS average_volume

FROM adani_cleaned

WHERE daily_return IS NOT NULL

GROUP BY
    symbol,
    company,
    yaer

ORDER BY
    yaer,
    symbol;


#  15. YEARLY PRICE PERFORMANCE

SELECT
    symbol,
    company,
    yaer,
    MIN(close) AS lowest_close,
    MAX(close) AS highest_close,
    AVG(close) AS average_close

FROM adani_cleaned

WHERE close IS NOT NULL

GROUP BY
    symbol,
    company,
    yaer

ORDER BY
    yaer,
    symbol;


#  16. MONTHLY TRADING VOLUME

SELECT
    symbol,
    company,
    yaer,
    month,

    AVG(volume) AS average_volume,
    SUM(volume) AS total_volume

FROM adani_cleaned

GROUP BY
    symbol,
    company,
    yaer,
    month

ORDER BY
    yaer,
    month,
    symbol;


#  17. BEST PERFORMING DAYS

SELECT
    symbol,
    company,
    date,
    open,
    close,
    daily_return

FROM adani_cleaned

WHERE daily_return IS NOT NULL

ORDER BY
    daily_return DESC

LIMIT 10;


# 18. WORST PERFORMING DAYS

SELECT
    symbol,
    company,
    date,
    open,
    close,
    daily_return

FROM adani_cleaned

WHERE daily_return IS NOT NULL

ORDER BY
    daily_return ASC

LIMIT 10;


#  19. JANUARY 2023 EVENT ANALYSIS

-- Event date used in this project:
-- January 24, 2023

SELECT
    symbol,
    company,
    date,
    close,
    volume,
    daily_return

FROM adani_cleaned

WHERE date BETWEEN
      '2023-01-01'
      AND '2023-03-01'

ORDER BY
    date,
    symbol;


#  20. 45-DAY EVENT WINDOW

SELECT
    symbol,
    company,

    CASE
        WHEN date < '2023-01-24'
            THEN 'Before Event'
        ELSE 'After Event'
    END AS event_period,

    AVG(daily_return) AS average_return,

    STDDEV_SAMP(daily_return)
        AS volatility,

    AVG(volume) AS average_volume

FROM adani_cleaned

WHERE date BETWEEN
      '2022-12-10'
      AND '2023-03-10'

GROUP BY
    symbol,
    company,

    CASE
        WHEN date < '2023-01-24'
            THEN 'Before Event'
        ELSE 'After Event'
    END

ORDER BY
    symbol,
    event_period;


# 21. EVENT-DAY STOCK PERFORMANCE

SELECT
    symbol,
    company,
    date,
    open,
    high,
    low,
    close,
    volume,
    daily_return

FROM adani_cleaned

WHERE date = '2023-01-24'

ORDER BY
    daily_return;



# 22. EVENT WINDOW — LARGE PRICE MOVEMENTS

SELECT
    symbol,
    company,
    date,
    daily_return,
    volume

FROM adani_cleaned

WHERE date BETWEEN
      '2023-01-24'
      AND '2023-02-28'

AND daily_return IS NOT NULL

ORDER BY
    ABS(daily_return) DESC

LIMIT 30;


#  23. RANK COMPANIES BY VOLATILITY

WITH volatility AS (

    SELECT
        symbol,
        company,

        STDDEV_SAMP(daily_return)
            * SQRT(252) AS annualized_volatility

    FROM adani_cleaned

    WHERE daily_return IS NOT NULL

    GROUP BY
        symbol,
        company
)

SELECT
    symbol,
    company,
    annualized_volatility,

    RANK() OVER (
        ORDER BY annualized_volatility DESC
    ) AS volatility_rank

FROM volatility

ORDER BY
    volatility_rank;


#  24. RANK COMPANIES BY AVERAGE VOLUME

WITH volume_data AS (

    SELECT
        symbol,
        company,
        AVG(volume) AS average_volume

    FROM adani_cleaned

    GROUP BY
        symbol,
        company
)

SELECT
    symbol,
    company,
    average_volume,

    RANK() OVER (
        ORDER BY average_volume DESC
    ) AS volume_rank

FROM volume_data

ORDER BY
    volume_rank;


# 25. RANK COMPANIES BY POSITIVE-DAY PERCENTAGE

WITH daily_stats AS (

    SELECT
        symbol,
        company,

        COUNT(*) AS trading_days,

        SUM(
            CASE
                WHEN daily_return > 0 THEN 1
                ELSE 0
            END
        ) AS positive_days

    FROM adani_cleaned

    WHERE daily_return IS NOT NULL

    GROUP BY
        symbol,
        company
)

SELECT
    symbol,
    company,

    trading_days,
    positive_days,

    100.0 *
    positive_days /
    trading_days AS positive_day_percentage,

    RANK() OVER (
        ORDER BY
            positive_days * 1.0 /
            trading_days DESC
    ) AS positive_day_rank

FROM daily_stats

ORDER BY
    positive_day_rank;


#  26. LARGEST DAILY PRICE RANGES

SELECT
    symbol,
    company,
    date,
    open,
    high,
    low,
    close,

    ((high - low) / open) * 100
        AS daily_range_percentage

FROM adani_cleaned

WHERE open IS NOT NULL
  AND high IS NOT NULL
  AND low IS NOT NULL

ORDER BY
    daily_range_percentage DESC

LIMIT 20;


# 27. HIGHEST-VOLUME DAYS BY COMPANY

WITH ranked_volume AS (

    SELECT
        symbol,
        company,
        date,
        volume,

        ROW_NUMBER() OVER (
            PARTITION BY symbol
            ORDER BY volume DESC
        ) AS volume_rank

    FROM adani_cleaned

    WHERE volume IS NOT NULL
)

SELECT
    symbol,
    company,
    date,
    volume,
    volume_rank

FROM ranked_volume

WHERE volume_rank <= 5

ORDER BY
    symbol,
    volume_rank;


#  28. LARGEST POSITIVE DAILY RETURNS BY COMPANY

WITH ranked_returns AS (

    SELECT
        symbol,
        company,
        date,
        daily_return,

        ROW_NUMBER() OVER (
            PARTITION BY symbol
            ORDER BY daily_return DESC
        ) AS return_rank

    FROM adani_cleaned

    WHERE daily_return IS NOT NULL
)

SELECT
    symbol,
    company,
    date,
    daily_return,
    return_rank

FROM ranked_returns

WHERE return_rank <= 5

ORDER BY
    symbol,
    return_rank;


# 29. LARGEST NEGATIVE DAILY RETURNS BY COMPANY

WITH ranked_returns AS (

    SELECT
        symbol,
        company,
        date,
        daily_return,

        ROW_NUMBER() OVER (
            PARTITION BY symbol
            ORDER BY daily_return ASC
        ) AS return_rank

    FROM adani_cleaned

    WHERE daily_return IS NOT NULL
)

SELECT
    symbol,
    company,
    date,
    daily_return,
    return_rank

FROM ranked_returns

WHERE return_rank <= 5

ORDER BY
    symbol,
    return_rank;


#  30. DATA QUALITY SUMMARY

SELECT

    COUNT(*) AS total_rows,

    COUNT(DISTINCT symbol)
        AS total_companies,

    MIN(date)
        AS earliest_date,

    MAX(date)
        AS latest_date,

    SUM(
        CASE
            WHEN close IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_close_values,

    SUM(
        CASE
            WHEN volume IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_volume_values

FROM adani_cleaned;




























