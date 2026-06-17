"""add_pending_attendance_status

Revision ID: 3ebc28938053
Revises: a71e95a49c0c
Create Date: 2026-06-14 23:27:15.335012

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "3ebc28938053"
down_revision: Union[str, Sequence[str], None] = "a71e95a49c0c"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.execute("ALTER TYPE attendancestatus ADD VALUE 'PENDING'")


def downgrade() -> None:
    """Downgrade schema."""
    # Create new type without PENDING
    op.execute(
        "CREATE TYPE attendancestatus_new AS ENUM ('PRESENT', 'ABSENT', 'LATE', 'JUSTIFIED')"
    )
    # Alter the column to use new type (casting via text column)
    op.execute(
        "ALTER TABLE attendance ALTER COLUMN status TYPE attendancestatus_new USING status::text::attendancestatus_new"
    )
    # Drop old type
    op.execute("DROP TYPE attendancestatus")
    # Rename new type to old name
    op.execute("ALTER TYPE attendancestatus_new RENAME TO attendancestatus")
