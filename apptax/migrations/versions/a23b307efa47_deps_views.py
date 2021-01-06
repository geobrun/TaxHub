"""Create generic function to handle deps views

Revision ID: a23b307efa47
Revises: 35c86c469aa1
Create Date: 2021-01-06 16:09:46.147698

"""
from alembic import op
import sqlalchemy as sa
import pkg_resources


# revision identifiers, used by Alembic.
revision = 'a23b307efa47'
down_revision = None
branch_labels = ('taxonomie',)
depends_on = None


def upgrade():
    operations = pkg_resources.resource_string("apptax.migrations",
                    "data/generic_drop_and_restore_deps_views.sql").decode('utf-8')
    op.execute(operations)


def downgrade():
    op.execute('DROP FUNCTION public.deps_restore_dependencies')
    op.execute('DROP FUNCTION public.deps_save_and_drop_dependencies')
    op.execute('DROP TABLE public.deps_saved_ddl')
