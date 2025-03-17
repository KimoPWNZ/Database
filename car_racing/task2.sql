WITH AvgPositions AS (  
    SELECT   
        c.name AS car_name,  
        c.class AS car_class,  
        AVG(r.position) AS average_position,  
        COUNT(r.position) AS race_count,  
        cl.country AS car_country,  
        ROW_NUMBER() OVER (ORDER BY AVG(r.position), c.name) AS rn  
    FROM Cars c  
    JOIN Results r ON c.name = r.car  
    JOIN Classes cl ON c.class = cl.class  
    GROUP BY c.name, c.class, cl.country  
)  

SELECT   
    car_name,  
    car_class,  
    average_position,  
    race_count,  
    car_country  
FROM AvgPositions  
WHERE rn = 1;