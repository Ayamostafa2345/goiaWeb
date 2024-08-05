-- إنشاء قاعدة البيانات إذا لم تكن موجودة
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'ArchaeologyDB')
BEGIN
    CREATE DATABASE ArchaeologyDB;
END
GO

USE ArchaeologyDB;

-- إنشاء جدول الفترات
IF OBJECT_ID('Periods', 'U') IS NULL
BEGIN
    CREATE TABLE Periods (
        PeriodID INT PRIMARY KEY IDENTITY,
        Name VARCHAR(255) NOT NULL,
        StartDate DATE,
        EndDate DATE
    );
END
GO

-- إنشاء جدول المواقع
IF OBJECT_ID('Sites', 'U') IS NULL
BEGIN
    CREATE TABLE Sites (
        SiteID INT PRIMARY KEY IDENTITY,
        Name VARCHAR(255) NOT NULL,
        Location VARCHAR(255)
    );
END
GO

-- إنشاء جدول المعلومات التاريخية
IF OBJECT_ID('HistoricalInfo', 'U') IS NULL
BEGIN
    CREATE TABLE HistoricalInfo (
        HistoricalInfoID INT PRIMARY KEY IDENTITY,
        Information TEXT
    );
END
GO

-- إنشاء جدول اختصارات الأنواع
IF OBJECT_ID('TypeAbbreviations', 'U') IS NULL
BEGIN
    CREATE TABLE TypeAbbreviations (
        TypeID INT PRIMARY KEY IDENTITY,
        TypeName VARCHAR(255) NOT NULL,
        TypeAbbr VARCHAR(2) NOT NULL
    );
END
GO

-- إدخال بيانات أساسية في جدول اختصارات الأنواع
IF NOT EXISTS (SELECT * FROM TypeAbbreviations)
BEGIN
    INSERT INTO TypeAbbreviations (TypeName, TypeAbbr) VALUES
    ('Statues and Sculptures', 'SS'),
    ('Coffins', 'CF'),
    ('Mummies', 'MM'),
    ('Writings, Inscriptions, Papyri, and Scrolls', 'WP'),
    ('Masks', 'MS'),
    ('Stone Engravings', 'SE'),
    ('Jewelry', 'JW'),
    ('Textiles', 'TX'),
    ('Weapons', 'WN'),
    ('Tools and Implements', 'TI'),
    ('Medical Tools', 'MT'),
    ('Ceramics and Pottery', 'CP'),
    ('Coins', 'CN'),
    ('Paintings', 'PT'),
    ('Architectural Fragments', 'AF');
END
GO

-- إنشاء جدول اختصارات العصور
IF OBJECT_ID('EraAbbreviations', 'U') IS NULL
BEGIN
    CREATE TABLE EraAbbreviations (
        EraID INT PRIMARY KEY IDENTITY,
        EraName VARCHAR(255) NOT NULL,
        EraAbbr VARCHAR(2) NOT NULL
    );
END
GO

-- إدخال بيانات أساسية في جدول اختصارات العصور
IF NOT EXISTS (SELECT * FROM EraAbbreviations)
BEGIN
    INSERT INTO EraAbbreviations (EraName, EraAbbr) VALUES
    ('Old Kingdom', 'OK'),
    ('Middle Kingdom', 'MK'),
    ('New Kingdom', 'NK'),
    ('Late Period', 'LP'),
    ('Ptolemaic Period', 'PP'),
    ('Roman Period', 'RP'),
    ('Islamic Period to Ottoman Rule', 'IO'),
    ('Modern Egypt', 'ME');
END
GO

-- إنشاء جدول القطع الأثرية
IF OBJECT_ID('Artifacts', 'U') IS NULL
BEGIN
    CREATE TABLE Artifacts (
        ArtifactID INT PRIMARY KEY IDENTITY,
        UniqueID VARCHAR(255) UNIQUE NOT NULL,
        Name VARCHAR(255) NOT NULL,
        Description TEXT,
        PeriodID INT,
        SiteID INT,
        HistoricalInfoID INT,
        ImagePath VARCHAR(255),
        type_abbr VARCHAR(2),
        era_abbr VARCHAR(2),
        item_number INT,
        FOREIGN KEY (PeriodID) REFERENCES Periods(PeriodID),
        FOREIGN KEY (SiteID) REFERENCES Sites(SiteID),
        FOREIGN KEY (HistoricalInfoID) REFERENCES HistoricalInfo(HistoricalInfoID)
    );
END
GO

-- تعديل جدول القطع الأثرية لإضافة الأعمدة الجديدة إذا لم تكن موجودة
IF COL_LENGTH('Artifacts', 'type_abbr') IS NULL
BEGIN
    ALTER TABLE Artifacts ADD type_abbr VARCHAR(2);
END;
GO

IF COL_LENGTH('Artifacts', 'era_abbr') IS NULL
BEGIN
    ALTER TABLE Artifacts ADD era_abbr VARCHAR(2);
END;
GO

IF COL_LENGTH('Artifacts', 'item_number') IS NULL
BEGIN
    ALTER TABLE Artifacts ADD item_number INT;
END;
GO

-- بيعمل list لكل قطعة بناءا علي لعصر و النوع
WITH ItemNumbers AS (
    SELECT 
        ArtifactID,
        type_abbr,
        era_abbr,
        ROW_NUMBER() OVER (PARTITION BY type_abbr, era_abbr ORDER BY ArtifactID) AS item_number
    FROM Artifacts
)
MERGE INTO Artifacts AS target
USING ItemNumbers AS source
ON target.ArtifactID = source.ArtifactID
WHEN MATCHED THEN 
    UPDATE SET target.item_number = source.item_number;
GO

-- بيعمل update لل unique id
UPDATE Artifacts
SET UniqueID = CONCAT(type_abbr, '-', era_abbr, '-', RIGHT('000000' + CAST(item_number AS VARCHAR(6)), 6));
GO

-- بيرجع البيانات مع الاسماء بالكامل
SELECT 
    a.ArtifactID,
    a.UniqueID,
    a.Name,
    a.Description,
    a.PeriodID,
    a.SiteID,
    a.HistoricalInfoID,
    a.ImagePath,
    ta.TypeName AS FullTypeName,
    ea.EraName AS FullEraName,
    a.item_number
FROM Artifacts a
JOIN TypeAbbreviations ta ON a.type_abbr = ta.TypeAbbr
JOIN EraAbbreviations ea ON a.era_abbr = ea.EraAbbr;
