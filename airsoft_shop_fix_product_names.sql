-- Fix product names with incorrectly encoded question marks
-- Run against: airsoft_shop (localdb)\MSSQLLocalDB

SET NOCOUNT ON;

-- ASG Blaster BB 0.12g 2000?? -> 2000 pcs
UPDATE Products
SET ProductName = N'ASG Blaster BB 0.12g 2000 pcs'
WHERE ProductID = 31 OR ProductName LIKE '%ASG Blaster BB 0.12g 2000??%';

-- BLS Precision BB 0.20g 5000?? -> 5000 pcs
UPDATE Products
SET ProductName = N'BLS Precision BB 0.20g 5000 pcs'
WHERE ProductID = 29 OR ProductName LIKE '%BLS Precision BB 0.20g 5000??%';

-- G&G Bio BB 0.25g 4000?? -> 4000 pcs
UPDATE Products
SET ProductName = N'G&G Bio BB 0.25g 4000 pcs'
WHERE ProductID = 28 OR ProductName LIKE '%G&G Bio BB 0.25g 4000??%';

-- Nuprol RZR BB 0.28g 3300?? -> 3300 pcs
UPDATE Products
SET ProductName = N'Nuprol RZR BB 0.28g 3300 pcs'
WHERE ProductID = 30 OR ProductName LIKE '%Nuprol RZR BB 0.28g 3300??%';

-- Element LA-5 PEQ-15 (?????) -> Dummy
UPDATE Products
SET ProductName = N'Element LA-5 PEQ-15 (dummy)'
WHERE ProductID = 34 OR ProductName LIKE '%Element LA-5 PEQ-15 (?????)%';

-- Element M300 ?????? ????????? -> Tactical Flashlight
UPDATE Products
SET ProductName = N'Element M300 Tactical Flashlight'
WHERE ProductID = 32 OR ProductName LIKE '%Element M300 ?????? ?????????%';

-- Holosun HS403B Red Dot (???????) -> Red Dot Sight
UPDATE Products
SET ProductName = N'Holosun HS403B Red Dot Sight'
WHERE ProductID = 33 OR ProductName LIKE '%Holosun HS403B Red Dot (???????)%';

PRINT N'Назви товарів оновлено';
