/*
 *      -- Gestion des bases de données
 *		
 *		HEC Montréal,
 *		Travail Pratique 1	

 *		Instructions de remise : 
 *			- Répondre aux questions directement dans ce fichier SQL
 *			- Remettre via ZoneCours dans Remise de travaux
 *
 *		Instructions supplémentaires 
 *			- Aucun JOIN nécessaire pour ce TP.
 *			- Que des SELECT, FROM, WHERE, GROUP BY et des fonctions d'agrégation.
 *			- Assurez-vous d'avoir la base d'AdventureWorks2014 sur votre ordinateur!  		
 *
 *		Correction : 
 *			- Si le code d'une réponse génère une erreur (ne peut pas s'exécuter), la note de 0 sera attribuée à cette partie du travail.

	- Mise en contexte : 
		Vous êtes analyste d'affaires travaillant au siège social de la société AdventureWorks. 
		Vous travaillez étroitement avec la haute gestion et répondez à leurs demandes. 
*/

USE AdventureWorks2014;
GO


/*
=>Question 1
		La vice-présidente des ventes vous demande la liste des prix
		de tous les produits dont la taille est ou "Small", ou "Medium", ou "Large" et dont la couleur 
		est noir ou bleu. Elle indique que la liste résultante 
		devrait contenir seulement les codes de produits (ProductNumber), les prix de vente, et une colonne qui indique à qui les produits sont 
		destinés (NULL, U, M ou W). De plus, cette liste ne doit contenir que les produits finis 
		qui peuvent être vendus à l'heure actuelle et qu'on n'a pas l'intention d'arrêter de vendre.
*/

--RÉPONSE Q1 : 

SELECT ProductNumber, ListPrice, Style FROM Production.Product
WHERE (
    Size = 'S' OR Size = 'M' OR Size = 'L'
)
AND (
    Color = 'Black' OR Color = 'Blue'
)
AND FinishedGoodsFlag = 1
AND DiscontinuedDate IS NULL 
AND SellEndDate IS NULL

/*
=>Question 2
a)

	La vice-présidente des ventes aimerait savoir la
	différence, en moyenne, entre le prix de vente et le coût de production des produits, et ce, par
	couleur de produits (pour toutes les couleurs possibles). 

	Comme avant, elle veut que l'information ne contienne que les produits finis qui
	peuvent être vendus à l'heure actuelle et qu'on ne planifie pas d'arrêter de vendre.

	Prenez soin d'inclure également le nombre de produits associé à chacune des couleurs
	et de nommer les colonnes de façon appropriée. Triez la liste dans l'ordre décroissant 
	de la moyenne de la différence entre le prix vendu et le coût de production. */
	
	-- RÉPONSE Q2a : 
 
SELECT  Color,
COUNT(*) AS 'Nombre de produits',
AVG(ListPrice - StandardCost) AS 'Profit Moyen'
FROM Production.Product
WHERE FinishedGoodsFlag = 1 
AND DiscontinuedDate IS NULL AND SellEndDate IS NULL
GROUP BY Color
ORDER BY 3 DESC 

/*
b)
	Que pouvez-vous conclure des résultats obtenus?
*/

/* Les produits blancs ont la marge de profit la plus faible, 
tandis que les produits rouges ont la marge de profit moyenne la plus élevée. */

/*
c)
	La vice-présidente des ventes vous demande s'il serait possible de modifier le tableau obtenu en
	2a, en ajoutant une colonne pour les coûts moyens, une colonne pour les prix moyens 
	et une colonne pour le temps de fabrication (DaysToManufacture).  
	Elle s'intéresse aux regroupements (Color, DaysToManufacture) pour lesquels la différence entre le prix de vente moyen et le coût de production 
	moyen est supérieur à 50$. Les noms des colonnes seraient comme suit :
			
	__________________________________________________________________________________________________________________________
	|  Color  | DaysToManufacture | Coût de production moyen | Prix de vente moyen | Différence moyenne entre Prix et Coût  |
	--------------------------------------------------------------------------------------------------------------------------
	|	 ...   |       ...        |           ...            |        ...          |				     ...		        |


*/
	-- RÉPONSE Q2c : 

SELECT Color,
DaysToManufacture,
AVG(StandardCost) AS 'Coût de production moyen',
AVG(ListPrice) AS 'Prix de vente moyen',
AVG(ListPrice - StandardCost) AS 'Différence moyenne entre Prix et Coût'
FROM Production.Product
WHERE FinishedGoodsFlag = 1 
AND SellEndDate IS NULL AND DiscontinuedDate IS NULL AND Style IS NOT NULL
GROUP BY Color, DaysToManufacture
HAVING (AVG(ListPrice - StandardCost) > 50)

/*
=>Question 3
a)
	Suite à sa propre investigation avec SQL, 
	la vice-présidente des ventes vous dit que l'attribut Style ne peut prendre que les valeurs U, M et W. A-t-elle raison?
	Sans ultilser le mot clé DISTINCT, composer une requête qui vous permet de le vérifier cette affirmation. */

	-- RÉPONSE Q3a : 

SELECT Style
FROM Production.Product
GROUP BY Style

-- FAUX, la colonne Style peut également prendre des valeurs de type NULL.

/*  
b)  	Vous montrez votre requête à votre collègue.  Elle dit avoir utilisé le mot clé DISTINCT, 
    et c'est pour cette raison que ses résultats sont différents des vôtres. 
	A-t-elle raison? Faites une requête avec DISTINCT qui vous permet de vérifier.
*/
	-- RÉPONSE Q3b : 
 
SELECT DISTINCT Style
FROM Production.Product

/* L'utilisation de DISTINCT permet d'afficher les différentes valeurs que peut prendre la colonne, 
sans avoir à utiliser une clause GROUP BY. Cependant, les résultats restent les mêmes qu'à la question Q3a.
*/



