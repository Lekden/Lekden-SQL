SELECT 
    z.catid, 
    z.category, 
    string_agg(z.catname, ' / ' ORDER BY z.pos) AS catpath
FROM
(
    SELECT 
        y.*,
        mcc2.name AS catname
    FROM
    (
        SELECT
            x.*,
            unnest(string_to_array(x.path, '/')) AS pathbreak,
            generate_series(1, array_length(string_to_array(x.path, '/'), 1)) AS pos
        FROM
        (
            SELECT DISTINCT ON (mcc.id) 
                mcc.id AS catid,
                mcc.name AS category,
                mcc.path
            FROM 
                mdl_course_categories mcc
            WHERE 
                mcc.visible = 1 -- Only visible categories
                AND (mcc.name NOT ILIKE '%Sandpit%' AND mcc.name NOT ILIKE '%Sandbox%') -- Exclude specific categories
        ) x
    ) y
    JOIN mdl_course_categories mcc2 
        ON mcc2.id::text = y.pathbreak
) z
GROUP BY z.catid, z.category
ORDER BY catpath;


