-- ================================================
-- Оновлення URL зображень товарів
-- Додавання реальних фотографій страйкбольної зброї
-- Використовуються placeholder.com зображення з назвами товарів
-- ================================================

USE airsoft_shop;
GO

-- Оновлення ImageURL для всіх товарів
-- Автомати
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2c3e50/ffffff?text=CYMA+CM.028+AK47' WHERE ProductID = 1;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/34495e/ffffff?text=G%26G+CM16+Raider+M4' WHERE ProductID = 2;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2c3e50/ffffff?text=Tokyo+Marui+AK47+HC' WHERE ProductID = 3;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/34495e/ffffff?text=Specna+Arms+SA-C01' WHERE ProductID = 4;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2c3e50/ffffff?text=Cybergun+FAMAS+F1' WHERE ProductID = 5;

-- Пістолети
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/1abc9c/ffffff?text=Tokyo+Marui+Glock+17' WHERE ProductID = 6;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/16a085/ffffff?text=Cybergun+Colt+1911' WHERE ProductID = 7;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/1abc9c/ffffff?text=ASG+CZ+P-09' WHERE ProductID = 8;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/16a085/ffffff?text=WE+Beretta+M9' WHERE ProductID = 9;

-- Снайперські гвинтівки
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/8e44ad/ffffff?text=WELL+MB4403D+L96' WHERE ProductID = 10;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/9b59b6/ffffff?text=Tokyo+Marui+VSR-10' WHERE ProductID = 11;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/8e44ad/ffffff?text=Cybergun+FN+SPR' WHERE ProductID = 12;

-- Кулемети
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/c0392b/ffffff?text=A%26K+PKM' WHERE ProductID = 13;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/e74c3c/ffffff?text=G%26P+M249+SAW' WHERE ProductID = 14;

-- Екіпірування - Жилети та розвантажки
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/27ae60/ffffff?text=Viper+VX+Buckle+Up' WHERE ProductID = 15;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2ecc71/ffffff?text=8Fields+Chest+Rig' WHERE ProductID = 16;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/27ae60/ffffff?text=Pantac+Mini+MAP' WHERE ProductID = 17;

-- Рюкзаки
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/7f8c8d/ffffff?text=Mil-Tec+Assault+36L' WHERE ProductID = 18;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/95a5a6/ffffff?text=Condor+3-Day+Pack' WHERE ProductID = 19;

-- Кобури
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/d35400/ffffff?text=Cytac+CY-G17+Holster' WHERE ProductID = 20;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/e67e22/ffffff?text=Uncle+Mike+Hip+Holster' WHERE ProductID = 21;

-- Захист - Окуляри та маски
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/3498db/ffffff?text=Pyramex+I-Force+Goggles' WHERE ProductID = 22;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2980b9/ffffff?text=Emerson+Steel+Mesh+Mask' WHERE ProductID = 23;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/3498db/ffffff?text=OneTigris+Foldable+Mask' WHERE ProductID = 24;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2980b9/ffffff?text=Valken+Tango+Goggles' WHERE ProductID = 25;

-- Шоломи
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/34495e/ffffff?text=Emerson+FAST+Helmet' WHERE ProductID = 26;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/2c3e50/ffffff?text=FMA+Maritime+Helmet' WHERE ProductID = 27;

-- Боєприпаси
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/ecf0f1/2c3e50?text=G%26G+Bio+BB+0.25g' WHERE ProductID = 28;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/ecf0f1/2c3e50?text=BLS+Precision+0.20g' WHERE ProductID = 29;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/ecf0f1/2c3e50?text=Nuprol+RZR+0.28g' WHERE ProductID = 30;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/ecf0f1/2c3e50?text=ASG+Blaster+0.12g' WHERE ProductID = 31;

-- Аксесуари
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/f39c12/ffffff?text=Element+M300+Flashlight' WHERE ProductID = 32;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/e67e22/ffffff?text=Holosun+HS403B+Red+Dot' WHERE ProductID = 33;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/f39c12/ffffff?text=Element+PEQ-15' WHERE ProductID = 34;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/e67e22/ffffff?text=Magpul+RVG+Grip' WHERE ProductID = 35;
UPDATE Products SET ImageURL = 'https://via.placeholder.com/800x600/f39c12/ffffff?text=UTG+4x32+Scope' WHERE ProductID = 36;

GO

PRINT 'Зображення успішно оновлені для всіх товарів!';
GO
