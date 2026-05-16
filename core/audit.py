from datetime import datetime
from pathlib import Path

def write_audit_log(
    vault_path: str,
    project: str,
    actor: str,
    action: str,
    permission_level: int,
    status: str,
    notes: str = "",
) -> Path:
    vault = Path(vault_path)
    audit_file = vault / "AUDIT_LOG.md"

    if not vault.exists():
        raise FileNotFoundError(f"Vault not found: {vault}")

    if not audit_file.exists():
        audit_file.write_text(
            "# KAIROS Audit Log\n\n"
            "| Timestamp | Project | Actor | Action | Permission Level | Status | Notes |\n"
            "|---|---|---|---|---|---|---|\n",
            encoding="utf-8",
        )

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def safe(value: str) -> str:
        return str(value).replace("|", "-")

    line = (
        f"| {timestamp} | {safe(project)} | {safe(actor)} | {safe(action)} | "
        f"Level {permission_level} | {safe(status)} | {safe(notes)} |\n"
    )

    with audit_file.open("a", encoding="utf-8") as f:
        f.write(line)

    return audit_file
