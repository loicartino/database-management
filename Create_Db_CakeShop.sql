-- Créer la base de données

DROP DATABASE IF EXISTS CakeShop

CREATE DATABASE CakeShop
GO
USE CakeShop
GO

-- Créer chaque table de la base de données

CREATE TABLE Province
    ( 
       ProvinceID SMALLINT NOT NULL PRIMARY KEY,
       Name NVARCHAR(20) NOT NULL
    )

CREATE TABLE City
    ( 
       CityID INT NOT NULL PRIMARY KEY,
       Name NVARCHAR(20) NOT NULL,
       ProvinceID SMALLINT NULL FOREIGN KEY REFERENCES Province(ProvinceID)
    )

CREATE TABLE Address
    ( 
       AddressID INT NOT NULL PRIMARY KEY,
       Number INT NOT NULL,
       StreetName NVARCHAR(50) NOT NULL,
       Appartment INT NULL,
       CityID  INT NULL FOREIGN KEY REFERENCES City(CityID),
       CodePostal NCHAR(6) NOT NULL
    )

CREATE TABLE Clients
    ( 
       ClientID INT NOT NULL PRIMARY KEY,
       FirstName NVARCHAR(30) NULL,
       LastName NVARCHAR(30) NULL,
       AddressID  INT NULL FOREIGN KEY REFERENCES Address(AddressID),
       Birthdate DATE NULL
    )

CREATE TABLE Invoices
    ( 
       InvoiceID INT NOT NULL PRIMARY KEY,
       ClientID INT NULL FOREIGN KEY REFERENCES Clients(ClientID),
       Taxes FLOAT NOT NULL,
       PurchaseDate DATE NOT NULL,
       SubTotal FLOAT NOT NULL,
       Rabais FLOAT NULL,
       PaymentType CHAR(1)
    )

CREATE TABLE CakesCategories
   (
      CakeCategoryID INT NOT NULL PRIMARY KEY,
      CategoryName NVARCHAR(20) NOT NULL
   )

CREATE TABLE CakeSubCategories
   (
      CakeSubCategoryID INT NOT NULL PRIMARY KEY,
      SubCategoryName NVARCHAR(30) NOT NULL,
      CakeCategoryID INT NOT NULL FOREIGN KEY REFERENCES CakesCategories(CakeCategoryID),
      ListPrice FLOAT NOT NULL
   )

CREATE TABLE CakeInventory
   (
      CakeInventoryID INT NOT NULL PRIMARY KEY,
      DateFabrication DATE NOT NULL,
      CakeSubCategoryID INT NOT NULL FOREIGN KEY REFERENCES CakeSubCategories(CakeSubCategoryID),
      CakeStatus CHAR(1),
      SellDisposeDate DATE NULL
   )

CREATE TABLE SalesDetails
   (
      SalesDetailID INT NOT NULL PRIMARY KEY,
      CakeInventoryID INT NOT NULL FOREIGN KEY REFERENCES CakeInventory(CakeInventoryID),
      SalesPrice FLOAT NOT NULL,
      InvoiceID INT NOT NULL FOREIGN KEY REFERENCES Invoices(InvoiceID)
   )

/* ------------------------------------------------------------------------------------- */

  -- Créer un trigger de modification (Partie F)
CREATE TRIGGER StatusChange ON CakeInventory
AFTER UPDATE
AS
BEGIN
	DECLARE @Status_avant CHAR(1);
	DECLARE @Status_apres CHAR(1);

	
	SET @Status_apres = (SELECT CakeStatus FROM INSERTED);
	SET @Status_avant = (SELECT CakeStatus FROM DELETED);

INSERT INTO CakeInventory (CakeStatus, SellDisposeDate) 						
    VALUES (@Status_apres, GETDATE())
END
