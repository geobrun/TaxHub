-------------------------------------------------------------
------------Insertion des données taxref	-------------
-------------------------------------------------------------

---import taxref--
TRUNCATE TABLE import_taxref;
COPY import_taxref (regne, phylum, classe, ordre, famille, sous_famille, tribu, group1_inpn,
       group2_inpn, cd_nom, cd_taxsup, cd_sup, cd_ref, rang, lb_nom,
       lb_auteur, nom_complet, nom_complet_html, nom_valide, nom_vern,
       nom_vern_eng, habitat, fr, gf, mar, gua, sm, sb, spm, may, epa,
       reu, sa, ta, taaf, pf, nc, wf, cli, url)
FROM  '/tmp/taxhub/TAXREF_INPN_v13/TAXREFv13.txt'
WITH  CSV HEADER
DELIMITER E'\t'  encoding 'UTF-8';

--insertion dans la table taxref
TRUNCATE TABLE taxref CASCADE;
INSERT INTO taxref
      SELECT cd_nom, fr as id_statut, habitat::int as id_habitat, rang as  id_rang, regne, phylum, classe,
             ordre, famille,  sous_famille, tribu, cd_taxsup, cd_sup, cd_ref, lb_nom, substring(lb_auteur, 1, 250),
             nom_complet, nom_complet_html,nom_valide, substring(nom_vern,1,1000), nom_vern_eng, group1_inpn, group2_inpn, url
        FROM import_taxref;


----PROTECTION

---import des statuts de protections
TRUNCATE TABLE taxref_protection_articles CASCADE;
COPY taxref_protection_articles (
cd_protection, article, intitule, arrete,
url_inpn, cd_doc, url, date_arrete, type_protection
)
FROM  '/tmp/taxhub/PROTECTION_ESPECES_TYPES_11.csv'
WITH  CSV HEADER;


---import des statuts de protections associés au taxon
CREATE TABLE import_protection_especes (
	cd_nom int,
	cd_protection varchar(250),
	nom_cite text,
	syn_cite text,
	nom_francais_cite text,


	precisions varchar(500),
	cd_nom_cite int


);

COPY import_protection_especes
FROM  '/tmp/taxhub/PROTECTION_ESPECES_11.csv'
WITH  CSV HEADER;

---import liste rouge--
TRUNCATE TABLE taxonomie.taxref_liste_rouge_fr;
COPY taxonomie.taxref_liste_rouge_fr (ordre_statut,vide,cd_nom,cd_ref,nomcite,nom_scientifique,auteur,nom_vernaculaire,nom_commun,
    rang,famille,endemisme,population,commentaire,id_categorie_france,criteres_france,liste_rouge,fiche_espece,tendance,
    liste_rouge_source,annee_publication,categorie_lr_europe,categorie_lr_mondiale)
FROM  '/tmp/taxhub/LR_FRANCE.csv'
WITH  CSV HEADER
DELIMITER E'\;'  encoding 'UTF-8';


TRUNCATE TABLE taxref_protection_especes;
INSERT INTO taxref_protection_especes
SELECT DISTINCT  p.*
FROM  (
  SELECT cd_nom , cd_protection , string_agg(DISTINCT nom_cite, ',') nom_cite,
    string_agg(DISTINCT syn_cite, ',')  syn_cite, string_agg(DISTINCT nom_francais_cite, ',')  nom_francais_cite,
    string_agg(DISTINCT precisions, ',')  precisions, cd_nom_cite
  FROM   import_protection_especes
  GROUP BY cd_nom , cd_protection , cd_nom_cite
) p
JOIN taxref t
USING(cd_nom) ;

DROP TABLE  import_protection_especes;


--- Nettoyage des statuts de protections non utilisés
DELETE FROM  taxref_protection_articles
WHERE cd_protection IN (
  SELECT cd_protection
  FROM taxref_protection_articles
  WHERE NOT cd_protection IN (SELECT DISTINCT cd_protection FROM  taxref_protection_especes)
);
-- Nettoyage de la table d'import temporaire de taxref
TRUNCATE TABLE import_taxref;


--- Activation des textes valides pour la structure
--      Par défaut activation de tous les textes nationaux et internationaux
--          Pour des considérations locales à faire au cas par cas !!!
--UPDATE  taxonomie.taxref_protection_articles SET concerne_mon_territoire = true
--WHERE cd_protection IN (
	--SELECT cd_protection
	--FROM  taxonomie.taxref_protection_articles
	--WHERE type_protection = 'Protection'
--);


------------------------------------------------------
------------------------------------------------------
--- INSERTION DES NOUVEAUX STATUTS BDC Statut
------------------------------------------------------
------------------------------------------------------

COPY taxonomie.taxref_bdc_statut_type
FROM  '/tmp/taxhub/BDC_STATUTS_TYPES_13.csv'
WITH  CSV HEADER;


COPY taxonomie.taxref_bdc_statut
FROM  '/tmp/taxhub/BDC_STATUTS_13.csv'
WITH  CSV HEADER
  ENCODING 'ISO 8859-1';
