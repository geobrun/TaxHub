"""Insert INPN taxonomie data

Revision ID: 22ada78bb4d2
Revises: 35c86c469aa1
Create Date: 2021-01-07 18:31:33.672304

"""
from alembic import op, context
import sqlalchemy as sa
import pkg_resources
from distutils.util import strtobool
from urllib.request import urlopen
import logging
from tempfile import TemporaryDirectory
from shutil import copyfileobj
from zipfile import ZipFile
from contextlib import ExitStack
import os, os.path


# revision identifiers, used by Alembic.
revision = '22ada78bb4d2'
down_revision = '35c86c469aa1'
branch_labels = None
depends_on = None


def upgrade():
    pass

taxhub_base_url = "https://geonature.fr/data/inpn/taxonomie/"

logger = logging.getLogger('alembic.runtime.migration')


def upgrade():
    refresh_materialized_views = False
    if strtobool(context.get_x_argument(as_dictionary=True).get('taxhub-inpn-data', "true")):
        refresh_materialized_views = True
        operations = pkg_resources.resource_string("apptax.migrations", "data/inpn_taxhub_bib.sql").decode('utf-8')
        op.execute(operations)
        taxhub_dir = context.get_x_argument(as_dictionary=True).get('taxhub-inpn-data-directory')
        with ExitStack() as stack:
            if not taxhub_dir:
                taxhub_dir = stack.enter_context(TemporaryDirectory())
            if not os.path.isdir(taxhub_dir):
                os.mkdir(taxhub_dir)
            for archive, extracted in [
                        ('TAXREF_INPN_v13.zip', 'TAXREF_INPN_v13'),
                        ('ESPECES_REGLEMENTEES_v11.zip', 'PROTECTION_ESPECES_11.csv'),
                        ('LR_FRANCE_20160000.zip', 'LR_FRANCE.csv'),
                        ('BDC_STATUTS_13.zip', 'BDC_STATUTS_13.csv'),
                    ]:
                if not os.path.exists(f"{taxhub_dir}/{extracted}"):
                    if not os.path.exists(f"{taxhub_dir}/{archive}"):
                        logger.info(f"Downloading {archive}…")
                        with urlopen(f"{taxhub_base_url}{archive}") as response, open(f"{taxhub_dir}/{archive}", 'wb') as zip_file:
                            copyfileobj(response, zip_file)
                    logger.info(f"Extracting {archive}…")
                    with ZipFile(f"{taxhub_dir}/{archive}") as z:
                        z.extractall(path=taxhub_dir)
            cursor = op.get_bind().connection.cursor()

            logger.info(f"Importing TAXREFv13…")
            with open(f'{taxhub_dir}/TAXREF_INPN_v13/TAXREFv13.txt') as f:
                cursor.copy_expert(f"""
                COPY taxonomie.import_taxref (regne, phylum, classe, ordre, famille, sous_famille, tribu, group1_inpn,
                       group2_inpn, cd_nom, cd_taxsup, cd_sup, cd_ref, rang, lb_nom,
                       lb_auteur, nom_complet, nom_complet_html, nom_valide, nom_vern,
                       nom_vern_eng, habitat, fr, gf, mar, gua, sm, sb, spm, may, epa,
                       reu, sa, ta, taaf, pf, nc, wf, cli, url)
                FROM STDIN WITH CSV HEADER DELIMITER E'\t'  encoding 'UTF-8'
                """, file=f)
            op.execute("""
            INSERT INTO taxonomie.taxref
            SELECT cd_nom, fr as id_statut, habitat::int as id_habitat, rang as  id_rang, regne, phylum, classe,
             ordre, famille,  sous_famille, tribu, cd_taxsup, cd_sup, cd_ref, lb_nom, substring(lb_auteur, 1, 250),
             nom_complet, nom_complet_html,nom_valide, substring(nom_vern,1,1000), nom_vern_eng, group1_inpn, group2_inpn, url
            FROM import_taxref;
            """)
            op.execute("TRUNCATE TABLE import_taxref")

            logger.info(f"Importing ESPECES REGLEMENTEES v11…")
            with open(f'{taxhub_dir}/PROTECTION_ESPECES_TYPES_11.csv') as f:
                cursor.copy_expert(f"""
                COPY taxonomie.taxref_protection_articles (
                cd_protection, article, intitule, arrete,
                url_inpn, cd_doc, url, date_arrete, type_protection
                )
                FROM  STDIN
                WITH  CSV HEADER;
                """, file=f)
            op.execute("""
            CREATE TABLE taxonomie.import_protection_especes (
                cd_nom int,
                cd_protection varchar(250),
                nom_cite text,
                syn_cite text,
                nom_francais_cite text,
                precisions varchar(500),
                cd_nom_cite int
            )
            """)
            with open(f'{taxhub_dir}/PROTECTION_ESPECES_11.csv') as f:
                cursor.copy_expert("COPY taxonomie.import_protection_especes FROM STDIN WITH CSV HEADER", file=f)
            op.execute("""
            INSERT INTO taxonomie.taxref_protection_especes
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
            """)
            op.execute("DROP TABLE taxonomie.import_protection_especes")

            logger.info(f"Importing LISTE ROUGE FRANCE 20160000…")
            with open(f"{taxhub_dir}/LR_FRANCE.csv") as f:
                cursor.copy_expert("""
                COPY taxonomie.taxref_liste_rouge_fr (ordre_statut,vide,cd_nom,cd_ref,nomcite,nom_scientifique,auteur,nom_vernaculaire,nom_commun,
                    rang,famille,endemisme,population,commentaire,id_categorie_france,criteres_france,liste_rouge,fiche_espece,tendance,
                        liste_rouge_source,annee_publication,categorie_lr_europe,categorie_lr_mondiale)
                FROM  STDIN
                WITH  CSV HEADER
                DELIMITER E'\;'  encoding 'UTF-8'
                """, file=f)

            logger.info(f"Importing BDC STATUS 13…")
            for table, csv_file, encoding in [
                        ('taxref_bdc_statut_type', 'BDC_STATUTS_TYPES_13.csv', 'UTF-8'),
                        ('taxref_bdc_statut', 'BDC_STATUTS_13.csv', 'ISO 8859-1'),
                    ]:
                with open(f"{taxhub_dir}/{csv_file}", encoding=encoding) as f:
                    cursor.copy_expert(f"COPY taxonomie.{table} FROM STDIN WITH CSV HEADER", file=f)
    sql_files = []
    if strtobool(context.get_x_argument(as_dictionary=True).get('atlas', "true")):
        sql_files += ['taxhubdata_atlas.sql']
    if strtobool(context.get_x_argument(as_dictionary=True).get('attribut-example', "false")):
        sql_files += ['taxhubdata_example.sql']
    if strtobool(context.get_x_argument(as_dictionary=True).get('taxons-example', "false")):
        sql_files += ['taxhubdata_taxons_example.sql']
    for sql_file in sql_files:
        refresh_materialized_views = True
        operations = pkg_resources.resource_string("apptax.migrations", f"data/{sql_file}").decode('utf-8')
        op.execute(operations) 
    if refresh_materialized_views:
        logger.info("Refresh materialized views…")
        operations = pkg_resources.resource_string("apptax.migrations", "data/refresh_materialized_view.sql").decode('utf-8')
        op.execute(operations)


def downgrade():
    tables = [  # FIXME to complete
    ]
    for table in tables:
        op.execute(f'TRUNCATE TABLE taxonomie.{table}')
