-- 1. Current inventory of each item
SELECT 
    i.description AS ItemDescription,
    SUM(iv.quantity_on_hand) AS TotalQuantityOnHand
FROM 
    Inventory iv
JOIN 
    Items i ON iv.item_id = i.item_id
GROUP BY 
    i.description
ORDER BY 
    TotalQuantityOnHand DESC;

-- 2. Inventory by location
SELECT 
    i.location AS Location,
    i.description AS ItemDescription,
    SUM(iv.quantity_on_hand) AS TotalQuantityOnHand
FROM 
    Inventory iv
JOIN 
    Items i ON iv.item_id = i.item_id
GROUP BY 
    i.location, i.description
ORDER BY 
    i.location, TotalQuantityOnHand DESC;
