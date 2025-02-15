WITH source_data AS (
    SELECT 1 as id, 'A' as letter
    UNION ALL
    SELECT 2 as id, 'B' as letter
    UNION ALL
    SELECT 3 as id, 'C' as letter
    UNION ALL
    SELECT 4 as id, 'D' as letter
)

SELECT 
    id,
    letter,
    UPPER(letter) as upper_letter
FROM source_data 