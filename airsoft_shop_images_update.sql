-- ================================================
-- Оновлення URL зображень товарів
-- Додавання реальних фотографій страйкбольної зброї
-- ================================================

USE airsoft_shop;
GO

-- Оновлення ImageURL для всіх товарів
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 1;  -- AK47
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 2;  -- M4 Raider
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 3;  -- Tokyo Marui AK47
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 4;  -- Specna Arms M4
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 5;  -- FAMAS
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 6;  -- Glock 17
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 7;  -- Colt 1911
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 8;  -- CZ P-09
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1595590424283-b8f17842773f?w=800' WHERE ProductID = 9;  -- Beretta M9
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 10; -- Снайперка WELL
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 11; -- VSR-10
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 12; -- FN SPR
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 13; -- PKM
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1616628188859-7a11abb6fcc9?w=800' WHERE ProductID = 14; -- M249 SAW
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1551854838-d3281827ad59?w=800' WHERE ProductID = 15; -- Жилет Viper
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1551854838-d3281827ad59?w=800' WHERE ProductID = 16; -- Chest Rig
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1551854838-d3281827ad59?w=800' WHERE ProductID = 17; -- Pantac MAP
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800' WHERE ProductID = 18; -- Рюкзак Mil-Tec
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800' WHERE ProductID = 19; -- Condor рюкзак
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=800' WHERE ProductID = 20; -- Кобура Cytac
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=800' WHERE ProductID = 21; -- Uncle Mike кобура
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800' WHERE ProductID = 22; -- Окуляри Pyramex
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800' WHERE ProductID = 23; -- Маска Emerson
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800' WHERE ProductID = 24; -- OneTigris маска
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800' WHERE ProductID = 25; -- Окуляри Valken
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1557862921-37829c790f19?w=800' WHERE ProductID = 26; -- Шолом FAST
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1557862921-37829c790f19?w=800' WHERE ProductID = 27; -- Maritime шолом
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800' WHERE ProductID = 28; -- BB 0.25g
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800' WHERE ProductID = 29; -- BB 0.20g
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800' WHERE ProductID = 30; -- BB 0.28g
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800' WHERE ProductID = 31; -- BB 0.12g
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800' WHERE ProductID = 32; -- Ліхтар M300
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800' WHERE ProductID = 33; -- Red Dot Holosun
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800' WHERE ProductID = 34; -- PEQ-15
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800' WHERE ProductID = 35; -- Vertical Grip
UPDATE Products SET ImageURL = 'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800' WHERE ProductID = 36; -- UTG Scope

GO

PRINT 'Зображення успішно оновлені для всіх товарів!';
GO
