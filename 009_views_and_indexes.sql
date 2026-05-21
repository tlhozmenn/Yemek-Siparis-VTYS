-- =============================================
-- MIGRATION 009: View'lar ve Index'ler
-- 2 adet view ve 3 adet performans index'i
-- =============================================

USE YemekSiparisDB;
GO

-- -----------------------------------------------
-- VIEW 1: vw_AktifRestoranMenuleri
-- Aktif restoranların aktif urunlerini gosterir
-- IsActive = 0 olanlari otomatik filtreler
-- Kullanim: SELECT * FROM vw_AktifRestoranMenuleri
-- -----------------------------------------------
CREATE VIEW vw_AktifRestoranMenuleri AS
SELECT
    r.RestoranID,
    r.Ad    AS RestoranAdi,
    r.Puan,
    u.UrunID,
    u.Ad    AS UrunAdi,
    u.Fiyat,
    u.Aciklama
FROM Restoran r
INNER JOIN Urun u ON r.RestoranID = u.RestoranID
WHERE r.IsActive = 1
  AND u.IsActive = 1;

GO

-- -----------------------------------------------
-- VIEW 2: vw_AskidaHavuzDurumu
-- Havuzun anlik bakiyesini ve istatistiklerini gosterir
-- Kullanim: SELECT * FROM vw_AskidaHavuzDurumu
-- -----------------------------------------------
CREATE VIEW vw_AskidaHavuzDurumu AS
SELECT
    h.ToplamBakiye                     AS MevcutBakiye,
    (SELECT SUM(Tutar)
     FROM AskidaBagis)                 AS ToplamBagislanan,
    (SELECT SUM(KullanilanTutar)
     FROM AskidaKullanim)              AS ToplamKullanilan,
    (SELECT COUNT(*)
     FROM AskidaBagis)                 AS ToplamBagisSayisi,
    (SELECT COUNT(*)
     FROM AskidaKullanim)              AS ToplamKullanimSayisi,
    h.GuncellenmeTarihi
FROM AskidaHavuz h;

GO

-- -----------------------------------------------
-- INDEX 1: Musteri bazli siparis sorgulari
-- "Bu musterinin tum siparisleri" sorgularini hizlandirir
-- -----------------------------------------------
CREATE INDEX idx_Siparis_MusteriID
ON Siparis (MusteriID);

-- -----------------------------------------------
-- INDEX 2: Restoran bazli urun sorgulari
-- "Bu restoranin tum urunleri" sorgularini hizlandirir
-- -----------------------------------------------
CREATE INDEX idx_Urun_RestoranID
ON Urun (RestoranID);

-- -----------------------------------------------
-- INDEX 3: Tarih bazli bagis sorgulari
-- "Son 1 aydaki bagislar" gibi sorgulari hizlandirir
-- -----------------------------------------------
CREATE INDEX idx_AskidaBagis_Tarih
ON AskidaBagis (BagisTarihi);
