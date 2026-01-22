-- ================================================
-- Оновлення URL зображень товарів
-- Використання локальних шляхів та CDN
-- ================================================

USE airsoft_shop;
GO

-- Автомати
UPDATE Products SET ImageURL = '/static/images/products/cyma-cm028-ak47.jpg' WHERE ProductID = 1;
UPDATE Products SET ImageURL = '/static/images/products/gg-cm16-raider.jpg' WHERE ProductID = 2;
UPDATE Products SET ImageURL = '/static/images/products/tokyo-marui-ak47.jpg' WHERE ProductID = 3;
UPDATE Products SET ImageURL = '/static/images/products/specna-arms-c01.jpg' WHERE ProductID = 4;
UPDATE Products SET ImageURL = '/static/images/products/cybergun-famas.jpg' WHERE ProductID = 5;

-- Пістолети
UPDATE Products SET ImageURL = '/static/images/products/tokyo-marui-glock17.jpg' WHERE ProductID = 6;
UPDATE Products SET ImageURL = '/static/images/products/cybergun-1911.jpg' WHERE ProductID = 7;
UPDATE Products SET ImageURL = '/static/images/products/asg-cz-p09.jpg' WHERE ProductID = 8;
UPDATE Products SET ImageURL = '/static/images/products/we-beretta-m9.jpg' WHERE ProductID = 9;

-- Снайперські гвинтівки
UPDATE Products SET ImageURL = '/static/images/products/well-mb4403d.jpg' WHERE ProductID = 10;
UPDATE Products SET ImageURL = '/static/images/products/tokyo-marui-vsr10.jpg' WHERE ProductID = 11;
UPDATE Products SET ImageURL = '/static/images/products/cybergun-fn-spr.jpg' WHERE ProductID = 12;

-- Кулемети
UPDATE Products SET ImageURL = '/static/images/products/aak-pkm.jpg' WHERE ProductID = 13;
UPDATE Products SET ImageURL = '/static/images/products/gp-m249.jpg' WHERE ProductID = 14;

-- Екіпірування - Жилети
UPDATE Products SET ImageURL = '/static/images/products/viper-vx-buckle.jpg' WHERE ProductID = 15;
UPDATE Products SET ImageURL = '/static/images/products/8fields-chest-rig.jpg' WHERE ProductID = 16;
UPDATE Products SET ImageURL = '/static/images/products/pantac-mini-map.jpg' WHERE ProductID = 17;

-- Рюкзаки
UPDATE Products SET ImageURL = '/static/images/products/miltec-assault-36l.jpg' WHERE ProductID = 18;
UPDATE Products SET ImageURL = '/static/images/products/condor-3day.jpg' WHERE ProductID = 19;

-- Кобури
UPDATE Products SET ImageURL = '/static/images/products/cytac-g17.jpg' WHERE ProductID = 20;
UPDATE Products SET ImageURL = '/static/images/products/uncle-mike-holster.jpg' WHERE ProductID = 21;

-- Захист - Окуляри та маски
UPDATE Products SET ImageURL = '/static/images/products/pyramex-i-force.jpg' WHERE ProductID = 22;
UPDATE Products SET ImageURL = '/static/images/products/emerson-steel-mesh.jpg' WHERE ProductID = 23;
UPDATE Products SET ImageURL = '/static/images/products/onetigris-foldable.jpg' WHERE ProductID = 24;
UPDATE Products SET ImageURL = '/static/images/products/valken-tango.jpg' WHERE ProductID = 25;

-- Шоломи
UPDATE Products SET ImageURL = '/static/images/products/emerson-fast.jpg' WHERE ProductID = 26;
UPDATE Products SET ImageURL = '/static/images/products/fma-maritime.jpg' WHERE ProductID = 27;

-- Боєприпаси
UPDATE Products SET ImageURL = '/static/images/products/gg-bio-bb-025.jpg' WHERE ProductID = 28;
UPDATE Products SET ImageURL = '/static/images/products/bls-precision-020.jpg' WHERE ProductID = 29;
UPDATE Products SET ImageURL = '/static/images/products/nuprol-rzr-028.jpg' WHERE ProductID = 30;
UPDATE Products SET ImageURL = '/static/images/products/asg-blaster-012.jpg' WHERE ProductID = 31;

-- Аксесуари
UPDATE Products SET ImageURL = '/static/images/products/element-m300.jpg' WHERE ProductID = 32;
UPDATE Products SET ImageURL = '/static/images/products/holosun-hs403b.jpg' WHERE ProductID = 33;
UPDATE Products SET ImageURL = '/static/images/products/element-peq15.jpg' WHERE ProductID = 34;
UPDATE Products SET ImageURL = '/static/images/products/magpul-rvg.jpg' WHERE ProductID = 35;
UPDATE Products SET ImageURL = '/static/images/products/utg-4x32.jpg' WHERE ProductID = 36;

GO

PRINT 'Шляхи до зображень оновлені на локальні!';
GO
