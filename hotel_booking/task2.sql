WITH CustomerAnalysis AS (  
    SELECT  
        c.ID_customer,  
        c.name,  
        COUNT(b.ID_booking) AS total_bookings,  
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,  
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels  
    FROM  
        Customer c  
    JOIN  
        Booking b ON c.ID_customer = b.ID_customer  
    JOIN  
        Room r ON b.ID_room = r.ID_room  
    JOIN  
        Hotel h ON r.ID_hotel = h.ID_hotel  
    GROUP BY  
        c.ID_customer  
    HAVING  
        COUNT(DISTINCT h.ID_hotel) > 1 AND COUNT(b.ID_booking) > 2  
),  
HighSpendingCustomers AS (  
    SELECT  
        c.ID_customer,  
        c.name,  
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,  
        COUNT(b.ID_booking) AS total_bookings  
    FROM  
        Customer c  
    JOIN  
        Booking b ON c.ID_customer = b.ID_customer  
    JOIN  
        Room r ON b.ID_room = r.ID_room  
    GROUP BY  
        c.ID_customer  
    HAVING  
        SUM(r.price * (b.check_out_date - b.check_in_date)) > 500  
)  

SELECT  
    ca.ID_customer,  
    ca.name,  
    ca.total_bookings,  
    ca.total_spent,  
    ca.unique_hotels  
FROM  
    CustomerAnalysis ca  
JOIN  
    HighSpendingCustomers hsc ON ca.ID_customer = hsc.ID_customer  
ORDER BY  
    ca.total_spent ASC;