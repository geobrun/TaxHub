--
-- Insertion des dictionnaires taxref
--

SET search_path TO taxonomie, pg_catalog, public;
--
-- TOC entry 3270 (class 0 OID 17759)
-- Dependencies: 242
-- Data for Name: bib_taxref_habitats; Type: TABLE DATA; Schema: taxonomie; Owner: geonatuser
--

INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (1, 'Marin', 'Espèces vivant uniquement en milieu marin');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (2, 'Eau douce', 'Espèces vivant uniquement en milieu d''eau douce');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (3, 'Terrestre', 'Espèces vivant uniquement en milieu terrestre');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (5, 'Marin et Terrestre', 'Espèces effectuant une partie de leur cycle de vie en eau douce et l''autre partie en mer (espèces diadromes, amphidromes, anadromes ou catadromes)');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (6, 'Eau Saumâtre', 'Cas des pinnipèdes, des tortues et des oiseaux marins (par exemple)');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (7, 'Continental (Terrestre et/ou Eau douce)', 'Espèces vivant exclusivement en eau saumâtre');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (0, 'Non renseigné', null);
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (4, 'Marin et Eau douce', 'Espèces continentales (non marines) dont on ne sait pas si elles sont terrestres et/ou d''eau douce (taxons provenant de Fauna Europaea)');
INSERT INTO bib_taxref_habitats (id_habitat, nom_habitat, desc_habitat) VALUES (8, 'Continental (Terrestre et Eau douce)', 'Espèces terrestres effectuant une partie de leur cycle en eau douce (odonates par exemple), ou fortement liées au milieu aquatique (loutre par exemple)');


--
-- TOC entry 3271 (class 0 OID 17762)
-- Dependencies: 243
-- Data for Name: bib_taxref_rangs; Type: TABLE DATA; Schema: taxonomie; Owner: geonatuser
--

INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('Dumm', 'Domaine', 1);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SPRG', 'Super-Règne', 2);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('KD  ', 'Règne', 3);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SSRG', 'Sous-Règne', 4);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('IFRG', 'Infra-Règne', 5);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('PH  ', 'Embranchement', 6);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SBPH', 'Sous-Phylum', 7);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('IFPH', 'Infra-Phylum', 8);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('DV  ', 'Division', 9);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SBDV', 'Sous-division', 10);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SPCL', 'Super-Classe', 11);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('CLAD', 'Cladus', 12);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('CL  ', 'Classe', 13);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SBCL', 'Sous-Classe', 14);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('IFCL', 'Infra-classe', 15);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('LEG ', 'Legio', 16);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SPOR', 'Super-Ordre', 17);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('COH ', 'Cohorte', 18);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('OR  ', 'Ordre', 19);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SBOR', 'Sous-Ordre', 20);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('IFOR', 'Infra-Ordre', 21);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SPFM', 'Super-Famille', 22);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('FM  ', 'Famille', 23);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SBFM', 'Sous-Famille', 24);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('PVCL', 'Parv-Classe', 25);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('TR  ', 'Tribu', 26);

INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SSTR', 'Sous-Tribu', 27);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('GN  ', 'Genre', 28);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SSGN', 'Sous-Genre', 29);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SC  ', 'Section', 30);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SBSC', 'Sous-Section', 31);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SER', 'Série', 32);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SSER', 'Sous-Série', 33);

INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('AGES', 'Agrégat', 34);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('ES  ', 'Espèce', 35);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SMES', 'Semi-espèce', 36);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('MES ', 'Micro-Espèce',37);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SSES', 'Sous-espèce', 38);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('NAT ', 'Natio', 39);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('VAR ', 'Variété', 40);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SVAR ', 'Sous-Variété', 41);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('FO  ', 'Forme', 42);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SSFO', 'Sous-Forme', 43);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('FOES', 'Forma species', 44);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('LIN ', 'Linea', 45);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('CLO ', 'Clône', 46);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('RACE', 'Race', 47);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('CAR ', 'Cultivar', 48);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('MO  ', 'Morpha', 49);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('AB  ', 'Abberatio',50);
--n'existe plus dans taxref V9
INSERT INTO bib_taxref_rangs (id_rang, nom_rang) VALUES ('CVAR', 'Convariété');
INSERT INTO bib_taxref_rangs (id_rang, nom_rang) VALUES ('HYB ', 'Hybride');
--non documenté dans la doc taxref
INSERT INTO bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SPTR', 'Supra-Tribu', 25);
INSERT INTO bib_taxref_rangs (id_rang, nom_rang) VALUES ('SCO ', '?');
INSERT INTO bib_taxref_rangs (id_rang, nom_rang) VALUES ('PVOR', '?');

INSERT INTO bib_taxref_rangs (id_rang, nom_rang) VALUES ('SSCO', '?');




--
-- TOC entry 3272 (class 0 OID 17765)
-- Dependencies: 244
-- Data for Name: bib_taxref_statuts; Type: TABLE DATA; Schema: taxonomie; Owner: geonatuser
--

INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('A', 'Absente');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('B', 'Accidentelle / Visiteuse');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('C', 'Cryptogène');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('D', 'Douteux');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('E', 'Endemique');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('F', 'Trouvé en fouille');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('I', 'Introduite');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('J', 'Introduite envahissante');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('M', 'Domestique / Introduite non établie');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('P', 'Présente');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('S', 'Subendémique');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('W', 'Disparue');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('X', 'Eteinte');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('Y', 'Introduite éteinte');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('Z', 'Endémique éteinte');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('0', 'Non renseigné');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES ('Q', 'Mentionné par erreur');
INSERT INTO bib_taxref_statuts (id_statut, nom_statut) VALUES (' ', 'Non précisé');

--
--
-- Data for Name: bib_taxref_categories_lr; Type: TABLE DATA; Schema: taxonomie; Owner: -
--

INSERT INTO bib_taxref_categories_lr VALUES ('EX', 'Disparues', 'Eteinte à l''état sauvage', 'Eteinte au niveau mondial');
INSERT INTO bib_taxref_categories_lr VALUES ('EW', 'Disparues', 'Eteinte à l''état sauvage', 'Eteinte à l''état sauvage');
INSERT INTO bib_taxref_categories_lr VALUES ('RE', 'Disparues', 'Disparue au niveau régional', 'Disparue au niveau régional');
INSERT INTO bib_taxref_categories_lr VALUES ('CR', 'Menacées de disparition', 'En danger critique', 'En danger critique');
INSERT INTO bib_taxref_categories_lr VALUES ('EN', 'Menacées de disparition', 'En danger', 'En danger');
INSERT INTO bib_taxref_categories_lr VALUES ('VU', 'Menacées de disparition', 'Vulnérable', 'Vulnérable');
INSERT INTO bib_taxref_categories_lr VALUES ('NT', 'Autre', 'Quasi menacée', 'Espèce proche du seuil des espèces menacées ou qui pourrait être menacée si des mesures de conservation spécifiques n''étaient pas prises');
INSERT INTO bib_taxref_categories_lr VALUES ('LC', 'Autre', 'Préoccupation mineure', 'Espèce pour laquelle le risque de disparition est faible');
INSERT INTO bib_taxref_categories_lr VALUES ('DD', 'Autre', 'Données insuffisantes', 'Espèce pour laquelle l''évaluation n''a pas pu être réalisée faute de données suffisantes');
INSERT INTO bib_taxref_categories_lr VALUES ('NA', 'Autre', 'Non applicable', 'Espèce non soumise à évaluation car (a) introduite dans la période récente ou (b) présente en métropole de manière occasionnelle ou marginale');
INSERT INTO bib_taxref_categories_lr VALUES ('NE', 'Autre', 'Non évaluée', 'Espèce non encore confrontée aux critères de la Liste rouge');
