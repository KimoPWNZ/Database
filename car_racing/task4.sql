WITH ClassAveragePositions AS (  
    SELECT   
        c.class,  
        AVG(r.position) AS average_position  
    FROM Cars c  
    JOIN Results r ON c.name = r.car  
    GROUP BY c.class  
    HAVING COUNT(c.name) > 1
)  

SELECT   
    c.name AS car_name,  
    c.class AS car_class,  
    AVG(r.position) AS average_position,  
    COUNT(r.position) AS race_count,  
    cl.country AS car_country  
FROM Cars c  
JOIN Results r ON c.name = r.car  
JOIN Classes cl ON c.class = cl.class  
JOIN ClassAveragePositions cap ON c.class = cap.class  
GROUP BY c.name, c.class, cl.country, cap.average_position  
HAVING AVG(r.position) < cap.average_position
ORDER BY c.class, average_position;