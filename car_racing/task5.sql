WITH LowPositionCars AS (  
    SELECT   
        c.name AS car_name,  
        c.class AS car_class,  
        AVG(r.position) AS average_position,  
        COUNT(r.position) AS race_count,  
        cl.country AS car_country  
    FROM Cars c  
    JOIN Results r ON c.name = r.car  
    JOIN Classes cl ON c.class = cl.class  
    GROUP BY c.name, c.class, cl.country  
    HAVING AVG(r.position) > 3.0
),  
ClassCounts AS (  
    SELECT   
        car_class,  
        COUNT(*) AS low_position_count  
    FROM LowPositionCars  
    GROUP BY car_class  
),  
TotalRaces AS (  
    SELECT   
        c.class AS car_class,  
        COUNT(r.race) AS total_races  
    FROM Classes c  
    JOIN Cars cr ON c.class = cr.class  
    JOIN Results r ON cr.name = r.car  
    GROUP BY c.class  
)  

SELECT   
    lpc.car_name,  
    lpc.car_class,  
    lpc.average_position,  
    lpc.race_count,  
    lpc.car_country,  
    tr.total_races,  
    cc.low_position_count  
FROM LowPositionCars lpc  
JOIN ClassCounts cc ON lpc.car_class = cc.car_class  
JOIN TotalRaces tr ON lpc.car_class = tr.car_class  
ORDER BY cc.low_position_count DESC;