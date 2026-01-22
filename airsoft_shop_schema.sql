-- ================================================
-- База даних інтернет-магазину страйкбольного обладнання
-- Курсова робота з дисципліни "Бази даних"
-- ================================================

DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS UserRoles;

-- ================================================
CREATE TABLE UserRoles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT SYSDATETIME()
);

-- ================================================
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(MAX),
    City NVARCHAR(50),
    PostalCode NVARCHAR(10),
    RoleID INT DEFAULT 2,
    IsActive BIT DEFAULT 1,
    RegisteredAt DATETIME2 DEFAULT SYSDATETIME(),
    LastLogin DATETIME2 NULL,
    FOREIGN KEY (RoleID) REFERENCES UserRoles(RoleID)
);

-- ================================================
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(MAX),
    Country NVARCHAR(50),
    Website NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME()
);

-- ================================================
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    ParentCategoryID INT NULL,
    Description NVARCHAR(MAX),
    ImageURL NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID) ON DELETE NO ACTION
);

-- ================================================
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    SupplierID INT,
    Description NVARCHAR(MAX),
    -- Технічні характеристики
    Brand NVARCHAR(50),
    Model NVARCHAR(100),
    Caliber NVARCHAR(20),          -- Калібр (6мм, 8мм)
    FPS INT,                       -- Швидкість кулі (feet per second)
    Magazine INT,                  -- Ємність магазину
    PowerSource NVARCHAR(50),      -- Джерело живлення (Electric, Gas, Spring)
    Material NVARCHAR(100),        -- Матеріал (Polymer, Metal, ABS)
    Weight DECIMAL(8,2),           -- Вага в грамах
    Length DECIMAL(8,2),           -- Довжина в мм
    Color NVARCHAR(50),
    -- Комерційна інформація
    Price DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(5,2) DEFAULT 0.00, -- Знижка у відсотках
    StockQuantity INT DEFAULT 0,
    MinStockLevel INT DEFAULT 5,
    -- Додаткова інформація
    ImageURL NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    IsFeatured BIT DEFAULT 0,  -- Популярний товар
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE SET NULL
);

-- ================================================
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Title NVARCHAR(100),
    Comment NVARCHAR(MAX),
    IsVerifiedPurchase BIT DEFAULT 0,
    IsPublished BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- ================================================
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT SYSDATETIME(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending','Processing','Shipped','Delivered','Cancelled')),
    -- Інформація про доставку
    ShippingAddress NVARCHAR(MAX) NOT NULL,
    ShippingCity NVARCHAR(50) NOT NULL,
    ShippingPostalCode NVARCHAR(10),
    ShippingPhone NVARCHAR(20),
    -- Фінансова інформація
    SubTotal DECIMAL(10,2) NOT NULL,
    ShippingCost DECIMAL(10,2) DEFAULT 0.00,
    TotalAmount DECIMAL(10,2) NOT NULL,
    -- Додаткова інформація
    PaymentMethod NVARCHAR(10) NOT NULL DEFAULT 'Cash' CHECK (PaymentMethod IN ('Cash','Card','Online')),
    PaymentStatus NVARCHAR(10) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending','Paid','Refunded')),
    Notes NVARCHAR(MAX),
    UpdatedAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ================================================
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(5,2) DEFAULT 0.00,
    TotalPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ================================================
CREATE TABLE Cart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    AddedAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT unique_cart_item UNIQUE (UserID, ProductID)
);

-- ================================================
-- Створення індексів для оптимізації запитів
-- ================================================

-- Індекси для пошуку товарів
CREATE INDEX idx_products_category ON Products(CategoryID);
CREATE INDEX idx_products_supplier ON Products(SupplierID);
CREATE INDEX idx_products_price ON Products(Price);
CREATE INDEX idx_products_name ON Products(ProductName);
CREATE INDEX idx_products_active ON Products(IsActive);

-- Індекси для користувачів
CREATE INDEX idx_users_email ON Users(Email);
CREATE INDEX idx_users_role ON Users(RoleID);

-- Індекси для замовлень
CREATE INDEX idx_orders_user ON Orders(UserID);
CREATE INDEX idx_orders_date ON Orders(OrderDate);
CREATE INDEX idx_orders_status ON Orders(Status);

-- Індекси для деталей замовлення
CREATE INDEX idx_orderdetails_order ON OrderDetails(OrderID);
CREATE INDEX idx_orderdetails_product ON OrderDetails(ProductID);

-- Індекси для відгуків
CREATE INDEX idx_reviews_product ON Reviews(ProductID);
CREATE INDEX idx_reviews_user ON Reviews(UserID);
CREATE INDEX idx_reviews_rating ON Reviews(Rating);

-- Індекси для кошика
CREATE INDEX idx_cart_user ON Cart(UserID);
CREATE INDEX idx_cart_product ON Cart(ProductID);

GO

-- ================================================
-- Схема БД створена успішно
-- ================================================
