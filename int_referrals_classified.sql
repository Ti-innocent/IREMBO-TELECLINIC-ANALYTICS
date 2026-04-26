{{ config(materialized='view') }}

SELECT
    c.consultation_id,
    coalesce(co.referral_issued, 0) AS doctor_flag,
    coalesce(req.referral_requested, 0) AS patient_flag,

    CASE
        WHEN co.referral_issued = 1 AND req.referral_requested = 1 THEN 'both'
        WHEN co.referral_issued = 1 THEN 'doctor_referral'
        WHEN req.referral_requested = 1 THEN 'patient_requested_only'
        ELSE 'no_referral'
    END AS referral_type

FROM {{ ref('stg_consultations_fixed') }} c
LEFT JOIN {{ ref('stg_clinical_outcomes') }} co
    ON c.consultation_id = co.consultation_id
LEFT JOIN {{ ref('stg_consultation_requests') }} req
    ON c.consultation_id = req.consultation_id
