-- =============================================
-- MIGRATION 008: AskidaKullanim Verileri
-- Havuzdan yararlanma kayitlari eklenir
-- SiparisID 81-90 → Migration 007'deki askida siparisler
-- MusteriID 11-15 → AskidaOnay = 1 olan ihtiyac sahipleri
-- Toplam kullanim: 915 TL
-- =============================================

USE YemekSiparisDB;
GO

INSERT INTO AskidaKullanim (MusteriID, SiparisID, KullanilanTutar, KullanimTarihi)
SELECT 
    s.MusteriID,
    s.SiparisID,
    s.ToplamTutar,
    s.SiparisTarihi
FROM Siparis s
WHERE s.AskidaMi = 1
  AND s.Durum = 'Teslim Edildi';
