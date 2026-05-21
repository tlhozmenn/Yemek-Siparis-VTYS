-- =============================================
-- MIGRATION 010: Analitik Sorgular
-- Sistemin calistigini gosteren ornek sorgular
-- JOIN, GROUP BY + HAVING ve Subquery icermektedir
-- =============================================

USE YemekSiparisDB;
GO

-- -----------------------------------------------
-- SORGU 1: Detayli Siparis Fisi (JOIN)
-- 6 tabloyu birden birbirine baglayan sorgu:
-- Musteri, Adres, Siparis, SiparisDetay, Urun,
-- Restoran, Kurye
-- LEFT JOIN kullanimi: adresi veya kuryesi
-- henuz atanmamis siparisler de gozukur
-- -----------------------------------------------
SELECT
    s.SiparisID,
    s.SiparisTarihi,
    m.Ad + ' ' + m.Soyad    AS MusteriAdi,
    a.AdresBilgisi           AS TeslimatAdresi,
    r.Ad                     AS RestoranAdi,
    k.Ad + ' ' + k.Soyad    AS KuryeAdi,
    u.Ad                     AS UrunAdi,
    sd.Adet,
    sd.BirimFiyat,
    sd.Adet * sd.BirimFiyat  AS KalemToplam,
    s.ToplamTutar,
    s.Durum,
    CASE WHEN s.AskidaMi = 1
         THEN 'Askida Yemek'
         ELSE 'Normal'
    END                      AS OdemeTipi
FROM Siparis s
INNER JOIN Musteri      m  ON s.MusteriID       = m.MusteriID
LEFT  JOIN Adres        a  ON s.TeslimatAdresID = a.AdresID
INNER JOIN Restoran     r  ON s.RestoranID      = r.RestoranID
LEFT  JOIN Kurye        k  ON s.KuryeID         = k.KuryeID
INNER JOIN SiparisDetay sd ON s.SiparisID       = sd.SiparisID
INNER JOIN Urun         u  ON sd.UrunID         = u.UrunID
WHERE s.IsActive = 1
ORDER BY s.SiparisTarihi DESC;

-- -----------------------------------------------
-- SORGU 2: Agregasyon ve Gruplama (GROUP BY + HAVING)
-- Son 1 ayda 5'ten fazla siparis alan
-- restoranlarin istatistiklerini listeler
-- SUM, COUNT, AVG, MAX, MIN kullanilmistir
-- -----------------------------------------------
SELECT
    r.Ad                   AS RestoranAdi,
    COUNT(s.SiparisID)     AS ToplamSiparis,
    SUM(s.ToplamTutar)     AS ToplamCiro,
    AVG(s.ToplamTutar)     AS OrtalamaSepet,
    MAX(s.ToplamTutar)     AS EnBuyukSiparis,
    MIN(s.ToplamTutar)     AS EnKucukSiparis
FROM Siparis s
INNER JOIN Restoran r ON s.RestoranID = r.RestoranID
WHERE s.SiparisTarihi >= DATEADD(MONTH, -1, GETDATE())
  AND s.Durum    = 'Teslim Edildi'
  AND s.IsActive = 1
GROUP BY r.RestoranID, r.Ad
HAVING COUNT(s.SiparisID) > 5
ORDER BY ToplamSiparis DESC;

-- -----------------------------------------------
-- SORGU 3: Alt Sorgu (Subquery - NOT IN)
-- Hic "Askida Yemek" bagisi yapmamis
-- ama platformu aktif kullanan musterileri listeler
-- NOT IN icinde subquery kullanimi ornegi
-- -----------------------------------------------
SELECT
    m.MusteriID,
    m.Ad + ' ' + m.Soyad AS MusteriAdi,
    m.Email,
    COUNT(s.SiparisID)   AS ToplamSiparis
FROM Musteri m
INNER JOIN Siparis s ON m.MusteriID = s.MusteriID
WHERE m.IsActive = 1
  AND m.MusteriID NOT IN (
        SELECT DISTINCT MusteriID
        FROM AskidaBagis
        WHERE MusteriID IS NOT NULL
  )
GROUP BY m.MusteriID, m.Ad, m.Soyad, m.Email
ORDER BY ToplamSiparis DESC;
