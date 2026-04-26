{{ config(materialized='table') }}

SELECT
    toStartOfMonth(created_at_utc) AS month,
    COUNT(*) AS total_consultations,

    COUNTIf(referral_type IN ('doctor_referral','both')) * 1.0 / COUNT(*) AS doctor_referral_rate,
    COUNTIf(referral_type IN ('patient_requested_only','both')) * 1.0 / COUNT(*) AS patient_requested_rat

FROM {{ ref('int_referrals_classified') }}

GROUP BY month
ORDER BY month
