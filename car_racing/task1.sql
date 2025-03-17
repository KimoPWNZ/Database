WITH RankedCars AS (  
    SELECT   
        c.name AS car_name,  
        c.class AS car_class,  
        AVG(r.position) AS average_position,  
        COUNT(r.position) AS race_count,  
        ROW_NUMBER() OVER (PARTITION BY c.class ORDER BY AVG(r.position)) AS rank  
    FROM Cars c  
    JOIN Results r ON c.name = r.car  
    GROUP BY c.name, c.class  
)  

SELECT   
    car_name,  
    car_class,  
    average_position,  
    race_count  
FROM RankedCars  
WHERE rank = 1  
ORDER BY average_position;