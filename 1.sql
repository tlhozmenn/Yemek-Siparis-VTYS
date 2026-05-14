-- =============================================
-- MIGRATION 001: Veritabani Sifirlama ve Tablo Olusturma
-- Eski veritabani silinir, yenisi kurulur
-- Tum tablolar PK, FK, CHECK, UNIQUE, NOT NULL
-- kisitlamalariyla birlikte olusturulur
-- =============================================

USE master;
GO

-- Eski veritabanini acik baglantilari kopararak zorla siler
ALTER DATABASE YemekSiparisDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS YemekSiparisDB;
GO

-- Temiz yeni veritabani olusturulur
CREATE DATABASE YemekSiparisDB;
GO

USE YemekSiparisDB;
GO

-- -----------------------------------------------
-- TABLO 1: Musteri
-- Platformdaki tum musterileri tutar
-- AskidaOnay = 1 → ihtiyac sahibi, havuzdan yararlanabilir
-- -----------------------------------------------
CREATE TABLE Musteri (
    MusteriID   INT           PRIMARY KEY IDENTITY(1,1),
    Ad          NVARCHAR(50)  NOT NULL,
    Soyad       NVARCHAR(50)  NOT NULL,
    Email       NVARCHAR(100) NOT NULL UNIQUE,
    Telefon     NVARCHAR(15)  NOT NULL UNIQUE,
    Sifre       NVARCHAR(255) NOT NULL,
    KayitTarihi DATETIME      DEFAULT GETDATE(),
    IsActive    BIT           DEFAULT 1,
    AskidaOnay  BIT           DEFAULT 0
);

-- -----------------------------------------------
-- TABLO 2: Adres
-- Bir musterinin birden fazla adresi olabilir
-- (Ev, Is vb.) - Musteri'ye tek yonlu FK
-- -----------------------------------------------
CREATE TABLE Adres (
    AdresID      INT           PRIMARY KEY IDENTITY(1,1),
    MusteriID    INT,
    AdresBasligi NVARCHAR(50),
    AdresBilgisi NVARCHAR(300),

    FOREIGN KEY (MusteriID) REFERENCES Musteri(MusteriID)
);

-- -----------------------------------------------
-- TABLO 3: Restoran
-- CHECK #1: Puan 0-5 arasinda olmak zorunda
-- CHECK #2: ToplamCiro negatif olamaz
-- ToplamCiro → trg_CiroGuncelle trigger'i ile guncellenir
-- -----------------------------------------------
CREATE TABLE Restoran (
    RestoranID  INT            PRIMARY KEY IDENTITY(1,1),
    Ad          NVARCHAR(100)  NOT NULL,
    Email       NVARCHAR(100)  NOT NULL UNIQUE,
    Telefon     NVARCHAR(15)   NOT NULL UNIQUE,
    Adres       NVARCHAR(255)  NOT NULL,
    Puan        DECIMAL(2,1)   DEFAULT 0
                    CHECK (Puan BETWEEN 0 AND 5),
    ToplamCiro  DECIMAL(10,2)  DEFAULT 0
                    CHECK (ToplamCiro >= 0),
    IsActive    BIT            DEFAULT 1
);

-- -----------------------------------------------
-- TABLO 4: Kurye
-- Musait = 1 → bosta, 0 → sipariste
-- -----------------------------------------------
CREATE TABLE Kurye (
    KuryeID  INT          PRIMARY KEY IDENTITY(1,1),
    Ad       NVARCHAR(50) NOT NULL,
    Soyad    NVARCHAR(50) NOT NULL,
    Telefon  NVARCHAR(15) NOT NULL UNIQUE,
    Musait   BIT          DEFAULT 1,
    IsActive BIT          DEFAULT 1
);

-- -----------------------------------------------
-- TABLO 5: Urun
-- Her urun bir restorana aittir (FK)
-- CHECK #3: Fiyat sifirdan buyuk olmak zorunda
-- IsActive = 0 → soft delete (urun silinmez, pasife cekilir)
-- -----------------------------------------------
CREATE TABLE Urun (
    UrunID     INT            PRIMARY KEY IDENTITY(1,1),
    RestoranID INT            NOT NULL,
    Ad         NVARCHAR(100)  NOT NULL,
    Aciklama   NVARCHAR(255),
    Fiyat      DECIMAL(8,2)   NOT NULL CHECK (Fiyat > 0),
    IsActive   BIT            DEFAULT 1,

    FOREIGN KEY (RestoranID) REFERENCES Restoran(RestoranID)
);

-- -----------------------------------------------
-- TABLO 6: Siparis
-- Musteri, Restoran, Kurye ve Adres'e bagli
-- Durum CHECK: sadece gecerli statusler girilebilir
-- AskidaMi = 1 → bu siparis havuzdan odendi
-- TeslimatAdresID → musterinin hangi adresine teslim edilecek
-- -----------------------------------------------
CREATE TABLE Siparis (
    SiparisID       INT           PRIMARY KEY IDENTITY(1,1),
    MusteriID       INT           NOT NULL,
    RestoranID      INT           NOT NULL,
    KuryeID         INT,
    TeslimatAdresID INT,
    Durum           NVARCHAR(20)  DEFAULT 'Beklemede'
                        CHECK (Durum IN (
                            'Beklemede',
                            'Hazirlaniyor',
                            'Yolda',
                            'Teslim Edildi',
                            'Iptal'
                        )),
    ToplamTutar     DECIMAL(8,2)  NOT NULL CHECK (ToplamTutar >= 0),
    AskidaMi        BIT           DEFAULT 0,
    SiparisTarihi   DATETIME      DEFAULT GETDATE(),
    IsActive        BIT           DEFAULT 1,

    FOREIGN KEY (TeslimatAdresID) REFERENCES Adres(AdresID),
    FOREIGN KEY (MusteriID)       REFERENCES Musteri(MusteriID),
    FOREIGN KEY (RestoranID)      REFERENCES Restoran(RestoranID),
    FOREIGN KEY (KuryeID)         REFERENCES Kurye(KuryeID)
);

-- -----------------------------------------------
-- TABLO 7: SiparisDetay
-- Siparis-Urun arasindaki M:N iliskiyi cozen tablo
-- BirimFiyat ayrica saklanir: urun fiyati degisse
-- eski siparisler etkilenmez
-- -----------------------------------------------
CREATE TABLE SiparisDetay (
    DetayID    INT          PRIMARY KEY IDENTITY(1,1),
    SiparisID  INT          NOT NULL,
    UrunID     INT          NOT NULL,
    Adet       INT          NOT NULL CHECK (Adet > 0),
    BirimFiyat DECIMAL(8,2) NOT NULL CHECK (BirimFiyat > 0),

    FOREIGN KEY (SiparisID) REFERENCES Siparis(SiparisID),
    FOREIGN KEY (UrunID)    REFERENCES Urun(UrunID)
);

-- -----------------------------------------------
-- TABLO 8: AskidaHavuz
-- Havuzun anlık bakiyesini tutar (tek satir)
-- Bakiye trg_HavuzBakiyeEkle ve trg_AskidaHavuzDus
-- trigger'lari ile otomatik guncellenir
-- -----------------------------------------------
CREATE TABLE AskidaHavuz (
    HavuzID           INT            PRIMARY KEY IDENTITY(1,1),
    ToplamBakiye      DECIMAL(10,2)  DEFAULT 0 CHECK (ToplamBakiye >= 0),
    GuncellenmeTarihi DATETIME       DEFAULT GETDATE()
);

-- Havuzda her zaman tek satir olmasi icin unique index
CREATE UNIQUE INDEX idx_tek_havuz
ON AskidaHavuz(HavuzID)
WHERE HavuzID = 1;

-- -----------------------------------------------
-- TABLO 9: AskidaBagis
-- Kimin ne kadar bagis yaptigini tutar
-- MusteriID NULL olabilir → anonim bagis
-- -----------------------------------------------
CREATE TABLE AskidaBagis (
    BagisID     INT           PRIMARY KEY IDENTITY(1,1),
    MusteriID   INT,
    Tutar       DECIMAL(8,2)  NOT NULL CHECK (Tutar > 0),
    Anonim      BIT           DEFAULT 0,
    BagisTarihi DATETIME      DEFAULT GETDATE(),

    FOREIGN KEY (MusteriID) REFERENCES Musteri(MusteriID)
);

-- -----------------------------------------------
-- TABLO 10: AskidaKullanim
-- Kimin havuzdan ne kadar yararlandigini tutar
-- SiparisID uzerinden hangi siparise karsilik
-- kullanildigı izlenebilir
-- -----------------------------------------------
CREATE TABLE AskidaKullanim (
    KullanimID      INT           PRIMARY KEY IDENTITY(1,1),
    MusteriID       INT           NOT NULL,
    SiparisID       INT           NOT NULL,
    KullanilanTutar DECIMAL(8,2)  NOT NULL CHECK (KullanilanTutar > 0),
    KullanimTarihi  DATETIME      DEFAULT GETDATE(),

    FOREIGN KEY (MusteriID)  REFERENCES Musteri(MusteriID),
    FOREIGN KEY (SiparisID)  REFERENCES Siparis(SiparisID)
);
