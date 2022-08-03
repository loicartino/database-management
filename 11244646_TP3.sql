/*
Gestion des bases de données
HEC Montréal automne 2019
Modifié par Ivan Maksymyk
Travail Pratique 3	
 		
Vous remettrez un fichier pdf (Question 1) 
et un fichier sql (Questions 2, 3, et 4),
dans Remise de travaux sur ZoneCours. 

Pour la question 1, Dessin du modèle logique,
vous pouvez utiliser draw.io, un outil en ligne de Google https://www.draw.io/ (c'est gratuit). 
Des diagrammes faits à main levée sont acceptables aussi,
tant qu'ils soient clairs et lisibles. 
Prenez une photo de votre dessin (si celui-ci est fait à la main) 
ou une capture d'écran de votre dessin drawio, 
insérez l'image dans un document word, et faites-en un pdf. 

Quant aux questions 2, 3, et 4, prière de mettre vos réponses
directement dans ce document sql. 
 
Correction : 
- 10% de la note finale.
- Si votre code génère une erreur (ne peut pas s'exécuter), 
la note de 0 sera attribuée à cette partie du travail. 
 */


USE AdventureWorks2014;
GO

/*
-- Question 1, Dessin du modèle logique --
Examinez les cinq tables suivantes:
	Sales.Customer
	Sales.Store
	Sales.SalesOrderHeader
	Person.Person
	Sales.SalesPerson

Préparez un dessin du modèle logique de ces tables.  
Dans votre dessin, indiquez les PK (clés primaires), les FK (clés lointaines) et les attributs
que vous utilisez dans vos requêtes (questions 2 et 3). Indiquez seulement les FK 
qui sont reliées aux tables dans l'analyse. 

Alignez les bouts des lignes avec les noms des champs, pour maximiser la
lisibilité et l'utilité de votre dessin.  

Des informations utiles sur les cinq tables se trouvent dans le document
AdventureWorks2014_info_pour_TECH20712.docx. 
*/

-- Notes pour la Question 1 : 

/* 	
	CustomerID est un attribut de la table Sales.SalesOrderHeader
	BusinessEntityID est un attribut des tables Sales.Customer et Sales.SalesPerson
*/

/*
-- Question 2
Vos collègues aimeraient pouvoir comparer la performance des boutiques en 2013.
Ils'intéressent à connaître les ventes
(en dollars, excluant les taxes et les frais de livraison), par boutique. 
Ils s'intéressent seulement aux ventes faites en boutique.  
Les résultats auront les trois colonnes suivantes :

[StoreID du magasin] [Nom du magasin] [Ventes en 2013]

Dans la colonne [Ventes en 2013], affichez les montants sans les centimes, 
et avec le séparateur des milliers.
Exemple: 418802.4507 s'affichera comme ceci : 418,802 ou 418 802.  

Écrivez le code pour cette requête. 

*/
SELECT sc.StoreID AS 'StoreID du magasin', ss.Name AS 'Nom du magasin', FORMAT(soh.SubTotal, '#,###') AS 'Ventes en 2013'
FROM Sales.Customer sc
LEFT JOIN Sales.Store ss ON sc.StoreID = ss.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh ON sc.CustomerID = soh.CustomerID
WHERE soh.OnlineOrderFlag = 0 AND soh.OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY sc.StoreID, ss.Name, soh.SubTotal
ORDER BY 1

/* 
-- Question 3
Vos collègues aimeraient pouvoir comparer la performance des vendeurs, 
pour 2012, 2013 et 2014.
Ils'intéressent à connaître les ventes
(en dollars, excluant les taxes et les frais de livraison), par vendeur, par an. 
Ils aimeraient voir les noms et les identifiants des vendeurs. 
Ils s'intéressent seulement aux ventes faites en boutique. 
Le nom du vendeur (prénom et nom de famille) doit être dans une seule colonne. 
Les résultats auront les quatre colonnes suivantes :

[SalesPersonID] [Nom du vendeur] [Année] [Ventes]

Dans la colonne [Ventes], affichez les montants sans les centimes, 
et avec le séparateur des milliers.
Exemple: 418802.4507 s'affichera comme ceci : 418,802 ou 418 802.  

Incluez un ORDER BY selon le nom du vendeur et selon l'an.  

Écrivez le code pour cette requête. 

*/

SELECT soh.SalesPersonID, CONCAT(pp.FirstName,' ', pp.MiddleName,' ', pp.LastName) AS 'Name', YEAR(soh.OrderDate) AS 'Année', FORMAT(soh.SubTotal, '#,###') AS 'Ventes'
FROM Person.Person pp
INNER JOIN Sales.SalesPerson ssp ON pp.BusinessEntityID = ssp.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader soh ON ssp.BusinessEntityID = soh.SalesPersonID
WHERE pp.PersonType = 'SP' AND soh.OnlineOrderFlag = 0 AND soh.OrderDate BETWEEN '2013-01-01' AND '2014-06-30'
GROUP BY soh.SalesPersonID, pp.FirstName, pp.MiddleName, pp.LastName, soh.SubTotal, YEAR(soh.OrderDate)
ORDER BY Name, YEAR(soh.OrderDate)


-- Question 4
USE ProfsStudentsCoursesBooks;
GO
/* 

Composez une requête qui affiche tous les cours dans la base de données, 
leurs livres, et les montants payés 
par l'ensemble des étudiants pour ces livres.
Les résultats auront les trois colonnes suivantes :

[Nom du cours] [Nom du livre] [Montant payé]

Même si un cours n'a pas de livre ou d'étudiants, il devrait figurer dans la liste, 
et ce, vers la fin de la liste. 

Dans votre code, utilisez seulement RIGHT JOIN et LEFT JOIN.
Il est interdit d'utiliser FULL JOIN et INNER JOIN !! */


SELECT dbo.Courses.CourseName, dbo.Books.BookName, dbo.Books.Price 
FROM dbo.Books 
RIGHT JOIN dbo.Courses ON dbo.Books.BookID = dbo.Courses.BookID
GROUP BY dbo.Courses.CourseName, dbo.Books.BookName, dbo.Books.Price
ORDER BY 2 DESC

/*
SELECT * FROM dbo.Books
SELECT * FROM dbo.People
SELECT * FROM dbo.Courses
*/ 