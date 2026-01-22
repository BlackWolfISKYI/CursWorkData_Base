-- ================================================
-- Заповнення бази даних тестовими даними
-- База даних інтернет-магазину страйкбольного обладнання
-- ================================================

USE airsoft_shop;
GO

-- ================================================
-- Очистка таблиць перед імпортом (видалення старих даних)
-- ================================================
DELETE FROM Cart;
DELETE FROM OrderDetails;
DELETE FROM Orders;
DELETE FROM Reviews;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Suppliers;
DELETE FROM Users;
DELETE FROM UserRoles;
GO

-- ================================================
-- 1. Додавання ролей користувачів
-- ================================================
INSERT INTO UserRoles (RoleName, Description) VALUES
(N'Administrator', N'Адміністратор системи з повним доступом'),
(N'Customer', N'Звичайний покупець'),
(N'Manager', N'Менеджер магазину'),
(N'Moderator', N'Модератор відгуків та контенту');
GO

-- ================================================
-- 2. Додавання користувачів
-- ================================================
INSERT INTO Users (Email, PasswordHash, FirstName, LastName, Phone, Address, City, PostalCode, RoleID) VALUES
('admin@airsoft.com', 'hash_admin_password', N'Олександр', N'Коваленко', '+380501234567', N'вул. Хрещатик, 1', N'Київ', '01001', 1),
('manager@airsoft.com', 'hash_manager_password', N'Марина', N'Петренко', '+380502345678', N'вул. Шевченка, 25', N'Львів', '79000', 3),
('ivan.ivanov@gmail.com', 'hash_password_1', N'Іван', N'Іванов', '+380503456789', N'вул. Соборна, 45', N'Дніпро', '49000', 2),
('petro.petrenko@gmail.com', 'hash_password_2', N'Петро', N'Петренко', '+380504567890', N'просп. Миру, 78', N'Одеса', '65000', 2),
('anna.sidorenko@gmail.com', 'hash_password_3', N'Анна', N'Сидоренко', '+380505678901', N'вул. Набережна, 12', N'Харків', '61000', 2),
('oleh.bondar@gmail.com', 'hash_password_4', N'Олег', N'Бондар', '+380506789012', N'вул. Перемоги, 33', N'Запоріжжя', '69000', 2),
('maria.koval@gmail.com', 'hash_password_5', N'Марія', N'Коваль', '+380507890123', N'вул. Лесі Українки, 56', N'Вінниця', '21000', 2);
GO

-- ================================================
-- 3. Додавання постачальників
-- ================================================
INSERT INTO Suppliers (SupplierName, ContactPerson, Email, Phone, Address, Country, Website) VALUES
(N'Tokyo Marui', N'Yamamoto Takeshi', 'sales@tokyomarui.jp', '+81-3-1234-5678', N'Tokyo, Japan', N'Japan', 'www.tokyo-marui.co.jp'),
(N'Cybergun', N'Jean-Pierre Dubois', 'contact@cybergun.com', '+33-1-2345-6789', N'Paris, France', N'France', 'www.cybergun.com'),
(N'G&G Armament', N'Chen Wei', 'info@gandg.com.tw', '+886-2-1234-5678', N'Taipei, Taiwan', N'Taiwan', 'www.guay2.com'),
(N'ASG (ActionSportGames)', N'Lars Nielsen', 'sales@actionSportgames.com', '+45-12-34-56-78', N'Copenhagen, Denmark', N'Denmark', 'www.actionsportgames.com'),
(N'Evolution Airsoft', N'Dmytro Shevchenko', 'info@evolution-airsoft.com', '+380-44-123-4567', N'вул. Промислова, 15, Київ', N'Ukraine', 'www.evolution-airsoft.com'),
(N'Specna Arms', N'Andrzej Kowalski', 'contact@specna-arms.com', '+48-22-123-4567', N'Warsaw, Poland', N'Poland', 'www.specna-arms.com');
GO

-- ================================================
-- 4. Додавання категорій товарів
-- ================================================
INSERT INTO Categories (CategoryName, ParentCategoryID, Description) VALUES
-- Основні категорії
(N'Зброя', NULL, N'Страйкбольна зброя всіх типів'),
(N'Екіпірування', NULL, N'Тактичне екіпірування та спорядження'),
(N'Захист', NULL, N'Засоби індивідуального захисту'),
(N'Аксесуари', NULL, N'Додаткові аксесуари та приладдя'),
(N'Боєприпаси', NULL, N'Кулі та пневматичні баллони'),
(N'Запчастини', NULL, N'Запасні частини та комплектуючі'),

-- Підкатегорії зброї
(N'Автомати', 1, N'Страйкбольні автомати'),
(N'Пістолети', 1, N'Страйкбольні пістолети'),
(N'Снайперські гвинтівки', 1, N'Снайперські гвинтівки для страйкболу'),
(N'Дробовики', 1, N'Страйкбольні дробовики'),
(N'Кулемети', 1, N'Ручні та станкові кулемети'),

-- Підкатегорії екіпірування
(N'Розвантажувальні системи', 2, N'Розвантажки, пояси, жилети'),
(N'Рюкзаки', 2, N'Тактичні рюкзаки'),
(N'Кобури', 2, N'Кобури для пістолетів'),
(N'Підсумки', 2, N'Підсумки для магазинів та екіпірування'),

-- Підкатегорії захисту
(N'Окуляри та маски', 3, N'Захисні окуляри та маски'),
(N'Шоломи', 3, N'Тактичні шоломи'),
(N'Бронежилети', 3, N'Імітаційні бронежилети'),
(N'Наколінники та налокітники', 3, N'Захист суглобів');
GO

-- ================================================
-- 5. Додавання товарів
-- ================================================
INSERT INTO Products (ProductName, CategoryID, SupplierID, Brand, Model, Caliber, FPS, Magazine, PowerSource, Material, Weight, Length, Color, Price, Discount, StockQuantity, Description, IsFeatured) VALUES
('Cyma CM.028 AK47', 7, 3, N'CYMA', N'CM.028', N'6мм', 380, 600, N'Electric', N'Metal/Polymer', 2800, 870, N'Black', 3500.00, 0, 15, N'Класична модель АК-47. Повнометалевий корпус, дерев''яне ложе. Надійна конструкція для початківців.', 1),
('G&G CM16 Raider', 7, 3, N'G&G', N'CM16 Raider', N'6мм', 350, 300, N'Electric', N'Polymer', 2400, 730, N'Black', 5200.00, 10, 12, N'Популярний M4 карабін. Легкий полімерний корпус, хороша точність стрільби.', 1),
('Tokyo Marui AK47 HC', 7, 1, N'Tokyo Marui', N'AK47 HC', N'6мм', 300, 500, N'Electric', N'Metal/Plastic', 3200, 880, N'Black', 12500.00, 0, 5, N'Преміум модель від Tokyo Marui. Високоточна система, чудова якість збірки.', 0),
('Specna Arms SA-C01 CORE', 7, 6, N'Specna Arms', N'SA-C01', N'6мм', 370, 300, N'Electric', N'Metal', 2900, 680, N'Black', 4800.00, 5, 20, N'Компактний М4 карабін. Повнометалевий корпус, швидкозмінна пружина.', 1),
('Cybergun FAMAS F1 EVO', 7, 2, N'Cybergun', N'FAMAS F1', N'6мм', 340, 300, N'Electric', N'Polymer', 2600, 757, N'Black', 6500.00, 0, 8, N'Французький автомат bullpup конфігурації. Компактний та ергономічний.', 0),
('Tokyo Marui Glock 17', 8, 1, N'Tokyo Marui', N'Glock 17', N'6мм', 280, 25, N'Gas', N'Polymer', 680, 186, N'Black', 4200.00, 0, 18, N'Легендарний Glock 17. Газова система blowback, точна копія оригіналу.', 1),
('Cybergun Colt 1911', 8, 2, N'Cybergun', N'1911 A1', N'6мм', 300, 20, N'Gas', N'Metal', 920, 210, N'Black', 3800.00, 15, 22, N'Класичний американський пістолет. Повнометалевий корпус.', 0),
('ASG CZ P-09', 8, 4, N'ASG', N'CZ P-09', N'6мм', 320, 24, N'Gas', N'Polymer', 750, 195, N'Black', 3500.00, 0, 25, N'Чеський пістолет з надійною газовою системою.', 1),
('WE Beretta M9', 8, 3, N'WE', N'M9A1', N'6мм', 310, 28, N'Gas', N'Metal', 880, 217, N'Black', 3200.00, 10, 15, N'Італійський пістолет M9. Металевий корпус, потужний відкат.', 0),
('WELL MB4403D', 9, 3, N'WELL', N'MB4403D', N'6мм', 450, 30, N'Spring', N'Metal/Polymer', 2100, 1100, N'Black', 4500.00, 0, 10, N'Снайперська гвинтівка L96. Болтова система, висока початкова швидкість.', 1),
('Tokyo Marui VSR-10 G-Spec', 9, 1, N'Tokyo Marui', N'VSR-10', N'6мм', 280, 30, N'Spring', N'Metal/Plastic', 1950, 1010, N'Black', 8900.00, 0, 6, N'Преміум снайперка від Tokyo Marui. Легендарна точність.', 0),
('Cybergun FN SPR A5M', 9, 2, N'Cybergun', N'SPR A5M', N'6мм', 380, 30, N'Spring', N'Metal/Polymer', 2400, 1150, N'OD Green', 5800.00, 5, 8, N'Тактична снайперська гвинтівка. Складний приклад.', 0),
('A&K PKM', 11, 3, N'A&K', N'PKM', N'6мм', 400, 2500, N'Electric', N'Metal', 5200, 1165, N'Black', 13500.00, 0, 4, N'Ручний кулемет PKM. Коробковий магазин, імітація стрічкового живлення.', 0),
('G&P M249 SAW', 11, 3, N'G&P', N'M249', N'6мм', 380, 1500, N'Electric', N'Metal', 4800, 1040, N'Black', 15200.00, 10, 3, N'Американський ручний кулемет. Преміум якість збірки.', 1),
('Viper Tactical VX Buckle Up Carrier', 12, 4, N'Viper', N'VX Buckle Up', NULL, NULL, NULL, NULL, N'Nylon', 1200, NULL, N'Coyote', 2800.00, 0, 30, N'Тактичний розвантажувальний жилет. Система MOLLE, швидке застібання.', 1),
('8Fields Chest Rig', 12, 5, N'8Fields', N'Chest Rig', NULL, NULL, NULL, NULL, N'Nylon', 650, NULL, N'Multicam', 1500.00, 20, 45, N'Легка розвантажка формату Chest Rig. Ідеально для динамічної гри.', 0),
('Pantac Mini MAP', 12, 4, N'Pantac', N'Mini MAP', NULL, NULL, NULL, NULL, N'Cordura', 890, NULL, N'Black', 2200.00, 0, 25, N'Мінімалістична розвантажка для M4 магазинів.', 0),
('Mil-Tec Assault Pack 36L', 13, 4, N'Mil-Tec', N'Assault 36L', NULL, NULL, NULL, NULL, N'Polyester', 780, NULL, N'Olive', 1200.00, 0, 40, N'Тактичний рюкзак 36 літрів. Система MOLLE, гідратор.', 1),
('Condor 3-Day Assault Pack', 13, 4, N'Condor', N'3-Day', NULL, NULL, NULL, NULL, N'Nylon', 1100, NULL, N'Multicam', 2800.00, 15, 20, N'Якісний рюкзак на 3 дні. Міцна конструкція.', 0),
('Cytac CY-G17 Fast Draw', 14, 4, N'Cytac', N'CY-G17', NULL, NULL, NULL, NULL, N'Polymer', 120, NULL, N'Black', 650.00, 0, 50, N'Полімерна кобура для Glock. Система швидкого витягування.', 1),
('Uncle Mike''s Hip Holster', 14, 4, N'Uncle Mike', N'Hip Holster', NULL, NULL, NULL, NULL, N'Nylon', 85, NULL, N'Black', 350.00, 10, 60, N'Універсальна нейлонова кобура. Підходить для більшості пістолетів.', 0),
('Pyramex I-Force', 16, 4, N'Pyramex', N'I-Force', NULL, NULL, NULL, NULL, N'Polycarbonate', 95, NULL, N'Clear', 450.00, 0, 70, N'Захисні окуляри з антизапотіванням. Відповідають стандартам безпеки.', 1),
('Emerson Steel Mesh Mask', 16, 5, N'Emerson', N'Steel Mesh', NULL, NULL, NULL, NULL, N'Steel', 180, NULL, N'Black', 320.00, 0, 80, N'Сітчаста маска для захисту обличчя. Не запотіває.', 1),
('OneTigris Foldable Mesh Mask', 16, 5, N'OneTigris', N'Foldable', NULL, NULL, NULL, NULL, N'Steel', 155, NULL, N'Tan', 280.00, 15, 65, N'Складна захисна маска. Зручна для транспортування.', 0),
('Valken Tango Thermal Goggles', 16, 4, N'Valken', N'Tango', NULL, NULL, NULL, NULL, N'Polymer', 210, NULL, N'Black', 890.00, 0, 40, N'Подвійна лінза з термозахистом. Максимальна видимість.', 0),
('Emerson FAST Helmet', 17, 5, N'Emerson', N'FAST PJ', NULL, NULL, NULL, NULL, N'ABS', 520, NULL, N'Black', 1450.00, 0, 30, N'Тактичний шолом типу FAST. Рейки для кріплення аксесуарів.', 1),
('FMA Maritime Helmet', 17, 5, N'FMA', N'Maritime', NULL, NULL, NULL, NULL, N'ABS', 480, NULL, N'Tan', 1350.00, 10, 25, N'Легкий шолом Maritime. Підходить для динамічних ігор.', 0),
('G&G Bio BB 0.25g 4000шт', 5, 3, N'G&G', N'Bio BB', N'6мм', NULL, NULL, NULL, N'Bio-degradable', 1000, NULL, N'White', 280.00, 0, 150, N'Біорозкладні кулі 0.25г. Пляшка 4000 шт.', 1),
('BLS Precision BB 0.20g 5000шт', 5, 4, N'BLS', N'Precision', N'6мм', NULL, NULL, NULL, N'Plastic', 1250, NULL, N'White', 320.00, 0, 200, N'Високоточні кулі 0.20г. Мішок 5000 шт.', 1),
('Nuprol RZR BB 0.28g 3300шт', 5, 4, N'Nuprol', N'RZR', N'6мм', NULL, NULL, NULL, N'Polymer', 990, NULL, N'White', 350.00, 5, 120, N'Преміум кулі для снайперів. 0.28г, 3300 шт.', 0),
('ASG Blaster BB 0.12g 2000шт', 5, 4, N'ASG', N'Blaster', N'6мм', NULL, NULL, NULL, N'Plastic', 400, NULL, N'White', 120.00, 0, 250, N'Бюджетні кулі для тренувань. 0.12г, 2000 шт.', 0),
('Element M300 Ліхтар тактичний', 4, 5, N'Element', N'M300', NULL, NULL, NULL, NULL, N'Aluminum', 125, 140, N'Black', 850.00, 0, 45, N'Тактичний ліхтар з кріпленням на планку. 400 люменів.', 1),
('Holosun HS403B Red Dot (репліка)', 4, 5, N'Holosun', N'HS403B', NULL, NULL, NULL, NULL, N'Aluminum', 180, 80, N'Black', 1650.00, 10, 35, N'Коліматорний приціл. Червона точка, 11 рівнів яскравості.', 1),
('Element LA-5 PEQ-15 (муляж)', 4, 5, N'Element', N'PEQ-15', NULL, NULL, NULL, NULL, N'Aluminum', 95, 90, N'Black', 750.00, 0, 28, N'Муляж лазерного цілевказівника. Кріплення на планку.', 0),
('Magpul RVG Vertical Grip', 4, 5, N'Magpul', N'RVG', NULL, NULL, NULL, NULL, N'Polymer', 85, 89, N'Black', 420.00, 0, 55, N'Вертикальна рукоятка. Полімерна конструкція.', 0),
('UTG 4x32 Compact Scope', 4, 5, N'UTG', N'4x32', NULL, NULL, NULL, NULL, N'Aluminum', 340, 275, N'Black', 1250.00, 15, 22, N'Оптичний приціл 4-кратне збільшення. З підсвіткою сітки.', 0);
GO

-- ================================================
-- 6. Додавання відгуків
-- ================================================
INSERT INTO Reviews (ProductID, UserID, Rating, Title, Comment, IsVerifiedPurchase) VALUES
(1, 3, 5, N'Відмінний автомат для початку!', N'Купив як першу страйкбольну зброю. Дуже задоволений! Міцний, надійний, стріляє точно. Рекомендую новачкам.', 1),
(1, 4, 4, N'Хороша ціна-якість', N'За свої гроші - супер. Єдиний мінус - трохи важкий для тривалих ігор.', 1),
(2, 5, 5, N'Ідеальний M4!', N'Легкий, зручний, точний. Відмінний вибір для CQB. Купував з знижкою - вкрай задоволений.', 1),
(6, 3, 5, N'Tokyo Marui - це якість!', N'Пістолет просто бомба! Відкат реалістичний, газ тримає довго. Варто своїх грошей.', 1),
(6, 6, 5, N'Кращий Glock!', N'Маю вже рік - жодних проблем. Точність на висоті, надійність 100%.', 1),
(15, 7, 4, N'Добрий жилет', N'Якісний матеріал, зручно сидить. Мінус зірка за ціну - трохи дорого.', 1),
(23, 4, 5, N'Чудовий ліхтар', N'Яскравий, міцний корпус, зручне кріплення. Для страйкболу - те що треба!', 1),
(25, 5, 3, N'Середня якість', N'Для початківців підійде, але є нюанси з точністю. За ці гроші можна знайти краще.', 0),
(10, 6, 5, N'Снайперка мрії!', N'WELL MB4403D - монстр! Дальність стрільби вражає. Точність відмінна після налаштування хопапу.', 1),
(20, 7, 5, N'Must have!', N'Окуляри дуже якісні, не запотівають навіть у спеку. Зручно сидять, не тиснуть.', 1);
GO

-- ================================================
-- 7. Додавання замовлень
-- ================================================
INSERT INTO Orders (UserID, Status, ShippingAddress, ShippingCity, ShippingPostalCode, ShippingPhone, SubTotal, ShippingCost, TotalAmount, PaymentMethod, PaymentStatus) VALUES
(3, N'Delivered', N'вул. Соборна, 45', N'Дніпро', '49000', '+380503456789', 8350.00, 100.00, 8450.00, N'Card', N'Paid'),
(4, N'Delivered', N'просп. Миру, 78', N'Одеса', '65000', '+380504567890', 4680.00, 80.00, 4760.00, N'Online', N'Paid'),
(5, N'Shipped', N'вул. Набережна, 12', N'Харків', '61000', '+380505678901', 2730.00, 80.00, 2810.00, N'Cash', N'Pending'),
(6, N'Processing', N'вул. Перемоги, 33', N'Запоріжжя', '69000', '+380506789012', 6150.00, 90.00, 6240.00, N'Card', N'Paid'),
(7, N'Pending', N'вул. Лесі Українки, 56', N'Вінниця', '21000', '+380507890123', 1900.00, 70.00, 1970.00, N'Cash', N'Pending'),
(3, N'Delivered', N'вул. Соборна, 45', N'Дніпро', '49000', '+380503456789', 1485.00, 50.00, 1535.00, N'Online', N'Paid');
GO

-- ================================================
-- 8. Додавання деталей замовлень
-- ================================================
-- Замовлення 1 (UserID=3): АК-47 + Glock + окуляри
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice) VALUES
(1, 1, 1, 3500.00, 0.00, 3500.00),
(1, 6, 1, 4200.00, 0.00, 4200.00),
(1, 20, 1, 450.00, 0.00, 450.00),
(1, 26, 1, 280.00, 0.00, 280.00);
GO

-- Замовлення 2 (UserID=4): G&G Raider + аксесуари
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice) VALUES
(2, 2, 1, 5200.00, 10.00, 4680.00),
(2, 26, 2, 280.00, 0.00, 560.00);
GO

-- Замовлення 3 (UserID=5): Specna Arms + боєприпаси
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice) VALUES
(3, 4, 1, 4800.00, 5.00, 4560.00),
(3, 27, 2, 320.00, 0.00, 640.00);
GO

-- Замовлення 4 (UserID=6): Снайперка + оптика
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice) VALUES
(4, 10, 1, 4500.00, 0.00, 4500.00),
(4, 32, 1, 1250.00, 15.00, 1062.50),
(4, 28, 2, 350.00, 5.00, 665.00);
GO

-- Замовлення 5 (UserID=7): Екіпірування
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice) VALUES
(5, 16, 1, 1500.00, 20.00, 1200.00),
(5, 20, 1, 450.00, 0.00, 450.00),
(5, 21, 1, 320.00, 0.00, 320.00);
GO

-- Замовлення 6 (UserID=3): Ліхтар + приціл
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount, TotalPrice) VALUES
(6, 29, 1, 850.00, 0.00, 850.00),
(6, 30, 1, 1650.00, 10.00, 1485.00);
GO

-- ================================================
-- 9. Додавання товарів до кошика
-- ================================================
INSERT INTO Cart (UserID, ProductID, Quantity) VALUES
(3, 11, 1),
(4, 17, 1),
(4, 23, 1),
(5, 8, 1),
(5, 18, 1),
(6, 3, 1),
(7, 24, 1);
GO

-- ================================================
-- Завершення додавання даних
-- Усі тестові дані успішно додані до БД
-- ================================================

GO
