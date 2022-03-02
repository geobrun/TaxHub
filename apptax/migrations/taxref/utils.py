import os
import csv
import importlib
from pathlib import Path
from zipfile import ZipFile
from sqlalchemy import text
from sqlalchemy.exc import ProgrammingError


from apptax.database import db
from . import logger
from .queries import (
    EXPORT_QUERIES_MISSING_CD_NOMS_IN_BIB_NOMS,
    EXPORT_QUERIES_MISSING_CD_NOM_GN2_SYNTHESE,
    EXPORT_QUERIES_MISSING_CD_NOMS_IN_DB,
    EXPORT_QUERIES_MODIFICATION_NB,
    EXPORT_QUERIES_MODIFICATION_LIST,
    EXPORT_QUERIES_CONFLICTS,
)


def analyse_taxref_changes(without_substitution=True):
    """
    Analyse des répercussions de changement de taxref

    3 étapes :
        - Detection des cd_noms manquants
        - Création d'une copie de travail de bib_noms
        - Analyse des modifications taxonomique (split, merge, ...) et
            de leur répercussion sur les attributs et medias de taxhub
    """
    # test if deleted cd_nom can be correct without manual intervention
    if test_missing_cd_nom(without_substitution):
        logger.error("Some cd_nom will disappear without substitute. You can't continue migration. Analyse exports files")
        # TODO ??? Force exit or not ??? https://github.com/PnX-SI/TaxHub/issues/306
        exit()

    # Test missing cd_nom
    create_copy_bib_noms()

    # Change detection and repport
    nb_of_conflict = detect_changes()
    # si conflit > 1 exit()
    if nb_of_conflict > 1:
        logger.error(f"There is {nb_of_conflict} unresolved conflits. You can't continue migration")
        exit()


def create_copy_bib_noms():
    """
    Création d'une table copie de bib_noms
    """
    logger.info("Create working copy of bib_noms…")

    # Préparation création de table temporaire permettant d'importer taxref
    query = text(
        importlib.resources.read_text(
            "apptax.migrations.data.migrate_taxref_version", "0.1_generate_tmp_bib_noms_copy.sql"
        )
    )
    db.session.execute(query)
    db.session.commit()


def detect_changes(script_predetection=None, script_postdetection=None):
    """Detection des changements et de leur implication
        sur bib_noms, les attributs et les médias

    :return: Nombre de conflit detecté
    :rtype: int
    """
    query = text(
        importlib.resources.read_text(
            "apptax.migrations.data.migrate_taxref_version", "1.1_taxref_changes_detections.sql"
        )
    )
    db.session.execute(query)

    if script_predetection:
        logger.info(f"Run script {script_predetection}")
        query = text(Path(script_predetection).read_text())
        try:
            db.session.execute(query)
        except ProgrammingError as e:
            logger.error(f"Error un sql script {script_predetection} - {str(e)}")
            return
    query = text(
        importlib.resources.read_text(
            "apptax.migrations.data.migrate_taxref_version",
            "1.2_taxref_changes_detections_cas_actions.sql",
        )
    )
    db.session.execute(query)

    if script_postdetection:
        logger.info(f"Run script {script_postdetection}")
        query = text(Path(script_postdetection).read_text())
        try:
            db.session.execute(query)
        except ProgrammingError as e:
            logger.error(f"Error un sql script {script_postdetection} - {str(e)}")
            return

    db.session.commit()

    # Export des changements
    results = db.session.execute(text(EXPORT_QUERIES_MODIFICATION_NB))
    export_as_csv(file_name="nb_changements.csv", columns=results.keys(), data=results.fetchall())
    results = db.session.execute(text(EXPORT_QUERIES_MODIFICATION_LIST))
    export_as_csv(
        file_name="liste_changements.csv", columns=results.keys(), data=results.fetchall()
    )

    logger.info(f"List of taxref changes done in tmp")

    results = db.session.execute(text(EXPORT_QUERIES_CONFLICTS))
    nb_of_conflict = results.fetchone()["count"]
    return nb_of_conflict


def save_data(version, keep_taxref, keep_bdc):
    """Sauvegarde des données de l'ancienne version de taxref

    :param version: numéro de version de taxref
    :type version: int
    :param keep_taxref: Indique si l'on souhaite concerver l'ancienne version du referentiel taxref
    :type keep_taxref: boolean
    :param keep_bdc:  Indique si l'on souhaite concerver l'ancienne version du referentiel bdc_status
    :type keep_bdc: boolean
    """

    if keep_taxref:
        db.session.execute(
            text(
                f"""
            DROP TABLE IF EXISTS taxonomie.taxref_v{str(version)};
            CREATE TABLE taxonomie.taxref_v{str(version)} AS
            SELECT * FROM taxonomie.taxref;
        """
            )
        )

    if keep_bdc:
        db.session.execute(
            text(
                f"""
            DROP TABLE IF EXISTS taxonomie.bdc_statut_v{str(version)};
            CREATE TABLE taxonomie.bdc_statut_v{str(version)} AS
            SELECT * FROM taxonomie.bdc_statut;
        """
            )
        )
        db.session.execute(
            text(
                f"""
            DROP TABLE IF EXISTS taxonomie.bdc_statut_type_v{str(version)};
            CREATE TABLE taxonomie.bdc_statut_type_v{str(version)} AS
            SELECT * FROM taxonomie.bdc_statut_type;
        """
            )
        )


def missing_cd_nom_query(query_name, export_file_name, without_substitution=True):
    results = db.session.execute(text(query_name))
    data = results.fetchall()
    if len(data) > 0:
        logger.warning(
            f"Some cd_nom referencing in data where missing from taxref v15 -> see file {export_file_name}"
        )
        export_as_csv(file_name=export_file_name, columns=results.keys(), data=data)
    # Test cd_nom without cd_nom_remplacement
    if without_substitution :
        return test_cd_nom_without_sustitute(data)
    else :
        return len(data) > 0


def test_cd_nom_without_sustitute(data, key="cd_nom_remplacement"):
    for d in data:
        # Si la requete ne comporte pas le champ cd_nom_remplacement
        if not "cd_nom_remplacement" in d:
            return False
        if not d["cd_nom_remplacement"]:
            return True
    return False


def test_missing_cd_nom(without_substitution=True):
    # test cd_nom disparus
    missing_cd_nom_bib_noms = missing_cd_nom_query(
        query_name=EXPORT_QUERIES_MISSING_CD_NOMS_IN_BIB_NOMS,
        export_file_name="missing_cd_nom_into_bib_nom.csv",
        without_substitution=True # Missing cd_nom with substitue is manage by script
    )

    # TODO => Delete redondonance avec EXPORT_QUERIES_MISSING_CD_NOMS_IN_DB
    # missing_cd_nom_gn2 = missing_cd_nom_query(
    #     query_name=EXPORT_QUERIES_MISSING_CD_NOM_GN2_SYNTHESE,
    #     export_file_name="missing_cd_nom_into_gn_synthese.csv",
    #     without_substitution=without_substitution
    # )
    missing_cd_nom_gn2 = missing_cd_nom_query(
        query_name=EXPORT_QUERIES_MISSING_CD_NOMS_IN_DB,
        export_file_name="missing_cd_nom_into_geonature.csv",
        without_substitution=without_substitution
    )
    return missing_cd_nom_bib_noms + missing_cd_nom_gn2


def copy_from_csv(
    f,
    engine,
    table_name,
    schema_name="taxonomie",
    header=True,
    encoding=None,
    delimiter=None,
    dest_cols="",
):
    try:

        options = ["FORMAT CSV"]
        if header:
            options.append("HEADER")
        if encoding:
            options.append(f"ENCODING '{encoding}'")
        if delimiter:
            options.append(f"DELIMITER E'{delimiter}'")
        options = ", ".join(options)

        conn = engine.raw_connection()
        cursor = conn.cursor()
        cursor.copy_expert(
            f"""
            COPY {schema_name}.{table_name}{dest_cols}
            FROM STDIN WITH ({options})
        """,
            f,
        )

        conn.commit()
        cursor.close()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def export_as_csv(file_name, columns, data, separator=","):
    export_dir = "tmp"
    if not os.path.exists(export_dir):
        os.mkdir(export_dir)

    with open(f"{export_dir}/{file_name}", "w") as f:
        writer = csv.writer(f)
        writer.writerow(columns)
        writer.writerows(data)
