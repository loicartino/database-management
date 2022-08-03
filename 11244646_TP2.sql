/*
 *		-- Gestion des bases de donn�es
 *		HEC Montr�al
 *		Travail Pratique 2	

 *		Instructions de remise : 
 *			-R�pondre aux questions directement dans ce fichier .sql
 *			-Remettez �galement le mod�le logique en format PDF.
 *			-Les mod�les logiques peuvent se construire avec le logiciel Visio. Vous avez acc�s au t�l�chargment de Visio 
 *			 via MSDNAA et nous vous conseillons de l'utiliser. Vous pouvez aussi utiliser draw.io (outil gratuit
 *			 Google en ligne https://www.draw.io/). Nous tol�rerons toutefois des diagrammes faits � main 
			 pour autant qu'ils soient clairs et lisibles.
 *			-A remettre via ZoneCours dans Remise de travaux
 *
 *		Correction : 
 *			- Si le code d'une r�ponse g�n�re une erreur (ne peut pas s'ex�cuter), la note de 0 sera attribu�e � cette partie du travail.
 *			
 */
 USE AdventureWorks2014;
 GO
/*
	Question #1 : 
			La vice-pr�sidente des ventes a remarqu� que, des fois, un SalesOrderDetail peut comprendre une Quantit� assez �l�v�e d'un m�me produit.
			Elle vous demande de lui aider � mieux comprendre cette situation. Ensemble, vous concevez une requ�te ayant les colonnes suivantes:
			SalesOrderDetailID, Product Number, Product Name, List Price, et Order Quantity. 
			(Cette liste ne doit contenir que les produits finis 
		    qui peuvent �tre vendus � l'heure actuelle et qu'on n'a pas l'intention d'arr�ter de vendre.) 
			Votre requ�te permet d'apercevoir rapidement  
			la Quantit� la plus �l�v�e de toutes les SalesOrderDetails. 
*/
-- R�PONSE Q1: 
 
SELECT DISTINCT sod.SalesOrderDetailID, p.ProductNumber, p.Name, p.ListPrice, sod.OrderQty
FROM Sales.SalesOrderDetail sod 
LEFT JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE FinishedGoodsFlag = 1 AND DiscontinuedDate IS NULL AND SellEndDate IS NULL
ORDER BY 5 DESC

/*

	Question #2 : 
	        Votre coll�gue aimerait savoir les SalesPersonID pour les cas o� la quantit� sur les SalesOrderDetails est sup�rieure � 30. 
			Modifiez votre requ�te de la question 1 afin de d�terminer cette information. */

-- R�PONSE Q2: 

SELECT soh.SalesPersonID, sod.SalesOrderDetailID, p.ProductNumber, p.Name AS 'Product Name', p.ListPrice, sod.OrderQty
FROM Sales.SalesOrderDetail sod 
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE FinishedGoodsFlag = 1 
AND DiscontinuedDate IS NULL AND SellEndDate IS NULL
GROUP BY SalesPersonID, SalesOrderDetailID, ProductNumber, Name, ListPrice, OrderQty
HAVING (OrderQty > 30)

/*
	Question #3 :
		Votre coll�gue aimerait avoir une liste ayant trois colonnes : Quantit� totale, Product Name et SalesPersonID. 
		Il s'agit d'une liste qui montre  
		les Quantit�s totales sur les SalesOrderHeaders,
		par produit, par SalesPersonID, et ce, pour les produits vendus par un vendeur (donc, excluant les produits vendus sur l'internet). 
		La liste devrait inclure seulement les ventes faites entre 2012-01-01 et 2012-12-31

		Modifiez votre requ�te de la question 2 afin de d�terminer cette information. */
-- R�PONSE Q3: 

SELECT soh.SalesPersonID, p.Name, SUM(sod.OrderQty) AS 'Quantité Totale'
FROM Sales.SalesOrderDetail sod 
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE OnlineOrderFlag = 0 
AND FinishedGoodsFlag = 1 
AND DiscontinuedDate IS NULL 
AND SellEndDate IS NULL
AND OrderDate BETWEEN '2012-01-01' AND '2012-12-31'
GROUP BY SalesPersonID, Name

/*
	Question #4 :---------------------------

		La vice-pr�sidente des ventes et vous approfondissez votre compr�hension 
		des tables que vous avez utilis�es dans vos requ�tes, soit:
			- Sales.SalesOrderHeader
			- Sales.SalesOrderDetails
			- Production.Product

		Dessinez le mod�le logique de ces tables. Votre dessin doit inclure les 3 tables,
		leur noms, leur colonnes. Identifiez les cl�s (PK ou FK). Indiquez les cardinalit�s (minimale et maximale) au moyen
		de "crow's feet". 
		
		Vous utiliserez des requ�tes pour d�montrer les cardinalit�s. 
		Il fait analyser les cardinalit�s pour le rapport entre les tables Product et SalesOrderDetail,
		et les cardinalit�s entre les tables SalesOrderDetail et SalesOrderHeader.  
		Pour vous aider � faire cette partie du TP, l'analyse concernant les tables Product et SalesOrderDetail
		est donn�e ici : */

    /* Analyse du rapport entre les tables Product et SalesOrderDetail:
	Examinez et ex�cutez les requ�tes suivantes. */

	-- Un Product .... 
	SELECT Production.Product.ProductID, Sales.SalesOrderDetail.SalesOrderDetailID
	FROM Production.Product LEFT JOIN Sales.SalesOrderDetail
	ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
	ORDER BY Production.Product.ProductID, Sales.SalesOrderDetail.SalesOrderDetailID;

	SELECT Production.Product.ProductID, COUNT(Sales.SalesOrderDetail.SalesOrderDetailID) As SalesOrderDetail_Count
	FROM Production.Product LEFT JOIN Sales.SalesOrderDetail
	ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
	GROUP BY Production.Product.ProductID 
	ORDER BY Production.Product.ProductID, 2;

	/* En examinant les r�sultats de deux requ�tes ci-dessus, on conclut:
	Un Product peut appara�tre sur z�ro ou plusieurs SalesOrderDetails.
    */
	
	-- Un SalesOrderHeader  .... 
	SELECT Sales.SalesOrderDetail.SalesOrderDetailID, Production.Product.ProductID
	FROM Sales.SalesOrderDetail LEFT JOIN Production.Product 
	ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
	ORDER BY Sales.SalesOrderDetail.SalesOrderDetailID, Production.Product.ProductID ;

	SELECT Sales.SalesOrderDetail.SalesOrderDetailID, COUNT(Production.Product.ProductID) As Product_Count
	FROM Sales.SalesOrderDetail LEFT JOIN Production.Product 
	ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
	GROUP BY Sales.SalesOrderDetail.SalesOrderDetailID
	ORDER BY Sales.SalesOrderDetail.SalesOrderDetailID, 2 ;
	/* En examinant les r�sultats de deux requ�tes ci-dessus, on conclut:
	Un SalesOrderDetail a toujours exactement un Product.

	Maintenant, � vous d'�crire des requ�tes pour analyser le rapport entre les tables SalesOrderHeader et SalesOrderDetail. 
	Suivez le mod�le �tabli par les requ�tes pr�cedentes. */

	-- Un SalesOrderDetail .... 
	SELECT sod.SalesOrderDetailID, COUNT(*) As 'Nombre de SOD'
	FROM Sales.SalesOrderDetail sod 
	LEFT JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
	GROUP BY sod.SalesOrderDetailID
	ORDER BY sod.SalesOrderDetailID, 2
	-- Un SOD a toujours exactement un seul SOH et SalesOrderID dans SOD est une FK de type NOT NULL.

	/* En examinant les r�sultats de deux requ�tes ci-dessus, on conclut:
	Un SalesOrderDetail a toujours exactement un SalesOrderHeader.
    */
	
	-- Un SalesOrderDetail  .... 
	SELECT soh.SalesOrderID, COUNT(*) As 'Nombre de SOH'
	FROM Sales.SalesOrderHeader soh 
	LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
	GROUP BY soh.SalesOrderID
	ORDER BY soh.SalesOrderID, 2
	-- Un SOH peut avoir un ou plusieurs SOD.

	/* En examinant les r�sultats de deux requ�tes ci-dessus, on conclut:
	Un SalesOrder peut avoir un ou plusieurs SalesOrderDetails. */


