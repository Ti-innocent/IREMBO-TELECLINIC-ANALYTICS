WITH monthly AS (
    SELECT
        month,
        doctor_referral_rate,
        LAG(doctor_referral_rate) OVER (ORDER BY month) AS previous_rate
    FROM {{ ref('mart_referral_rate_monthly') }}
)
SELECT *
FROM monthly
WHERE previous_rate IS NOT NULL
  AND doctor_referral_rate > previous_rate * 2
