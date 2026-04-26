SELECT *
FROM {{ ref('stg_consultations_fixed') }}
WHERE is_tz_corrected = 1
  AND wait_time_minutes < 1
