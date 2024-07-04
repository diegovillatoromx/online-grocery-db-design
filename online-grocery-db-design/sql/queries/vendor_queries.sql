-- 1. Total inventory cost per vendor
SELECT 
    v.vendor_name AS VendorName,
    SUM(iv.cost * iv.quantity_on_hand) AS TotalInventoryCost
FROM 
    Inventory iv
JOIN 
    Vendors v ON iv.vendor_id = v.vendor_id
GROUP BY 
    v.vendor_name
ORDER BY 
    TotalInventoryCost DESC;
