-- =============================================
-- MIGRATION 004: Restoran, Kurye ve AskidaHavuz
-- 5 restoran, 5 kurye eklenir
-- AskidaHavuz 0 bakiyeyle baslatilir
-- =============================================

USE YemekSiparisDB;
GO

INSERT INTO Restoran (Ad, Email, Telefon, Adres, Puan)
VALUES
('Aspava',            'info@aspava.com',         '02621111111', 'Kızılay, Ankara',   4.5),
('Yıldız Restourant', 'info@yildizrestoran.com', '02622222222', 'Serdivan, Sakarya', 4.4),
('MiniKöşk',          'info@minikosk.com',        '02623333333', 'İzmit, Kocaeli',    5.0),
('Tuzla Balıkçısı',   'info@tuzlabalik.com',      '02624444444', 'Karaköy, İstanbul', 4.8),
('Eniştenin Yeri',    'info@adayemek.com',        '02625555555', 'Bursa, Osmangazi',  4.3);

INSERT INTO Kurye (Ad, Soyad, Telefon)
VALUES
('Devran',   'Ersoy',    '05311111111'),
('Muhammet', 'Şendül',   '05312222222'),
('Eren',     'Taşgin',   '05313333333'),
('Ayberk',   'Satılmış', '05314444444'),
('Simge',    'Baz',      '05315555555');

-- Havuz 0 bakiyeyle baslatilir
-- Bagislar eklenince trg_HavuzBakiyeEkle otomatik arttiracak
INSERT INTO AskidaHavuz (ToplamBakiye)
VALUES (0);
