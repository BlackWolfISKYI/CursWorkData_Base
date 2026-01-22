-- Update product images from uploads folder
-- All images are in: web_app/static/images/uploads/

SET NOCOUNT ON;

-- Автомати (Rifles)
UPDATE Products SET ImageURL = '/static/images/uploads/Cyma CM.028 AK47.jpg' WHERE ProductID = 1;
UPDATE Products SET ImageURL = '/static/images/uploads/G&G CM16 Raider.jpg' WHERE ProductID = 2;
UPDATE Products SET ImageURL = '/static/images/uploads/Tokyo Marui AK47 HC.jpg' WHERE ProductID = 3;
UPDATE Products SET ImageURL = '/static/images/uploads/Specna Arms SA-C01 CORE.jpg' WHERE ProductID = 4;
UPDATE Products SET ImageURL = '/static/images/uploads/Cybergun FAMAS F1 EVO.jpg' WHERE ProductID = 5;

-- Пістолети (Pistols)
UPDATE Products SET ImageURL = '/static/images/uploads/Tokyo Marui Glock 17.jpg' WHERE ProductID = 6;
UPDATE Products SET ImageURL = '/static/images/uploads/Cybergun Colt 1911.jpg' WHERE ProductID = 7;
UPDATE Products SET ImageURL = '/static/images/uploads/ASG CZ P-09.jpg' WHERE ProductID = 8;
UPDATE Products SET ImageURL = '/static/images/uploads/WE Beretta M9.jpg' WHERE ProductID = 9;

-- Снайперки (Sniper Rifles)
UPDATE Products SET ImageURL = '/static/images/uploads/WELL MB4403D.jpg' WHERE ProductID = 10;
UPDATE Products SET ImageURL = '/static/images/uploads/Tokyo Marui VSR-10 G-Spec.jpg' WHERE ProductID = 11;
UPDATE Products SET ImageURL = '/static/images/uploads/Cybergun FN SPR A5M.jpg' WHERE ProductID = 12;

-- Кулемети (Machineguns)
-- ProductID = 13: A&K PKM (не найдено в папці)
UPDATE Products SET ImageURL = '/static/images/uploads/G&P M249 SAW.jpg' WHERE ProductID = 14;

-- Екіпірування (Equipment)
UPDATE Products SET ImageURL = '/static/images/uploads/Viper Tactical VX Buckle Up Carrier.jpg' WHERE ProductID = 15;
UPDATE Products SET ImageURL = '/static/images/uploads/8Fields Chest Rig.jpeg' WHERE ProductID = 16;
UPDATE Products SET ImageURL = '/static/images/uploads/Pantac Mini MAP.jpg' WHERE ProductID = 17;
UPDATE Products SET ImageURL = '/static/images/uploads/Mil-Tec Assault Pack 36L.jpg' WHERE ProductID = 18;
UPDATE Products SET ImageURL = '/static/images/uploads/Condor 3-Day Assault Pack.jpg' WHERE ProductID = 19;
UPDATE Products SET ImageURL = '/static/images/uploads/Cytac CY-G17 Fast Draw.jpg' WHERE ProductID = 20;
UPDATE Products SET ImageURL = '/static/images/uploads/Uncle Mike''s Hip Holster.jpg' WHERE ProductID = 21;

-- Захист (Protection)
UPDATE Products SET ImageURL = '/static/images/uploads/Pyramex I-Force.jpg' WHERE ProductID = 22;
UPDATE Products SET ImageURL = '/static/images/uploads/Emerson Steel Mesh Mask.jpg' WHERE ProductID = 23;
UPDATE Products SET ImageURL = '/static/images/uploads/OneTigris Foldable Mesh Mask.jpg' WHERE ProductID = 24;
UPDATE Products SET ImageURL = '/static/images/uploads/Valken Tango Thermal Goggles.jpg' WHERE ProductID = 25;
UPDATE Products SET ImageURL = '/static/images/uploads/Emerson FAST Helmet.jpg' WHERE ProductID = 26;
UPDATE Products SET ImageURL = '/static/images/uploads/FMA Maritime Helmet.jpg' WHERE ProductID = 27;

-- Боєприпаси (Ammunition)
UPDATE Products SET ImageURL = '/static/images/uploads/G&G Bio BB 0.25g 4000 pcs.jpg' WHERE ProductID = 28;
UPDATE Products SET ImageURL = '/static/images/uploads/BLS Precision BB 0.20g 5000 pcs.jpg' WHERE ProductID = 29;
UPDATE Products SET ImageURL = '/static/images/uploads/Nuprol RZR BB 0.28g 3300 pcs.jpg' WHERE ProductID = 30;
UPDATE Products SET ImageURL = '/static/images/uploads/ASG Blaster BB 0.12g 2000 pcs.jpg' WHERE ProductID = 31;

-- Аксесуари (Accessories)
UPDATE Products SET ImageURL = '/static/images/uploads/Element M300 Tactical Flashlight.jpg' WHERE ProductID = 32;
UPDATE Products SET ImageURL = '/static/images/uploads/Holosun HS403B Red Dot Sight.jpg' WHERE ProductID = 33;
UPDATE Products SET ImageURL = '/static/images/uploads/Element LA-5 PEQ-15 (dummy).jpg' WHERE ProductID = 34;
UPDATE Products SET ImageURL = '/static/images/uploads/Magpul RVG Vertical Grip.jpg' WHERE ProductID = 35;
UPDATE Products SET ImageURL = '/static/images/uploads/UTG 4x32 Compact Scope.jpg' WHERE ProductID = 36;

PRINT N'✅ 35 из 36 товаров обновлено (A&K PKM отсутствует в папке)';
