 /*
 *		TECH20712 -- Gestion des bases de données
 *		
 *		HEC Montréal,
 *		Travail Pratique 4	
 *		
 *		Instructions de remise : 
 *			-Répondre aux questions directement dans ce fichier .sql
 *			-A remettre via ZoneCours dans l'outil de remise de travaux
 *
 *		Correction : 
 *			- 10% de la note finale.
 *			- Si une réponse génère une erreur (ne s'exécute pas),
 *           cette partie du travail recevra la note de 0.
 *
 */

 USE AdventureWorks2014;
 GO

/*
Question 1 :
		C’est le temps de l’évaluation annuelle de la performance et 
		la vice-présidente des ventes a besoin d’un rapport.
		Elle vous demande la liste des vendeurs chez AdventureWorks
		dont les ventes (SalesYTD = sales year to date) sont supérieures à 
		la moyenne des SalesYTD de tous les vendeurs. 
		Cela lui permettra de savoir quels vendeurs performent mieux que la moyenne. 
		
		Le rapport devrait inclure les colonnes suivantes :
		ID vendeur, prénom, nom, SalesYTD, 
		ainsi que l’écart entre SalesYTD et la moyenne des SalesYTD de tous les
		vendeurs, le tout ordonné par ID du vendeur.

		Cette requête incorpore seulement les deux tables Person.Person et Sales.SalesPerson.
*/



SELECT p.BusinessEntityID AS 'ID vendeur', p.FirstName AS 'Prénom', p.LastName AS 'Nom', s.SalesYTD, (s.SalesYTD - (SELECT AVG(SalesYTD) FROM Sales.SalesPerson))  AS 'Ecart des ventes'
FROM Person.Person p 
INNER JOIN Sales.SalesPerson s ON p.BusinessEntityID = s.BusinessEntityID
WHERE p.PersonType= 'SP' AND s.SalesYTD > (SELECT AVG(SalesYTD) FROM Sales.SalesPerson)
ORDER BY 1

/*

Question 2 a :
		Créez une requête qui montre le montant total des commandes (soit SUM(soh.SubTotal)) 
		avant taxes et transport  
		pendant le dernier trimestre de 2013. Il ne s'agit que des ventes en magasin.
		Les résultats auront les colonnes suivantes : 
		Store.BusinessEntityID AS [StoreID], 
		SUM(SalesOrderHeader.SubTotal) AS [Ventes2013]. 
*/

SELECT ss.BusinessEntityID AS "Store ID", SUM(soh.SubTotal) AS "Ventes2013"
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer sc ON sc.CustomerID = soh.CustomerID
LEFT JOIN Sales.Store ss ON ss.BusinessEntityID = sc.StoreID
WHERE YEAR(soh.OrderDate) = 2013 
AND DATEPART(QUARTER, OrderDate) = 4
AND soh.OnlineOrderFlag = 0
GROUP BY ss.BusinessEntityID
ORDER BY 2 DESC

/*
Question 2 b :
		Créez une requête qui montre 
		le montant total des commandes (soit SUM(soh.SubTotal)) 
		avant taxes et transport  
		pendant le premier trimestre de 2014. Il ne s'agit que des ventes en magasin.
		Les résultats auront les colonnes suivantes : 
		Store.BusinessEntityID AS [StoreID], 
		SUM(SalesOrderHeader.SubTotal) AS [Ventes2014_Q1]. 

		Incorporez la réstriction suivante : on voudrait voir seulement
		les magasins pour lesquelles la somme des commandes est supérieure
		à $20,000.00.
*/

SELECT ss.BusinessEntityID AS "Store ID", SUM(soh.SubTotal) AS "Ventes2014_Q1"
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer sc ON sc.CustomerID = soh.CustomerID
LEFT JOIN Sales.Store ss ON ss.BusinessEntityID = sc.StoreID
WHERE YEAR(soh.OrderDate) = 2014 
AND DATEPART(QUARTER, OrderDate) = 1
AND soh.OnlineOrderFlag = 0
GROUP BY ss.BusinessEntityID
HAVING (SUM(soh.SubTotal) > 20000.00)
ORDER BY 2

/*
Question r2 c:
		(Pour répondre à cette question, vous combinerez les requêtes 2a et 2b.) 

		La vice-présidente des ventes aimerait savoir pour quelles boutiques 
		la SUM(soh.SubTotal) du premier trimestre 2014 est supérieure 
		à la moyenne des SUM(soh.SubTotal) du dernier trimestre de 2013. 
		Il s'agit d'incorporer la requête 2a comme une sous-requête 
		dans la requête 2b.
		Il ne s'agit que des ventes en magasin.

		
		Votre collègue mentionne qu'elle veut retrouver dans la liste uniquement 
		l'ID du magasin et son nom, ordonné par ID du magasin.

*/

SELECT ss.BusinessEntityID AS 'Store ID', ss.Name AS 'Nom du magasin'
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer sc ON sc.CustomerID = soh.CustomerID
LEFT JOIN Sales.Store ss ON ss.BusinessEntityID = sc.StoreID
WHERE soh.OnlineOrderFlag = 0 AND YEAR(soh.OrderDate) = 2014 AND DATEPART(QUARTER, soh.OrderDate) = 1
GROUP BY  ss.BusinessEntityID, ss.Name
HAVING SUM(soh.SubTotal) >
    (
    SELECT AVG(SubQ.Ventes2013_Q4)
    FROM
        (
        SELECT SUM(soh.SubTotal) AS Ventes2013_Q4
        FROM Sales.SalesOrderHeader soh
        INNER JOIN Sales.Customer sc ON sc.CustomerID = soh.CustomerID
        LEFT JOIN Sales.Store ss ON ss.BusinessEntityID = sc.StoreID
        WHERE soh.OnlineOrderFlag = 0 AND YEAR(OrderDate) = 2013 AND DATEPART(QUARTER, OrderDate) = 4
        GROUP BY  ss.BusinessEntityID
        ) AS SubQ
    )
ORDER BY 1


/*
Question 3: Voir document Word: Sylvester Hedge Fund
*/

DROP FUNCTION IF EXISTS valeurActuelle
GO 

CREATE FUNCTION valeurActuelle(@DateDebut DATE, @DateFin DATE, @DateMesure DATE, @Notionnel FLOAT, @TauxCoupon FLOAT, @TauxActualisation FLOAT)
RETURNS FLOAT
AS 
BEGIN
    DECLARE @P FLOAT
    DECLARE @M FLOAT
    DECLARE @F FLOAT
    SET @M = (1 + DATEDIFF(DAY, @DateDebut, @DateFin) / 365.0 * @TauxCoupon / 100.0) * @Notionnel
    SET @F = (1 / (POWER((1 + @TauxActualisation / 100.0), DATEDIFF(DAY, @DateMesure, @DateFin) / 365.0)))
	IF (DATEDIFF(DAY, @DateMesure, @DateFin) < 0)
		SET @P = 0.00
    ELSE
	SET @P = @M * @F
RETURN @P
END
GO

USE Bonds
GO

DECLARE @dateMesure DATE;
SET @dateMesure = '2019-11-30'
SELECT TRIM(REPLACE(CUSIP, '_', '')) AS CUSIP , StartDate
, EndDate
, Notional
, CouponRate
, @dateMesure As MeasurementDate
, FORMAT(dbo.valeurActuelle(StartDate, EndDate, @dateMesure, Notional, CouponRate, 2.57), '#,##0.00') As PresentValue
FROM BondData1

