"""Create taxonomie schema

Revision ID: 35c86c469aa1
Revises: 
Create Date: 2020-12-31 16:31:45.914263

"""
from alembic import op, context
import sqlalchemy as sa
import pkg_resources
from distutils.util import strtobool
from urllib.request import urlopen


# revision identifiers, used by Alembic.
revision = '35c86c469aa1'
down_revision = 'a23b307efa47'
branch_labels = None
depends_on = None


def upgrade():
    for sql_file in ['taxhub.sql', 'taxhubdata.sql', 'materialized_views.sql']:
        operations = pkg_resources.resource_string("apptax.migrations", f"data/{sql_file}").decode('utf-8')
        op.execute(operations)


def downgrade():
    op.execute('DROP SCHEMA taxonomie CASCADE')
