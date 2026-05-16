-- =============================================
-- MIGRATION 005: Urun Verileri
-- Her restorandan 10 urun → toplam 50 urun
-- UrunID'ler restorana gore gruplanmistir:
-- Restoran 1 (Aspava)          → UrunID  1-10
-- Restoran 2 (Yildiz)          → UrunID 11-20
-- Restoran 3 (MiniKosk)        → UrunID 21-30
-- Restoran 4 (Tuzla Balikci)   → UrunID 31-40
-- Restoran 5 (Enistenin Yeri)  → UrunID 41-50
-- =============================================

USE YemekSiparisDB;
GO

-- Restoran 1: Aspava
INSERT INTO Urun (RestoranID, Ad, Aciklama, Fiyat)
VALUES
(1, 'Adana Kebap',      'Acılı el yapımı kebap',         350.00),
(1, 'Urfa Kebap',       'Acısız el yapımı kebap',        350.00),
(1, 'Lahmacun',         'İnce hamur kıymalı',             75.00),
(1, 'Pide',             'Kaşarlı pide',                  125.00),
(1, 'Mercimek Çorbası', 'Günlük taze çorba',              30.00),
(1, 'Ayran',            '300ml soğuk ayran',              25.00),
(1, 'Baklava',          'Fıstıklı ev baklavası',          75.00),
(1, 'Künefe',           'Peynirli sıcak künefe',          60.00),
(1, 'İskender',         'Yoğurtlu döner üzeri tereyağ',  495.00),
(1, 'Çoban Salata',     'Mevsim sebzeli taze salata',     50.00);

-- Restoran 2: Yıldız Restourant
INSERT INTO Urun (RestoranID, Ad, Aciklama, Fiyat)
VALUES
(2, 'Şiş Kebap',       'Kuzu şiş ızgara',               175.00),
(2, 'Tavuk Şiş',       'Marine tavuk ızgara',            125.00),
(2, 'Döner Tabak',     'Pilav üzeri döner',              200.00),
(2, 'Kanat',           'Baharatlı tavuk kanat',          135.00),
(2, 'Ezogelin Çorba',  'Tarhınlı ezogelin',               30.00),
(2, 'Kola',            '330ml kutu',                      60.00),
(2, 'Fanta',           '330ml kutu',                      60.00),
(2, 'Sarma',           'Zeytinyağlı yaprak sarması',     100.00),
(2, 'Patlıcan Salata', 'Közlenmiş patlıcan',              50.00),
(2, 'Sütlaç',          'Fırın sütlaç',                    80.00);

-- Restoran 3: MiniKöşk
INSERT INTO Urun (RestoranID, Ad, Aciklama, Fiyat)
VALUES
(3, 'Izgara Köfte',     'Izgara ateşinde',               350.00),
(3, 'Izgara Sucuk',     'Izgara ateşinde',               350.00),
(3, 'Açık Büfe',        'Herşey sınırsız',               800.00),
(3, 'Kahvaltı',         'İstediğin kahvaltılıklar',      450.00),
(3, 'Sezar Salata',     'Krutonlu sezar sos',             70.00),
(3, 'Sarımsaklı Ekmek', 'Tereyağlı sarımsaklı',           30.00),
(3, 'Ayran',            'Buz gibi el yapımı',             50.00),
(3, 'Limonata',         'Taze sıkma limonata',            75.00),
(3, 'Acılı Ezme',       'Aşk kadar acı',                  40.00),
(3, 'Kokoreç',          'Taze bağırsaktan',              350.00);

-- Restoran 4: Tuzla Balıkçısı
INSERT INTO Urun (RestoranID, Ad, Aciklama, Fiyat)
VALUES
(4, 'Levrek Izgara',  'Taze levrek fileto',              200.00),
(4, 'Çipura Izgara',  'Taze çipura fileto',              200.00),
(4, 'Balık Dürüm',    'Izgarada balık dürüm',            250.00),
(4, 'Midye Tava',     'Çıtır midye tava',                350.00),
(4, 'Balık Çorbası',  'Günlük taze balık çorba',          50.00),
(4, 'Cacık',          'Yoğurtlu salatalık',               30.00),
(4, 'Rakı',           '35cl',                            120.00),
(4, 'Beyaz Şarap',    'Ev şarabı kadeh',                 290.00),
(4, 'Deniz Salatası', 'Ahtapot + sebze salatası',        175.00),
(4, 'Dondurma',       'Vanilyalı 2 top',                  80.00);

-- Restoran 5: Eniştenin Yeri
INSERT INTO Urun (RestoranID, Ad, Aciklama, Fiyat)
VALUES
(5, 'Kuru Fasulye', 'Pilav ile',                         125.00),
(5, 'Etli Nohut',   'Pilav ile',                         125.00),
(5, 'Türlü',        'Mevsim sebzeli türlü',               75.00),
(5, 'Dolma',        'Zeytinyağlı biber dolması',           85.00),
(5, 'Tarhana Çorba','Ev yapımı tarhana',                   30.00),
(5, 'Güllaç',       'Sütlü güllaç tatlısı',               65.00),
(5, 'Komposto',     'Mevsim meyveli komposto',             40.00),
(5, 'Ayran',        '300ml',                              30.00),
(5, 'İmam Bayıldı', 'Zeytinyağlı patlıcan',               90.00),
(5, 'Kabak Mücver', 'Yoğurtlu mücver',                    95.00);
