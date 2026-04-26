WITH monthly AS (
    SELECT
        month,
        doctor_referral_rate,
        LAG(doctor_referral_rate) OVER (ORDER BY month) AS prev_rate
    FROM {{ ref('mart_referral_rate_monthly') }}
)
SELECT *
FROM monthly
WHERE prev_rate IS NOT NULL
  AND doctor_referral_rate > prev_rate * 2
