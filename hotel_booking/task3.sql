WITH HotelCategories AS (  
    SELECT   
        h.ID_hotel,  
        h.name,  
        CASE  
            WHEN AVG(r.price) < 175 THEN 'Дешевый'  
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'  
            ELSE 'Дорогой'  
        END AS category  
    FROM   
        Hotel h  
    JOIN   
        Room r ON h.ID_hotel = r.ID_hotel  
    GROUP BY   
        h.ID_hotel  
),  
CustomerPreferences AS (  
    SELECT   
        c.ID_customer,  
        c.name,  
        MAX(CASE WHEN hc.category = 'Дорогой' THEN 1 ELSE 0 END) AS has_expensive,  
        MAX(CASE WHEN hc.category = 'Средний' THEN 1 ELSE 0 END) AS has_average,  
        MAX(CASE WHEN hc.category = 'Дешевый' THEN 1 ELSE 0 END) AS has_cheap,  
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels  
    FROM   
        Customer c  
    JOIN   
        Booking b ON c.ID_customer = b.ID_customer  
    JOIN   
        Room r ON b.ID_room = r.ID_room  
    JOIN   
        HotelCategories hc ON r.ID_hotel = hc.ID_hotel  
    JOIN   
        Hotel h ON h.ID_hotel = r.ID_hotel  
    GROUP BY   
        c.ID_customer  
)  
SELECT   
    ID_customer,  
    name,  
    CASE  
        WHEN has_expensive = 1 THEN 'Дорогой'  
        WHEN has_average = 1 THEN 'Средний'  
        WHEN has_cheap = 1 THEN 'Дешевый'  
    END AS preferred_hotel_type,  
    visited_hotels  
FROM   
    CustomerPreferences  
ORDER BY   
    CASE  
        WHEN has_expensive = 1 THEN 3  
        WHEN has_average = 1 THEN 2  
        WHEN has_cheap = 1 THEN 1  
        ELSE 0  
    END;