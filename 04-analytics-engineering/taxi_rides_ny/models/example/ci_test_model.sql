WITH source_data AS (
    SELECT 1 as id, 'a' as letter
    UNION ALL
    SELECT 2 as id, 'b' as letter
    UNION ALL
    SELECT 3 as id, 'c' as letter
    UNION ALL
    SELECT 4 as id, 'd' as letter
    UNION ALL
    SELECT 5 as id, 'e' as letter
    UNION ALL
    SELECT 6 as id, 'f' as letter
    UNION ALL
    SELECT 7 as id, 'g' as letter
)


SELECT 
    id,
    letter,
    UPPER(letter) as upper_letter
FROM source_data 