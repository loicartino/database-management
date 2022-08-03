--Projet GBD: Partie 2 
--Gabriella Bincoletto-Montpetit (11149602)
--Loic Artino (11244646)

-- Partie A: Créer la base de données

DROP DATABASE IF EXISTS CakeShop
CREATE DATABASE CakeShop
GO
USE CakeShop
GO

-- Partie B: Créer chaque table de la base de données

DROP TABLE IF EXISTS Province;
CREATE TABLE Province
    ( 
       ProvinceID INT NOT NULL PRIMARY KEY,
       Name NVARCHAR(20) NOT NULL
    )
DROP TABLE IF EXISTS City; 
CREATE TABLE City
    ( 
       CityID INT NOT NULL PRIMARY KEY,
       Name NVARCHAR(20) NOT NULL,
       ProvinceID INT 
    )
DROP TABLE IF EXISTS Address;
CREATE TABLE Address
    ( 
       AddressID INT NOT NULL PRIMARY KEY,
       Number INT NOT NULL,
       StreetName NVARCHAR(50) NOT NULL,
       Appartment INT NULL,
       CityID  INT NULL,
       CodePostal NCHAR(6) NOT NULL
    )
DROP TABLE IF EXISTS Clients;
CREATE TABLE Clients
    ( 
       ClientID INT NOT NULL PRIMARY KEY,
       FirstName NVARCHAR(30) NULL,
       LastName NVARCHAR(30) NULL,
       AddressID  INT NULL,
       Birthdate DATE NULL
    )
DROP TABLE IF EXISTS Invoices;
CREATE TABLE Invoices
    ( 
       InvoiceID INT NOT NULL PRIMARY KEY,
       ClientID INT NULL,
       Taxes FLOAT NULL,
       PurchaseDate DATE NOT NULL,
       SubTotal FLOAT NULL,
       Rabais FLOAT NULL,
       PaymentType CHAR(1)
    )
DROP TABLE IF EXISTS CakesCategories;
CREATE TABLE CakesCategories
   (
      CakeCategoryID INT NOT NULL PRIMARY KEY,
      CategoryName NVARCHAR(20) NOT NULL
   )
DROP TABLE IF EXISTS CakeSubCategories;
CREATE TABLE CakeSubCategories
   (
      CakeSubCategoryID INT NOT NULL PRIMARY KEY,
      SubCategoryName NVARCHAR(30) NOT NULL,
      CakeCategoryID INT NOT NULL,
      ListPrice FLOAT NOT NULL
   )
DROP TABLE IF EXISTS CakeInventory;
CREATE TABLE CakeInventory
   (
      CakeInventoryID INT NOT NULL PRIMARY KEY,
      DateFabrication DATE NOT NULL,
      CakeSubCategoryID INT NOT NULL, 
      CakeStatus CHAR(1),
      SellDisposeDate DATE NULL
   )

DROP TABLE IF EXISTS SalesDetails;
CREATE TABLE SalesDetails
   (
      SalesDetailID INT NOT NULL PRIMARY KEY,
      CakeInventoryID INT NOT NULL,
      SalesPrice FLOAT NULL,
      InvoiceID INT NULL 
   )

DROP TABLE IF EXISTS TaxRates;
CREATE TABLE TaxRates
   (
		TauxTPS  FLOAT NOT NULL,
		TauxTVQ FLOAT NOT NULL,
		StartDate DATE NULL, 
		EndDate DATE NULL,
   )

 --Partie C
 /* Sur Mac, nous n'avons pas réussi à copier-coller les données Excel vers SQL comme indiqué dans l'énoncé. Nous avons
 donc directement ajouté l'information ci-dessous */

INSERT INTO TaxRates (TauxTPS, TauxTVQ, StartDate, EndDate) VALUES
(5, 9.975, '2008-01-01',  NULL), 
(7, 9.975, '1991-01-01', NULL)

INSERT INTO Province (ProvinceID, Name) VALUES
(1, 'QC'),
(2, 'ON'),
(3, 'BC'),
(4, 'SK'),
(5, 'MB')

INSERT INTO City (CityID, Name, ProvinceID) VALUES
(1,	'Montreal',	1),
(2,	'Toronto',	2),
(3,	'Vancouver',	3),
(4,	'Regina',	4),
(5,	'Winnipeg',	5)

INSERT INTO Address (AddressID, Number, StreetName, Appartment, CityID, CodePostal) VALUES
(7001,	112,	'Burnaby Street',	NULL,	3,	'V5H3Z7'),
(7002,	114,	'Rue Villeneuve',	NULL,	1,	'H2T1L2'),
(7003,	2425,	'Rue Christophe Colombe',	NULL,	1,	'H6Z1Q3'),
(7004,	1,	'Demeure Lane',	NULL,	4,	'S0G3W0'),
(7005,	45,	'Winnington Avenue',	35,	5,	'R2C0B9'),
(7006,	3054,	'St-Denis',	NULL,	3,	'V5H3Z8'),
(7007,	4,	'St-Laurent',	NULL,	1,	'H2T1L3'),
(7008,	55,	'Queen Anne Circle',	2,	1,	'H6Z1Q5'),
(7009,	9452,	'Guildwood Blvd.',	NULL,	4,	'S0G3W9'),
(7010,	23,	'St-Jean Trail',	NULL,	5,	'R2C0B9'),
(7011,	466,	'Rachelle Street',	NULL,	3,	'V5H3Z8'),
(7012,	145,	'St-Denis',	NULL,	1,	'H2T1L3'),
(7013,	1457,	'St-Laurent',	NULL,	1,	'H6Z1Q4'),
(7014,	1,	'Prince George Avenue',	NULL,	3,	'V5H3Z9'),
(7015,	98,	'Avenue du Mont-Royal',	NULL,	1,	'H2T1L8'),
(7016,	934,	'St-Charles',	NULL,	1,	'H6Z1Q8'),
(7017,	113,	'Marie-Anne Lane',	NULL,	4,	'S0G3W9'),
(7018,	56,	'Main',	NULL,	5,	'R2C0B1')

INSERT INTO Clients (ClientID, FirstName, LastName, AddressID, Birthdate) 
VALUES
(6001,	'Sandra',	'Fiori',	NULL,	NULL),
(6002,	'Roger',	'Starr',	7001,	'1961-06-15'),
(6003,	'Daniel',	'Xu',	7002,	NULL),
(6004,	'Ivan',	'Longinus',	7003,	'1999-05-30'),
(6005,	'Bassam',	'Morrissette',	7004,	'2000-06-10'),
(6006,	'Sylvie',	'Maksymyk',	7005,	'1991-06-22'),
(6007,	'Andrew',	'Melki',	7006,	'1992-07-04'),
(6008,	'John',	'Rioux',	7007,	'1993-07-17'),
(6009,	'Theresa',	'Clay',	7008,	'1994-07-30'),
(6010,	'Anne',	'Berkow',	NULL,	'1995-08-12'),
(6011, 'Daniel',	'May',	7002,	'1996-08-24'),
(6012,	'Roger',	'Soubury',	NULL,	'1997-09-06'),
(6013,	'John',	'Sinnestinnette',	NULL,	'1998-09-19'),
(6014,	'Jacques',	'Rome',	NULL,	'1999-10-02'),
(6015,	'Pierre',	'Salva',	NULL,	'2000-10-14'),
(6016,	'Charles',	'Auguste',	NULL,	'2001-10-27'),
(6017,	'Berkow',	'Salvail',	NULL,	'2002-11-09'),
(6018,	'Suzanne',	'Auguste',	NULL,	NULL),
(6019,	'Andante',	'Majeur',	7009,	'1959-11-11'),
(6020,	'Larghetto',	'Suzette',	NULL,	'1954-12-31'),
(6021,	'Sam',	'Pinelli',	NULL,	'1945-12-25'),
(6022,	'Allyson',	'Vicini',	7006,	NULL),
(6023,	'Nadia',	'Storm',	7004,	NULL),
(6024,	'Pierre',	'Kelly',	NULL,	NULL),
(6025,	'François',	'Capolla',	NULL,	NULL),
(6026,	'Francis', 	'Bardeau',	NULL,	NULL),
(6027,	'Audrey',	'Letourneux',	NULL,	NULL),
(6028,	'Pierre',	'Létourneau',	NULL,	NULL),
(6029,	'Jonathan', 'Six',	NULL,	NULL),
(6030,	'Donovan',	'Duparc',	NULL,	NULL),
(6031,	'Martin',	'Martin',	NULL,	NULL)

INSERT INTO Invoices (InvoiceID, ClientID, SubTotal, Taxes, Rabais, PurchaseDate, PaymentType) VALUES
(3001,	6021,	56.95,	8.5282625,	1,	'2019-09-15',	'C'),
(3002,	6021,	49.9,	7.472525,	1.5,	'2019-09-15',	'E'),
(3003,	6015,	18.65,	2.7928375,	0,	'2019-09-15',	'E'),
(3004,	6031,	19.65,	2.9425875,	0,	'2019-09-15',	'E'),
(3005,	6001,	25.95,	3.8860125,	3,	'2019-09-15',	'E'),
(3006,	6012,	19.65,	2.9425875,	0,	'2019-09-15',	'E'),
(3007,	6001,	18.65,	2.7928375,	0,	'2019-09-15',	'E'),
(3008,	6001,	25.95,	3.8860125,	0,	'2019-09-16',	'C'),
(3009,	6015,	19.65,	2.9425875,	0,	'2019-09-16',	'C'),
(3010,	NULL,	18.65,	2.7928375,	0,	'2019-09-16',	'C'),
(3011,	NULL,	22.43,	3.3588925,	0,	'2019-09-16',	'C'),
(3012,	6013,	25.95,	3.8860125,	0,	'2019-09-16',	'E'),
(3013,	6014,	22.43,	3.3588925,	0,	'2019-09-16',	'E'),
(3014,	6015,	18.65,	2.7928375,	0,	'2019-09-16',	'E'),
(3015,	6001,	23.95,	3.5865125,	3,	'2019-09-17',	'C')

INSERT INTO CakesCategories (CakeCategoryID, CategoryName) VALUES
(1,	'Chocolat'),
(2,	'Vanilla Fruit')

INSERT INTO CakeSubCategories (CakeSubCategoryID, SubCategoryName, CakeCategoryID, ListPrice) VALUES
(1,	'Mike''s Moka Magic',	1,	19.65),
(2,	'Berri Raspberry',	2,	18.65),
(3,	'Chocolate Dreme',	1,	25.95),
(4,	'Crème-berry',	2,	23.95),
(5,	'Garden of Eden',	2,	22.43),
(6,	'Péché Pèche',	2,	18.65)

INSERT INTO CakeInventory (CakeInventoryID, DateFabrication, CakeSubCategoryID, CakeStatus, SellDisposeDate) VALUES
(100001,	'2019-09-13',	3,	'J',	'2019-09-15'),
(100002,	'2019-09-13',	6,	'V',	'2019-09-15'),
(100003,	'2019-09-13',	1,	'V',	'2019-09-15'),
(100004,	'2019-09-13',	2,	'V',	'2019-09-15'),
(100005,	'2019-09-13',	1,	'J',	'2019-09-15'),
(100006,	'2019-09-13',	4,	'V',	'2019-09-15'),
(100007,	'2019-09-13',	3,	'V',	'2019-09-15'),
(100008,	'2019-09-13',	6,	'V',	'2019-09-15'),
(100009,	'2019-09-13',	1,	'J',	'2019-09-15'),
(100010,	'2019-09-13',	2,	'J',	'2019-09-16'),
(100011,	'2019-09-13',	1,	'V',	'2019-09-15'),
(100012,	'2019-09-13',	3,	'J',	'2019-09-15'),
(100013,	'2019-09-15',	3,	'V',	'2019-09-15'),
(100014,	'2019-09-15',	6,	'N',	NULL),
(100015,	'2019-09-15',	1,	'V',	'2019-09-15'),
(100016,	'2019-09-15',	2,	'V',	'2019-09-15'),
(100017, '2019-09-15',	1,	'N',	NULL),
(100018,	'2019-09-15',	4,	'N',	NULL),
(100019,	'2019-09-15',	3,	'V',	'2019-09-16'),
(100020,	'2019-09-15',	4,	'N',	NULL),
(100021,	'2019-09-15',	1,	'V',	'2019-09-16'),
(100022,	'2019-09-16',	2,	'V',	'2019-09-16'),
(100023,	'2019-09-16',	5,	'V',	'2019-09-16'),
(100024,	'2019-09-16',	6,	'N',	NULL),
(100025,	'2019-09-16',	3,	'N',	NULL),
(100026,	'2019-09-16',	6,	'N',	NULL),
(100027,	'2019-09-16',	3,	'V',	'2019-09-16'),
(100028,	'2019-09-16',	4,	'N',	NULL),
(100029,	'2019-09-16',	5,	'V',	'2019-09-16'),
(100030,	'2019-09-16',	2,	'N',	NULL),
(100031,	'2019-09-16',	6,	'V',	'2019-09-16'),
(100032,	'2019-09-16',	4,	'V',	'2019-09-17')

INSERT INTO SalesDetails (SalesDetailID, CakeInventoryID, SalesPrice, InvoiceID) VALUES
(1,	100002,	18.65,	3001),
(2,	100003,	19.65,	3001),
(3,	100004,	18.65,	3001),
(4,	100006,	23.95,	3002),
(5,	100007,	25.95,	3002),
(6,	100008,	18.65,	3003),
(7,	100011,	19.65,	3004),
(8,	100013,	25.95,	3005),
(9,	100015,	19.65,	3006),
(10,	100016,	18.65,	3007),
(11, 100019,	25.95,	3008),
(12,	100021,	19.65,	3009),
(13,	100022,	18.65,	3010),
(14,	100023,	22.43,	3011),
(15,	100027,	25.95,	3012),
(16,	100029,	22.43,	3013),
(17, 100031,	18.65,	3014),
(18,	100032,	23.95,	3015)

  --Partie D


ALTER TABLE Clients
ADD FOREIGN KEY (AddressID) REFERENCES Address(AddressID)

ALTER TABLE Invoices
ADD FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)

ALTER TABLE CakeInventory
ADD FOREIGN KEY (CakesubCategoryID) REFERENCES CakeSubCategories(CakesubCategoryID)

ALTER TABLE CakeSubCategories
ADD FOREIGN KEY (CakeCategoryID) REFERENCES CakesCategories(CakeCategoryID)

ALTER TABLE SalesDetails
ADD FOREIGN KEY (CakeInventoryID) REFERENCES CakeInventory(CakeInventoryID)

ALTER TABLE SalesDetails
ADD FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID)

ALTER TABLE City
ADD FOREIGN KEY (ProvinceID) REFERENCES Province(ProvinceID)

ALTER TABLE Address
ADD FOREIGN KEY (CityID) REFERENCES City(CityID)

-- Partie E 


ALTER TABLE Invoices
DROP CONSTRAINT IF EXISTS Max_Rabais;

ALTER TABLE Invoices
ADD CONSTRAINT Max_Rabais
CHECK (Rabais <= 3)

ALTER TABLE CakeInventory
DROP CONSTRAINT IF EXISTS CakeInventory_CakeStatus;

ALTER TABLE CakeInventory
ADD CONSTRAINT CakeInventory_CakeStatus
CHECK (CakeStatus IN ('N','V','J'))

ALTER TABLE Invoices
DROP CONSTRAINT IF EXISTS Invoices_PaymentType;

ALTER TABLE Invoices
ADD CONSTRAINT Invoices_PaymentType
CHECK (PaymentType IN ('C','E'))


  -- Partie F

DROP TRIGGER IF EXISTS StatusChange
GO

CREATE TRIGGER StatusChange ON CakeInventory
AFTER UPDATE
AS
BEGIN
	DECLARE @Status_avant CHAR(1);
	DECLARE @Status_apres CHAR(1);
   DECLARE @id INT

	
	SET @Status_apres = (SELECT CakeStatus FROM INSERTED);
	SET @Status_avant = (SELECT CakeStatus FROM DELETED);
   SET @id = (SELECT CakeInventoryID FROM INSERTED)

   UPDATE CakeInventory	
      SET SellDisposeDate = GETDATE()
      WHERE CakeInventoryID = @id
END

--Validation

SELECT * FROM CakeInventory
UPDATE CakeInventory
   SET  CakeStatus= 'J'
WHERE CakeInventoryID = 100018;
SELECT * FROM CakeInventory

-- Partie G

INSERT INTO Invoices (ClientID, PurchaseDate, PaymentType)
VALUES (6002, GETDATE(), 'C')

INSERT INTO SalesDetails (CakeInventoryID) 
Values (100014)

INSERT INTO SalesDetails (CakeInventoryID) 
Values (100030)
