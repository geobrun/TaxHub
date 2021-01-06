"""Register taxhub in usershub applications

Revision ID: c59c225e1c42
Revises: 35c86c469aa1
Create Date: 2021-01-06 17:15:57.130550

"""
from alembic import op
import sqlalchemy as sa
import pkg_resources


# revision identifiers, used by Alembic.
revision = 'c59c225e1c42'
down_revision = '22ada78bb4d2'
branch_labels = None
depends_on = (
    'utilisateurs',
)


def upgrade():
    operations = pkg_resources.resource_string("apptax.migrations", "data/adds_for_usershub.sql").decode('utf-8')
    op.execute(operations)


def downgrade():
    op.execute("DELETE FROM utilisateurs.cor_role_app_profil WHERE id_application IN (SELECT id_application FROM utilisateurs.t_applications WHERE code_application = 'TH')")
    op.execute("DELETE FROM utilisateurs.cor_profil_for_app WHERE id_application IN (SELECT id_application FROM utilisateurs.t_applications WHERE code_application = 'TH')")
    op.execute("DELETE FROM utilisateurs.t_applications WHERE code_application = 'TH'")
