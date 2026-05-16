-- =============================================
-- MIGRATION 006: AskidaBagis Verileri
-- Bagislar eklenir
-- Her INSERT → trg_HavuzBakiyeEkle tetiklenir
-- → AskidaHavuz.ToplamBakiye otomatik artar
-- Toplam bagis: 1350 TL
-- =============================================

USE YemekSiparisDB;
GO

-- Anonim = 0 → kim yaptigini herkes gorebilir
-- Anonim = 1 → kimlik gizli
INSERT INTO AskidaBagis (MusteriID, Tutar, Anonim)
VALUES
(1,  150.00, 0),   -- Talha acikca bagis yapti
(2,  200.00, 1),   -- Ayse anonim bagis yapti
(3,  100.00, 0),
(4,  250.00, 1),
(5,  175.00, 0),
(6,  300.00, 1),
(7,   50.00, 0),
(8,  125.00, 1);
-- Toplam: 1350 TL → havuz otomatik guncellendi

-- Havuzu elle de guncelleyebiliriz (trigger olmasa diye yedek)
UPDATE AskidaHavuz
SET ToplamBakiye = (SELECT SUM(Tutar) FROM AskidaBagis),
    GuncellenmeTarihi = GETDATE();
