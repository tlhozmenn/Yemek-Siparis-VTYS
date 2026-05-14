-- =============================================
-- MIGRATION 003: Musteri ve Adres Verileri
-- 20 musteri eklenir (10 normal, 5 ihtiyac sahibi, 5 normal)
-- Her musteriye ev adresi, bazilarina is adresi eklenir
-- =============================================

USE YemekSiparisDB;
GO

-- AskidaOnay = 0 → normal musteri
-- AskidaOnay = 1 → ihtiyac sahibi, havuzdan ucretsiz siparis verebilir
INSERT INTO Musteri (Ad, Soyad, Email, Telefon, Sifre, AskidaOnay)
VALUES
('Talha',   'Özmen',   'talhaozmen41@gmail.com', '05541111111', '0001', 0),
('Ayşe',    'Çağlan',  'ayse@gmail.com',          '05542222222', '0002', 0),
('Ali',     'Buran',   'ali@gmail.com',            '05543333333', '0005', 0),
('Alperen', 'Özmen',   'alperen@gmail.com',        '05544444444', '0003', 0),
('Fatma',   'Çelik',   'fatma@gmail.com',          '05545555555', '0004', 0),
('Zeynep',  'Çağlan',  'zeynep@gmail.com',         '05546666666', '0006', 0),
('Nil',     'Almira',  'nil@gmail.com',             '05547777777', '0007', 0),
('M. Kemal','Atatürk', 'kemal@gmail.com',           '05548888888', '0008', 0),
('Hasan',   'Özkan',   'hasan@gmail.com',           '05549999999', '0009', 0),
('Merve',   'Aydın',   'merve@gmail.com',           '05540000000', '0010', 0),
-- Ihtiyac sahibi musteriler (AskidaOnay = 1)
('Yağmur',  'Macit',   'yagmur@gmail.com',          '05451111111', '0011', 1),
('Gülnur',  'Güneş',   'gulnur@gmail.com',          '05452222222', '0012', 1),
('İrem',    'Taş',     'irem@gmail.com',             '05453333333', '0013', 1),
('Büşra',   'Yıldız',  'busra@gmail.com',            '05454444444', '0014', 1),
('Umay',    'Özmen',   'umay@gmail.com',             '05455555555', '0015', 1),
('Nalan',   'Bulut',   'nalan@gmail.com',            '05456666666', '0016', 0),
('Burak',   'Erdoğan', 'burak@gmail.com',            '05457777777', '0017', 0),
('Seda',    'Güler',   'seda@gmail.com',             '05458888888', '0018', 0),
('Tolga',   'Çakır',   'tolga@gmail.com',            '05459999999', '0019', 0),
('Pınar',   'Öztürk',  'pinar@gmail.com',            '05450000000', '0020', 0);

-- Her musteriye ev adresi (AdresID 1-20)
-- Bazi musterilere is adresi de ekleniyor (AdresID 21-24)
INSERT INTO Adres (MusteriID, AdresBasligi, AdresBilgisi)
VALUES
(1,  'Ev',  'Kandıra, Kocaeli'),
(2,  'Ev',  'Merkez, Yozgat'),
(3,  'Ev',  'Serdivan, Sakarya'),
(4,  'Ev',  'Yeşilova, Kocaeli'),
(5,  'Ev',  'Ereğli, Konya'),
(6,  'Ev',  'Kızılay, Ankara'),
(7,  'Ev',  'Keçiören, Ankara'),
(8,  'Ev',  'Bornova, İzmir'),
(9,  'Ev',  'Muratpaşa, Antalya'),
(10, 'Ev',  'Üsküdar, İstanbul'),
(11, 'Ev',  'Merkez, Kayseri'),
(12, 'Ev',  'Gaziemir, İzmir'),
(13, 'Ev',  'Kocasinan, Kayseri'),
(14, 'Ev',  'Nilüfer, Bursa'),
(15, 'Ev',  'Kefken, Kocaeli'),
(16, 'Ev',  'Yenişehir, Mersin'),
(17, 'Ev',  'Maltepe, İstanbul'),
(18, 'Ev',  'Etimesgut, Ankara'),
(19, 'Ev',  'Sarıyer, İstanbul'),
(20, 'Ev',  'Karşıyaka, İzmir'),
(1,  'İş',  'İzmit, Kocaeli'),
(3,  'İş',  'Adapazarı, Sakarya'),
(8,  'İş',  'Alsancak, İzmir'),
(10, 'İş',  'Beşiktaş, İstanbul');
