WITH ClassAveragePositions AS (  
    SELECT   
        cl.class AS car_class,  
        AVG(r.position) AS average_position,  
        COUNT(r.position) AS total_races  
    FROM Classes cl  
    JOIN Cars c ON cl.class = c.class  
    JOIN Results r ON c.name = r.car  
    GROUP BY cl.class  
),  
MinAveragePosition AS (  
    SELECT   
        MIN(average_position) AS min_average_position  
    FROM ClassAveragePositions  
)  

SELECT   
    c.name AS car_name,  
    cl.class AS car_class,  
    AVG(r.position) AS average_position,  
    COUNT(r.position) AS race_count,  
    cl.country AS car_country,  
    cap.total_races  
FROM Cars c  
JOIN Classes cl ON c.class = cl.class  
JOIN Results r ON c.name = r.car  
JOIN ClassAveragePositions cap ON cl.class = cap.car_class  
JOIN MinAveragePosition map ON cap.average_position = map.min_average_position  
GROUP BY c.name, cl.class, cl.country, cap.total_races  
ORDER BY c.name;