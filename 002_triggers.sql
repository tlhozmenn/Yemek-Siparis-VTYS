-- =============================================
-- MIGRATION 002: Trigger'lar (Tetikleyiciler)
-- Trigger'lar INSERT'lerden ONCE kurulmali!
-- Cunku bagis INSERT'i trg_HavuzBakiyeEkle'yi,
-- siparis INSERT'i trg_AskidaKontrol'u tetikler
-- =============================================

USE YemekSiparisDB;
GO

-- -----------------------------------------------
-- TRIGGER 1: trg_CiroGuncelle
-- Siparis "Teslim Edildi" durumuna geçince
-- o restoranin ToplamCiro'sunu otomatik arttirir
-- Sadece normal siparisler (AskidaMi = 0) ciroy etkiler
-- Askida siparislerden restorana para gitmez
-- -----------------------------------------------
CREATE TRIGGER trg_CiroGuncelle
ON Siparis
AFTER UPDATE
AS
BEGIN
    UPDATE r
    SET ToplamCiro = r.ToplamCiro + x.Toplam
    FROM Restoran r
    JOIN (
        SELECT i.RestoranID, SUM(i.ToplamTutar) AS Toplam
        FROM inserted i
        JOIN deleted d ON i.SiparisID = d.SiparisID
        WHERE i.Durum  = 'Teslim Edildi'
          AND d.Durum <> 'Teslim Edildi'
          AND i.AskidaMi = 0
        GROUP BY i.RestoranID
    ) x ON r.RestoranID = x.RestoranID;
END;

GO

-- -----------------------------------------------
-- TRIGGER 2: trg_AskidaHavuzDus
-- Askida siparis "Teslim Edildi" olunca
-- AskidaHavuz bakiyesinden o tutari dusuyor
-- ISNULL kullanimi: askida siparis yoksa 0 dusuyor
-- -----------------------------------------------
CREATE TRIGGER trg_AskidaHavuzDus
ON Siparis
AFTER UPDATE
AS
BEGIN
    UPDATE AskidaHavuz
    SET ToplamBakiye = ToplamBakiye - ISNULL(x.Toplam, 0),
        GuncellenmeTarihi = GETDATE()
    FROM (
        SELECT SUM(i.ToplamTutar) AS Toplam
        FROM inserted i
        JOIN deleted d ON i.SiparisID = d.SiparisID
        WHERE i.Durum  = 'Teslim Edildi'
          AND d.Durum <> 'Teslim Edildi'
          AND i.AskidaMi = 1
    ) x;
END;

GO

-- -----------------------------------------------
-- TRIGGER 3: trg_HavuzBakiyeEkle
-- AskidaBagis tablosuna yeni bagis eklenince
-- AskidaHavuz bakiyesini otomatik arttirir
-- -----------------------------------------------
CREATE TRIGGER trg_HavuzBakiyeEkle
ON AskidaBagis
AFTER INSERT
AS
BEGIN
    UPDATE AskidaHavuz
    SET ToplamBakiye = ToplamBakiye + (SELECT SUM(Tutar) FROM inserted),
        GuncellenmeTarihi = GETDATE();
END;

GO

-- -----------------------------------------------
-- TRIGGER 4: trg_AskidaKontrol
-- Askida siparis verilmek istenince
-- havuzda yeterli bakiye var mi kontrol eder
-- Yoksa hata firlatir ve siparis yazilmaz
-- Varsa siparisi normal sekilde tabloya yazar
-- -----------------------------------------------
CREATE TRIGGER trg_AskidaKontrol
ON Siparis
INSTEAD OF INSERT
AS
BEGIN
    -- Sadece askida siparis varsa bakiye kontrolu yap
    IF EXISTS (SELECT 1 FROM inserted WHERE AskidaMi = 1)
    BEGIN
        DECLARE @Toplam DECIMAL(10,2);

        SELECT @Toplam = SUM(ToplamTutar)
        FROM inserted
        WHERE AskidaMi = 1;

        IF (SELECT ToplamBakiye FROM AskidaHavuz) < @Toplam
        BEGIN
            RAISERROR('Havuzda yeterli bakiye yok!', 16, 1);
            RETURN;
        END
    END

    -- Bakiye yeterliyse veya normal siparisse tabloya yaz
    INSERT INTO Siparis (
        MusteriID, RestoranID, KuryeID,
        Durum, ToplamTutar, AskidaMi,
        SiparisTarihi, IsActive, TeslimatAdresID
    )
    SELECT
        MusteriID, RestoranID, KuryeID,
        Durum, ToplamTutar, AskidaMi,
        SiparisTarihi, IsActive, TeslimatAdresID
    FROM inserted;
END;
