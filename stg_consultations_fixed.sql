{{ config(materialized='view') }}

WITH source_data AS (
    SELECT * FROM {{ source('raw', 'consultations') }}
),

cleaned AS (
    SELECT
        consultation_id,
        patient_id,
        parseDateTimeBestEffort(consultation_created_at) AS created_at_utc,

        CASE
            WHEN consultation_started_at LIKE '%+02:00'
                THEN toTimeZone(parseDateTimeBestEffort(consultation_started_at), 'UTC')
            ELSE parseDateTimeBestEffort(consultation_started_at)
        END AS started_at_utc,

        consultation_started_at LIKE '%+02:00' AS is_tz_corrected

    FROM source_data
    WHERE patient_id NOT LIKE 'TEST_%'
),

final AS (
    SELECT *,
        CASE
            WHEN dateDiff('minute', created_at_utc, started_at_utc) < 0 THEN NULL
            WHEN dateDiff('minute', created_at_utc, started_at_utc) > 300 THEN NULL
            ELSE dateDiff('minute', created_at_utc, started_at_utc)
        END AS wait_time_minutes
    FROM cleaned
)

SELECT * FROM final
