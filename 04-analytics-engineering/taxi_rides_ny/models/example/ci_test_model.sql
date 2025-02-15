WITH source_data AS (
    SELECT 1 as id, 'A' as letter
    UNION ALL
    SELECT 2 as id, 'B' as letter
    UNION ALL
    SELECT 3 as id, 'C' as letter
    UNION ALL
    SELECT 4 as id, 'D' as letter
    UNION ALL
    SELECT 5 as id, 'E' as letter
    UNION ALL
    SELECT 6 as id, 'F' as letter
)

SELECT 
    id,
    letter,
    UPPER(letter) as upper_letter
FROM source_data 