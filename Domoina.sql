CREATE TABLE Membre(
    CodeMembre varchar(17) primary key,
    Civilite_membre varchar(5),
    Nom_membre varchar(50),
    Prenom_membre varchar(90),
    Email_membre text,
    Infos_membre text
);

CREATE TABLE Difficulte(
    CodeDifficulte varchar(17) primary key,
    Libelle_difficulte varchar(75)
);

CREATE TABLE Groupe(
    CodeGroupe varchar(17) primary key,
    Libelle_groupe varchar(75)
);

CREATE TABLE Categorie(
    CodeCategorie varchar(17) primary key,
    Libelle_categorie varchar(75),
    CodeGroupe varchar(17) references Groupe (CodeGroupe)
);

CREATE TABLE Recette(
    CodeRecette varchar(17) primary key,
    Titre_recette varchar(50),
    Texte_recette text,
    Date_creation date,
    CodeAuteur varchar(17) references Membre (CodeMembre),
    CodeDifficulte varchar(17) references Difficulte (CodeDifficulte),
    CodeCategorie varchar(17) references Categorie (CodeCategorie)
);

CREATE TABLE Unite(
    CodeUnite varchar(17) primary key,
    Libelle_unite varchar(75)
);

CREATE TABLE Ingredient(
    CodeIngredient varchar(17) primary key,
    Libelle_ingredient varchar(75),
    CodeUnite varchar(17) references Unite (CodeUnite)
);

CREATE TABLE Contenir(
    CodeRecette varchar(17) references Recette (CodeRecette),
    CodeIngredient varchar(17) references Ingredient (CodeIngredient),
    Quantite double precision
);

CREATE TABLE Noter(
    CodeMembre varchar(17) references Membre (CodeMembre),
    CodeRecette varchar(17) references Recette (CodeRecette),
    Date_notation date,
    Note double precision,
    Commentaire text
);

INSERT INTO Difficulte (CodeDifficulte, Libelle_difficulte) VALUES ('1', 'Facile'),
                                                                   ('2', 'Modérée'),
                                                                   ('3', 'Dificille');

INSERT INTO Groupe (CodeGroupe, Libelle_groupe) VALUES ('G05', 'Pâtisserie');

INSERT INTO Categorie (CodeCategorie, Libelle_categorie, CodeGroupe) VALUES ('C007', 'Gâteau-Cake', 'G05');

INSERT INTO Membre (CodeMembre, Civilite_membre, Nom_membre, Prenom_membre) VALUES ('MB00001', 'M', 'Ken', 'Bambou');

INSERT INTO Membre (CodeMembre, Civilite_membre, Nom_membre, Prenom_membre) VALUES ('MB00002', 'Mme', 'Ramarson', 'Harilanto'),
                                                                                   ('MB00003', 'M', 'Rakotonirina', 'Rado'),
                                                                                   ('MB00004', 'Mme', 'Razanamalala', 'NJara');

INSERT INTO Recette (CodeRecette, Titre_recette, Date_creation, CodeAuteur, CodeDifficulte, CodeCategorie) VALUES ('RCT00001', 'Tarte aux cerises', '2024-12-13', 'MB00001', '2', 'C007');

INSERT INTO Noter (CodeMembre, CodeRecette, Date_notation, Note, Commentaire) VALUES ('MB00002', 'RCT00001', '2024-12-14', 15, 'Tsara fa saingy tsy ampy siramamy'),
                                                                                     ('MB00003', 'RCT00001', '2024-12-14', 18, 'Hafa be ny tsirony misy anle cerises'),
                                                                                     ('MB00004', 'RCT00001', '2024-12-14', 14, 'Tsara be fa tsy ampy'),
                                                                                     ('MB00002', 'RCT00001', '2024-12-14', 17, 'Ao tsara ka');

INSERT INTO Membre (CodeMembre, Civilite_membre, Nom_membre, Prenom_membre) VALUES ('MB00005', 'Mme', 'Rakotonirina', 'Domoina'),
                                                                                   ('MB00006', 'Mme', 'Rakotonirina', 'Manda'),
                                                                                   ('MB00007', 'Mme', 'Rakotonirina', 'Fanilo');


INSERT INTO Groupe (CodeGroupe, Libelle_groupe) VALUES ('G01', 'Cuisinier'),
                                                       ('G02', 'Commis de cuisine'),
                                                       ('G03', 'Saucier'),
                                                       ('G04', 'Rôtisseur'),
                                                       ('G06', 'Charcutier-traiteur'),
                                                       ('G07', 'Chocolatier-Confiseur'),
                                                       ('G08', 'Boulanger');

INSERT INTO Categorie (CodeCategorie, Libelle_categorie, CodeGroupe) VALUES ('C006', 'Tarte', 'G05'),
                                                                            ('C005', 'Madelaine', 'G05'),
                                                                            ('C002', 'Brioche', 'G08'),
                                                                            ('C001', 'Pain de mie', 'G08'),
                                                                            ('C003', 'PLats', 'G01'),
                                                                            ('C004', 'Desserts', 'G01'),
                                                                            ('C008', 'Sauce Tomate', 'G03'),
                                                                            ('C009', 'Sauce Huitre', 'G03'),
                                                                            ('C010', 'Mortadelle', 'G06'),
                                                                            ('C011', 'Pate', 'G06'),
                                                                            ('C012', 'Jambon', 'G06'),
                                                                            ('C013', 'Salami', 'G06'),
                                                                            ('C014', 'Saucisson', 'G06');

--Mission 1 a/--
SELECT
avg(n.Note) as MoyenneNote
FROM Noter n
JOIN Recette r on r.CodeRecette = n.CodeRecette
JOIN Membre m on m.CodeMembre = r.CodeAuteur
WHERE r.Titre_recette = 'Tarte aux cerises' AND m.Civilite_membre = 'M' AND m.Nom_membre = 'Ken' AND m.Prenom_membre = 'Bambou';

--Mission 1 b/--
SELECT 
max(n.Note) as MeilleureNote
FROM Noter n
JOIN Recette r on r.CodeRecette = n.CodeRecette
WHERE r.Titre_recette = 'omelette norvégienne';

--Mission 1 c/ --
SELECT
CodeMembre,
Nom_membre,
Prenom_membre
FROM Membre
WHERE CodeMembre NOT IN (SELECT DISTINCT CodeMembre FROM Noter);

--Mission 1 d/ --
SELECT
g.CodeGroupe,
g.Libelle_groupe,
COALESCE(COUNT(c.CodeGroupe), 0) as Nombre_de_categorie
FROM Groupe g
LEFT JOIN Categorie c on c.CodeGroupe = g.CodeGroupe
GROUP BY g.CodeGroupe, g.Libelle_groupe;

/* Raha ohatra nareo ka mbola tsy nanao anzany oe inona ilay LEFT JOIN de ovay an'ito ny valiny */
SELECT
g.CodeGroupe,
g.Libelle_groupe,
COUNT(c.CodeGroupe) as Nombre_de_categorie
FROM Groupe g
JOIN Categorie c on c.CodeGroupe = g.CodeGroupe
GROUP BY g.CodeGroupe, g.Libelle_groupe;


-- e/ --

-- f/ --

-- g/ --

-- h/ --