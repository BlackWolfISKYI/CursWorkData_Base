-- ================================================
-- Приклади SQL запитів для роботи з базою даних
-- База даних інтернет-магазину страйкбольного обладнання
-- ================================================

-- ================================================
-- РОЗДІЛ 1: ЗАПИТИ ВИБІРКИ (SELECT)
-- ================================================

-- 1.1. Вибірка всіх товарів з їх категоріями
SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.Brand,
    p.Price,
    p.StockQuantity,
    CASE 
        WHEN p.StockQuantity = 0 THEN 'Немає в наявності'
        WHEN p.StockQuantity < p.MinStockLevel THEN 'Мало на складі'
        ELSE 'В наявності'
    END AS StockStatus
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, p.ProductName;

GO

-- 1.2. Топ-10 найпопулярніших товарів (за кількістю продажів)
SELECT TOP 10
    p.ProductID,
    p.ProductName,
    p.Brand,
    COUNT(od.OrderDetailID) AS OrderCount,
    SUM(od.Quantity) AS TotalSold,
    SUM(od.TotalPrice) AS TotalRevenue
FROM Products p
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.Brand
ORDER BY TotalSold DESC;

GO

-- 1.3. Товари зі знижкою
SELECT 
    p.ProductName,
    p.Brand,
    p.Price AS OriginalPrice,
    p.Discount AS DiscountPercent,
    ROUND(p.Price * (1 - p.Discount / 100), 2) AS DiscountedPrice,
    ROUND(p.Price * p.Discount / 100, 2) AS SaveAmount
FROM Products p
WHERE p.Discount > 0 AND p.IsActive = 1
ORDER BY p.Discount DESC;

GO

-- 1.4. Середній рейтинг товарів з кількістю відгуків
SELECT 
    p.ProductID,
    p.ProductName,
    p.Brand,
    COUNT(r.ReviewID) AS ReviewCount,
    ROUND(AVG(r.Rating), 2) AS AverageRating
FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName, p.Brand
HAVING COUNT(r.ReviewID) > 0
ORDER BY AverageRating DESC, ReviewCount DESC;

GO

-- 1.5. Пошук товарів за діапазоном цін та категорією
SELECT 
    p.ProductName,
    p.Brand,
    c.CategoryName,
    p.Price,
    p.StockQuantity
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Price BETWEEN 1000 AND 5000
    AND c.CategoryName = 'Автомати'
    AND p.IsActive = 1
ORDER BY p.Price ASC;

GO

-- 1.6. Вибірка замовлень користувача з деталями
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Status,
    u.FirstName,
    u.LastName,
    STRING_AGG(p.ProductName, ', ') WITHIN GROUP (ORDER BY p.ProductName) AS Products,
    o.TotalAmount,
    o.PaymentStatus
FROM Orders o
INNER JOIN Users u ON o.UserID = u.UserID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE u.UserID = 3
GROUP BY o.OrderID, o.OrderDate, o.Status, u.FirstName, u.LastName, o.TotalAmount, o.PaymentStatus
ORDER BY o.OrderDate DESC;

GO

-- 1.7. Товари, яких мало на складі (потрібне поповнення)
SELECT 
    p.ProductName,
    p.Brand,
    c.CategoryName,
    p.StockQuantity,
    p.MinStockLevel,
    (p.MinStockLevel - p.StockQuantity) AS NeedToOrder
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.StockQuantity < p.MinStockLevel
ORDER BY NeedToOrder DESC;

GO

-- 1.8. Статистика продажів по категоріях
SELECT 
    c.CategoryName,
    COUNT(DISTINCT od.OrderID) AS OrderCount,
    SUM(od.Quantity) AS TotalItemsSold,
    ROUND(SUM(od.TotalPrice), 2) AS TotalRevenue,
    ROUND(AVG(od.UnitPrice), 2) AS AverageItemPrice
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalRevenue DESC;

GO

-- 1.9. Активні користувачі з кількістю замовлень
SELECT 
    u.UserID,
    u.FirstName,
    u.LastName,
    u.Email,
    COUNT(o.OrderID) AS TotalOrders,
    ROUND(SUM(o.TotalAmount), 2) AS TotalSpent,
    ROUND(AVG(o.TotalAmount), 2) AS AverageOrderValue
FROM Users u
INNER JOIN Orders o ON u.UserID = o.UserID
GROUP BY u.UserID, u.FirstName, u.LastName, u.Email
ORDER BY TotalSpent DESC;

GO

-- 1.10. Вміст кошика користувача
SELECT 
    u.FirstName,
    u.LastName,
    p.ProductName,
    p.Brand,
    p.Price,
    c.Quantity,
    ROUND(p.Price * (1 - p.Discount / 100) * c.Quantity, 2) AS TotalPrice
FROM Cart c
INNER JOIN Users u ON c.UserID = u.UserID
INNER JOIN Products p ON c.ProductID = p.ProductID
WHERE u.UserID = 3;

GO

-- ================================================
-- РОЗДІЛ 2: ЗАПИТИ ВСТАВКИ (INSERT)
-- ================================================

-- 2.1. Додавання нового товару
INSERT INTO Products (
    ProductName, CategoryID, SupplierID, Brand, Model, 
    Caliber, FPS, Magazine, PowerSource, Material, 
    Weight, Length, Color, Price, StockQuantity, Description
) VALUES (
    'Cyma CM.045 AKS-74U',
    7,  -- Автомати
    3,  -- CYMA
    'CYMA',
    'CM.045',
    '6мм',
    350,
    200,
    'Electric',
    'Metal',
    2300,
    650,
    'Black',
    4200.00,
    10,
    'Компактний автомат АКС-74У. Повнометалевий корпус, ідеально для CQB.'
);

-- 2.2. Додавання нового користувача
INSERT INTO Users (
    Email, PasswordHash, FirstName, LastName, 
    Phone, Address, City, PostalCode, RoleID
) VALUES (
    'new.user@example.com',
    'hash_new_password',
    'Сергій',
    'Новак',
    '+380509876543',
    'вул. Центральна, 100',
    'Полтава',
    '36000',
    2  -- Customer
);

-- 2.3. Додавання товару в кошик
MERGE Cart AS target
USING (SELECT 3 AS UserID, 5 AS ProductID, 1 AS Quantity) AS src
    ON target.UserID = src.UserID AND target.ProductID = src.ProductID
WHEN MATCHED THEN
    UPDATE SET Quantity = target.Quantity + src.Quantity
WHEN NOT MATCHED THEN
    INSERT (UserID, ProductID, Quantity) VALUES (src.UserID, src.ProductID, src.Quantity);

GO

-- 2.4. Створення нового замовлення
INSERT INTO Orders (
    UserID, ShippingAddress, ShippingCity, ShippingPostalCode, 
    ShippingPhone, SubTotal, ShippingCost, TotalAmount, 
    PaymentMethod, PaymentStatus
) VALUES (
    3,
    'вул. Соборна, 45',
    'Дніпро',
    '49000',
    '+380503456789',
    5200.00,
    90.00,
    5290.00,
    'Card',
    'Pending'
);

-- ================================================
-- РОЗДІЛ 3: ЗАПИТИ ОНОВЛЕННЯ (UPDATE)
-- ================================================

-- 3.1. Оновлення ціни товару
UPDATE Products 
SET Price = 3800.00, 
    UpdatedAt = SYSDATETIME()
WHERE ProductID = 1;

-- 3.2. Встановлення знижки на товари категорії
UPDATE Products 
SET Discount = 15.00
WHERE CategoryID = 7  -- Автомати
    AND Price > 5000;

-- 3.3. Зміна статусу замовлення
UPDATE Orders 
SET Status = 'Shipped',
    UpdatedAt = SYSDATETIME()
WHERE OrderID = 5;

-- 3.4. Оновлення залишків товару після продажу
UPDATE Products 
SET StockQuantity = StockQuantity - 1
WHERE ProductID = 1 AND StockQuantity > 0;

-- 3.5. Оновлення інформації про користувача
UPDATE Users 
SET Phone = '+380501112233',
    Address = 'вул. Нова, 25',
    City = 'Київ'
WHERE UserID = 3;

-- ================================================
-- РОЗДІЛ 4: ЗАПИТИ ВИДАЛЕННЯ (DELETE)
-- ================================================

-- 4.1. Видалення товару з кошика
DELETE FROM Cart 
WHERE UserID = 3 AND ProductID = 11;

-- 4.2. Видалення старих замовлень (відмінених більше року тому)
DELETE FROM Orders 
WHERE Status = 'Cancelled' 
    AND OrderDate < DATEADD(YEAR, -1, SYSDATETIME());

-- 4.3. Видалення неактивних товарів без продажів
DELETE FROM Products 
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails)
    AND IsActive = 0
    AND CreatedAt < DATEADD(MONTH, -6, SYSDATETIME());

-- ================================================
-- РОЗДІЛ 5: СКЛАДНІ ЗАПИТИ З ПІДЗАПИТАМИ
-- ================================================

-- 5.1. Товари дорожчі за середню ціну в категорії
SELECT 
    p.ProductName,
    p.Brand,
    c.CategoryName,
    p.Price,
    (SELECT ROUND(AVG(Price), 2) 
     FROM Products 
     WHERE CategoryID = p.CategoryID) AS AvgCategoryPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Price > (
    SELECT AVG(Price) 
    FROM Products 
    WHERE CategoryID = p.CategoryID
)
ORDER BY c.CategoryName, p.Price DESC;

-- 5.2. Користувачі, які не робили замовлень
SELECT 
    u.UserID,
    u.FirstName,
    u.LastName,
    u.Email,
    u.RegisteredAt
FROM Users u
WHERE u.UserID NOT IN (
    SELECT DISTINCT UserID FROM Orders
)
AND u.RoleID = 2  -- Тільки покупці
ORDER BY u.RegisteredAt DESC;

-- 5.3. Найбільше замовлення кожного користувача
SELECT 
    u.FirstName,
    u.LastName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Users u
INNER JOIN Orders o ON u.UserID = o.UserID
WHERE o.TotalAmount = (
    SELECT MAX(TotalAmount)
    FROM Orders
    WHERE UserID = u.UserID
);

GO

-- ================================================
-- РОЗДІЛ 6: ПРЕДСТАВЛЕННЯ (VIEWS)
-- ================================================

-- 6.1. Представлення каталогу товарів
CREATE OR ALTER VIEW vw_ProductCatalog AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Brand,
    p.Model,
    c.CategoryName,
    s.SupplierName,
    p.Price,
    p.Discount,
    ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice,
    p.StockQuantity,
    COALESCE(AVG(r.Rating), 0) AS AverageRating,
    COUNT(r.ReviewID) AS ReviewCount,
    p.IsFeatured,
    p.IsActive
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName, p.Brand, p.Model, c.CategoryName, 
         s.SupplierName, p.Price, p.Discount, p.StockQuantity, p.IsFeatured, p.IsActive;

GO

-- 6.2. Представлення історії замовлень
CREATE OR ALTER VIEW vw_OrderHistory AS
SELECT 
    o.OrderID,
    o.OrderDate,
    u.FirstName,
    u.LastName,
    u.Email,
    o.Status,
    o.PaymentStatus,
    o.PaymentMethod,
    o.TotalAmount,
    COUNT(od.OrderDetailID) AS ItemCount
FROM Orders o
INNER JOIN Users u ON o.UserID = u.UserID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate, u.FirstName, u.LastName, u.Email, 
         o.Status, o.PaymentStatus, o.PaymentMethod, o.TotalAmount;

GO

-- ================================================
-- РОЗДІЛ 7: ЗБЕРЕЖЕНІ ПРОЦЕДУРИ
-- ================================================

CREATE OR ALTER PROCEDURE CreateOrderFromCart
    @UserID INT,
    @ShippingAddress NVARCHAR(MAX),
    @ShippingCity NVARCHAR(50),
    @ShippingPostalCode NVARCHAR(10),
    @ShippingPhone NVARCHAR(20),
    @PaymentMethod NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SubTotal DECIMAL(10,2);
    DECLARE @ShippingCost DECIMAL(10,2);
    DECLARE @TotalAmount DECIMAL(10,2);
    DECLARE @OrderID INT;

    SELECT @SubTotal = SUM(p.Price * (1 - p.Discount / 100) * c.Quantity)
    FROM Cart c
    INNER JOIN Products p ON c.ProductID = p.ProductID
    WHERE c.UserID = @UserID;

    IF @SubTotal IS NULL
    BEGIN
        RAISERROR(N'Кошик порожній', 16, 1);
        RETURN;
    END;

    SET @ShippingCost = CASE 
        WHEN @SubTotal >= 5000 THEN 0
        WHEN @SubTotal >= 2000 THEN 50
        ELSE 80
    END;

    SET @TotalAmount = @SubTotal + @ShippingCost;

    INSERT INTO Orders (
        UserID, ShippingAddress, ShippingCity, ShippingPostalCode,
        ShippingPhone, SubTotal, ShippingCost, TotalAmount, PaymentMethod
    ) VALUES (
        @UserID, @ShippingAddress, @ShippingCity, @ShippingPostalCode,
        @ShippingPhone, @SubTotal, @ShippingCost, @TotalAmount, @PaymentMethod
    );

    SET @OrderID = SCOPE_IDENTITY();

    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice)
    SELECT 
        @OrderID,
        c.ProductID,
        c.Quantity,
        p.Price,
        p.Discount,
        ROUND(p.Price * (1 - p.Discount / 100) * c.Quantity, 2)
    FROM Cart c
    INNER JOIN Products p ON c.ProductID = p.ProductID
    WHERE c.UserID = @UserID;

    UPDATE p
    SET p.StockQuantity = p.StockQuantity - c.Quantity
    FROM Products p
    INNER JOIN Cart c ON p.ProductID = c.ProductID
    WHERE c.UserID = @UserID;

    DELETE FROM Cart WHERE UserID = @UserID;

    SELECT @OrderID AS NewOrderID;
END;

GO
CREATE OR ALTER PROCEDURE SearchProducts
    @SearchTerm NVARCHAR(200) = NULL,
    @CategoryID INT = NULL,
    @MinPrice DECIMAL(10,2) = NULL,
    @MaxPrice DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ProductID,
        p.ProductName,
        p.Brand,
        c.CategoryName,
        p.Price,
        p.Discount,
        ROUND(p.Price * (1 - p.Discount / 100), 2) AS FinalPrice,
        p.StockQuantity
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE p.IsActive = 1
        AND (@SearchTerm IS NULL OR p.ProductName LIKE '%' + @SearchTerm + '%')
        AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice)
    ORDER BY p.ProductName;
END;

-- ================================================
-- РОЗДІЛ 8: ТРИГЕРИ
-- ================================================

GO
CREATE OR ALTER TRIGGER trg_Products_UpdatedAt
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET UpdatedAt = SYSDATETIME()
    FROM Products p
    INNER JOIN inserted i ON p.ProductID = i.ProductID;
END;

GO
CREATE OR ALTER TRIGGER trg_Cart_CheckStock
ON Cart
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Products p ON i.ProductID = p.ProductID
        WHERE i.Quantity > p.StockQuantity
    )
    BEGIN
        RAISERROR(N'Недостатньо товару на складі', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-- ================================================
-- РОЗДІЛ 9: АНАЛІТИЧНІ ЗАПИТИ
-- ================================================

-- 9.1. Продажі по місяцях
SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS [Month],
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue,
    AVG(TotalAmount) AS AverageOrderValue
FROM Orders
WHERE Status <> 'Cancelled'
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY [Month] DESC;

-- 9.2. Найприбутковіші постачальники
SELECT 
    s.SupplierName,
    s.Country,
    COUNT(DISTINCT p.ProductID) AS ProductCount,
    SUM(od.Quantity) AS TotalItemsSold,
    ROUND(SUM(od.TotalPrice), 2) AS TotalRevenue
FROM Suppliers s
INNER JOIN Products p ON s.SupplierID = p.SupplierID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.SupplierName, s.Country
ORDER BY TotalRevenue DESC;

-- 9.3. Конверсія кошика в замовлення
SELECT 
    'Користувачів з товарами в кошику' AS Metric,
    COUNT(DISTINCT UserID) AS Value
FROM Cart
UNION ALL
SELECT 
    'Користувачів зі замовленнями' AS Metric,
    COUNT(DISTINCT UserID) AS Value
FROM Orders;

GO

-- ================================================
-- Завершення SQL скриптів
-- ================================================
