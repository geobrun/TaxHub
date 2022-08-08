import pytest

from apptax.database import db
from apptax.taxonomie.models import BibListes, BibNoms


@pytest.fixture
def noms_example():
    liste = BibListes.query.filter_by(code_liste="100").one()
    with db.session.begin_nested():
        for cd_nom, cd_ref, nom_francais, comments in [
            (67111, 67111, "Ablette", None),
            (60612, 60612, "Lynx boréal", None),
            (351, 351, "Grenouille rousse", None),
            (8326, 8326, "Cicindèle hybride", None),
            (11165, 11165, "Coccinelle à 7 points", None),
            (18437, 18437, "Ecrevisse à pieds blancs", None),
            (81065, 81065, "Alchémille rampante", None),
            (95186, 95186, "Inule fétide", None),
            (713776, 209902, "-", "un synonyme"),
        ]:
            nom = BibNoms(
                cd_nom=cd_nom, cd_ref=cd_ref, nom_francais=nom_francais, comments=comments
            )
            db.session.add(nom)
            liste.noms.append(nom)
