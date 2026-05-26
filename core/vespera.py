import sys
from pathlib import Path as _Path
sys.path.insert(0, str(_Path(__file__).resolve().parent))

from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from pathlib import Path
import argparse
from datetime import datetime

from router import route_task
from audit import write_audit_log
from paths import default_vault_path, default_asset_path, repo_root
from task_intake import log_task

console = Console()

# ====================== 명령어 함수 ======================

def cmd_healthcheck(args):
    root = repo_root()
    vault = Path(args.vault) if args.vault else default_vault_path()
    assets = Path(args.assets) if args.assets else default_asset_path()

    checks = [
        ("Repo README", root / "README.md", True),
        ("Config folder", root / "config", True),
        ("Docs folder", root / "docs", True),
        ("Scripts folder", root / "scripts", True),
        ("Core folder", root / "core", True),
        ("Obsidian Vault", vault, False),
        ("Asset Library", assets, False),
        ("Asset Pending Review", assets / "00_Inbox" / "Pending_Review", False),
    ]

    ok = warn = fail = 0

    console.print(Panel.fit("[bold cyan]VESPERA Core Healthcheck[/bold cyan]", border_style="blue"))
    console.print()

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Status", style="bold", width=8)
    table.add_column("Item", width=28)
    table.add_column("Path")

    for label, path, required in checks:
        if path.exists():
            table.add_row("[green]OK[/green]", label, str(path))
            ok += 1
        else:
            if required:
                table.add_row("[red]FAIL[/red]", label, str(path))
                fail += 1
            else:
                table.add_row("[yellow]WARN[/yellow]", label, str(path))
                warn += 1

    console.print(table)
    console.print()

    console.print("[bold]Summary[/bold]")
    console.print(f"  [green]OK   :[/green] {ok}")
    console.print(f"  [yellow]WARN :[/yellow] {warn}")
    console.print(f"  [red]FAIL :[/red] {fail}")
    console.print()

    if fail > 0:
        console.print("[red bold][!] Some required items are missing.[/red bold]")
    elif warn > 0:
        console.print("[yellow][!] Some optional items are missing.[/yellow]")
    else:
        console.print("[green bold][OK] All checks passed.[/green bold]")

    return 1 if fail else 0


def cmd_route(args):
    result = route_task(args.task)
    console.print(Panel.fit("[bold cyan]VESPERA Core Router[/bold cyan]", border_style="blue"))
    console.print()

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Field", style="dim", width=18)
    table.add_column("Value")
    table.add_row("Task", args.task)
    table.add_row("Route Type", result.route_type)
    table.add_row("Primary", result.primary)
    table.add_row("Secondary", result.secondary)
    table.add_row("Reviewer", result.reviewer)
    table.add_row("Permission Level", f"Level {result.permission_level}")

    console.print(table)
    console.print()
    console.print("[bold]Suggested Prompt:[/bold]")
    console.print(result.suggested_prompt)
    console.print()

    if result.permission_level >= 2:
        console.print("[red bold][!] Approval Required[/red bold]")
    return 0


def cmd_log_task(args):
    vault = args.vault or str(default_vault_path())
    result = log_task(vault_path=vault, task=args.task, project=args.project)
    route = result["route"]

    console.print(Panel.fit("[bold cyan]VESPERA Core Task Intake[/bold cyan]", border_style="blue"))
    console.print(f"[green][OK][/green] Task note created -> {result['note_file']}")
    console.print()

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Field", style="dim", width=18)
    table.add_column("Value")
    table.add_row("Route Type", route.route_type)
    table.add_row("Primary", route.primary)
    table.add_row("Secondary", route.secondary)
    table.add_row("Reviewer", route.reviewer)
    table.add_row("Permission Level", f"Level {route.permission_level}")

    console.print(table)
    console.print()

    if result["approval_required"]:
        console.print("[red bold][APPROVAL REQUIRED][/red bold]")

    console.print("[dim]No external AI tool was called.[/dim]")
    return 0


def cmd_audit(args):
    vault = args.vault or str(default_vault_path())
    audit_file = write_audit_log(
        vault_path=vault, project=args.project, actor=args.actor,
        action=args.action, permission_level=args.permission_level,
        status=args.status, notes=args.notes
    )

    console.print(Panel.fit("[bold cyan]VESPERA Core Audit[/bold cyan]", border_style="blue"))
    console.print(f"[green][OK][/green] Audit entry written -> {audit_file}")
    return 0


def cmd_doctor(args):
    import importlib.util

    root = repo_root()

    console.print(Panel.fit("[bold cyan]VESPERA Doctor[/bold cyan] [dim]— Full System Diagnostics[/dim]", border_style="blue"))
    console.print()

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Status", style="bold", width=8)
    table.add_column("Category", width=16)
    table.add_column("Item", width=30)
    table.add_column("Detail")

    ok = warn = fail = 0

    def add_ok(category, item, detail=""):
        nonlocal ok
        table.add_row("[green]OK[/green]", category, item, detail)
        ok += 1

    def add_warn(category, item, detail=""):
        nonlocal warn
        table.add_row("[yellow]WARN[/yellow]", category, item, detail)
        warn += 1

    def add_fail(category, item, detail=""):
        nonlocal fail
        table.add_row("[red]FAIL[/red]", category, item, detail)
        fail += 1

    # 1. Config 파일 개별 존재 여부 (healthcheck는 config 폴더만 체크)
    for cf in ["agents.yaml", "permission_matrix.yaml", "routing_rules.yaml", "storage.yaml"]:
        p = root / "config" / cf
        if p.exists():
            add_ok("Config", cf, "Found")
        else:
            add_fail("Config", cf, f"Missing: config/{cf}")

    # Vault / Asset Library 존재 여부
    vault = default_vault_path()
    assets = default_asset_path()
    if vault.exists():
        add_ok("Paths", "Obsidian Vault", str(vault))
    else:
        add_warn("Paths", "Obsidian Vault", f"Not found — run 'vespera init'")

    if assets.exists():
        add_ok("Paths", "Asset Library", str(assets))
    else:
        add_warn("Paths", "Asset Library", f"Not found — run 'vespera init'")

    # 2. Python 패키지 설치 여부
    pkg_checks = [("rich", "rich"), ("pyyaml", "yaml")]
    for display_name, import_name in pkg_checks:
        if importlib.util.find_spec(import_name) is not None:
            add_ok("Packages", display_name, "Installed")
        else:
            add_fail("Packages", display_name, f"pip install {display_name}")

    # 3. .env 파일 존재 여부 (내용 노출 금지)
    env_path = root / ".env"
    if env_path.exists():
        add_ok("Environment", ".env", "Found (contents hidden)")
    else:
        add_warn("Environment", ".env", "Not found (optional)")

    # 4. _fix_*.py 임시 파일 잔재 여부
    fix_files = list(root.rglob("_fix_*.py"))
    if fix_files:
        for f in fix_files:
            add_warn("Cleanup", f.name, f"Temp file: {f.relative_to(root)}")
    else:
        add_ok("Cleanup", "_fix_*.py files", "None found")

    # 5. core/__pycache__ 오염 여부
    pycache = root / "core" / "__pycache__"
    if pycache.exists():
        pyc_count = len(list(pycache.glob("*.pyc")))
        add_warn("Cache", "core/__pycache__", f"{pyc_count} .pyc file(s) present")
    else:
        add_ok("Cache", "core/__pycache__", "Clean")

    console.print(table)
    console.print()
    console.print("[bold]Summary[/bold]")
    console.print(f"  [green]OK   :[/green] {ok}")
    console.print(f"  [yellow]WARN :[/yellow] {warn}")
    console.print(f"  [red]FAIL :[/red] {fail}")
    console.print()

    if fail > 0:
        console.print("[red bold][!] Critical items missing. Check FAIL rows above.[/red bold]")
    elif warn > 0:
        console.print("[yellow][!] Some items need attention. Check WARN rows above.[/yellow]")
    else:
        console.print("[green bold][OK] All checks passed. VESPERA is healthy.[/green bold]")

    return 1 if fail else 0


def cmd_init(args):
    console.print(Panel.fit("[bold green]VESPERA Init[/bold green] [dim]— Environment Setup[/dim]", border_style="green"))
    console.print("[yellow]Creating necessary directories...[/yellow]")

    vault_path = default_vault_path()
    vault_path.mkdir(parents=True, exist_ok=True)
    console.print(f"[green]✓ Vault created at {vault_path}")

    asset_path = default_asset_path()
    asset_path.mkdir(parents=True, exist_ok=True)
    (asset_path / "00_Inbox" / "Pending_Review").mkdir(parents=True, exist_ok=True)
    console.print(f"[green]✓ Asset Library created at {asset_path}")

    console.print()
    console.print("[green bold]VESPERA initialization completed successfully![/green bold]")
    return 0


def cmd_projects(args):
    console.print(Panel.fit("[bold cyan]VESPERA Projects[/bold cyan]", border_style="blue"))
    console.print()

    vault = default_vault_path()
    projects_dir = vault / "01_Projects"

    if not projects_dir.exists():
        console.print("[yellow]Projects directory not found yet.[/yellow]")
        return 0

    projects = [p for p in projects_dir.iterdir() if p.is_dir() and not p.name.startswith('.')]

    if not projects:
        console.print("[dim]No projects found yet.[/dim]")
        return 0

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Project Name")
    table.add_column("Last Modified", style="dim")
    table.add_column("Status", style="green")

    for project in sorted(projects, key=lambda p: p.stat().st_mtime, reverse=True):
        last_modified = datetime.fromtimestamp(project.stat().st_mtime).strftime("%Y-%m-%d")
        table.add_row(project.name, last_modified, "[green]Active[/green]")

    console.print(table)
    console.print(f"[dim]{len(projects)} project(s) found.[/dim]")
    return 0


def cmd_assets(args):
    console.print(Panel.fit("[bold cyan]VESPERA Assets[/bold cyan]", border_style="blue"))
    console.print()

    asset_path = default_asset_path()

    if not asset_path.exists():
        console.print("[yellow]Asset Library not found.[/yellow]")
        console.print("Run [bold]vespera init[/bold] first.")
        return 0

    pending = asset_path / "00_Inbox" / "Pending_Review"
    pending_count = len(list(pending.glob("*"))) if pending.exists() else 0

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Category")
    table.add_column("Count", justify="right")
    table.add_column("Status")

    table.add_row("Total Assets", "0", "[green]Ready[/green]")
    table.add_row("Pending Review", str(pending_count), "[yellow]Needs Review[/yellow]" if pending_count > 0 else "[green]Clean[/green]")

    console.print(table)
    console.print()

    if pending_count > 0:
        console.print(f"[yellow]→ {pending_count} assets need review.[/yellow]")
    else:
        console.print("[green]All assets are organized.[/green]")

    return 0


def cmd_config(args):
    console.print(Panel.fit("[bold cyan]VESPERA Config[/bold cyan]", border_style="blue"))
    console.print("Configuration files are located in ./config/")
    console.print("• agents.yaml")
    console.print("• permission_matrix.yaml")
    console.print("• routing_rules.yaml")
    console.print("• storage.yaml")
    return 0


def cmd_backup(args):
    import zipfile
    from storage import load_storage_config, get_vault_path, get_backup_path, get_asset_path

    console.print(Panel.fit('[bold cyan]VESPERA Backup[/bold cyan]', border_style='blue'))
    console.print()

    root = repo_root()
    config = load_storage_config(root)
    vault = get_vault_path(config)
    backup_dir = get_backup_path(config)
    asset_lib = get_asset_path(config)

    from datetime import datetime as _dt
    timestamp = _dt.now().strftime('%Y%m%d_%H%M%S')
    zip_name = f'VESPERA_backup_{timestamp}.zip'
    zip_path = backup_dir / zip_name
    backup_dir.mkdir(parents=True, exist_ok=True)

    VAULT_EXTS = {'.md', '.yaml', '.yml', '.json', '.txt', '.css'}
    SKIP_DIRS = {'.obsidian', '__pycache__', '.git'}
    SKIP_FILES = {'workspace.json', 'workspace-mobile.json'}
    vault_count = config_count = meta_count = 0

    table = Table(show_header=True, header_style='bold magenta')
    table.add_column('Source', style='dim')
    table.add_column('Status')

    try:
        with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
            if vault.exists():
                for f in vault.rglob('*'):
                    if any(s in f.parts for s in SKIP_DIRS): continue
                    if f.name in SKIP_FILES: continue
                    if f.is_file() and f.suffix in VAULT_EXTS:
                        zf.write(f, Path('Vault') / f.relative_to(vault))
                        vault_count += 1
                table.add_row(f'Vault ({vault.name})', f'[green]{vault_count} files[/green]')
            else:
                table.add_row('Vault', '[yellow]Not found[/yellow]')

            cfg_dir = root / 'config'
            if cfg_dir.exists():
                for f in cfg_dir.rglob('*'):
                    if f.is_file():
                        zf.write(f, Path('config') / f.relative_to(cfg_dir))
                        config_count += 1
                table.add_row('config/', f'[green]{config_count} files[/green]')

            meta_dir = asset_lib / '90_Metadata'
            if meta_dir.exists():
                for f in meta_dir.rglob('*'):
                    if f.is_file():
                        zf.write(f, Path('Asset_Metadata') / f.relative_to(meta_dir))
                        meta_count += 1
                table.add_row('Asset 90_Metadata', f'[green]{meta_count} files[/green]')
            else:
                table.add_row('Asset 90_Metadata', '[dim]Empty (OK)[/dim]')

        size_kb = round(zip_path.stat().st_size / 1024, 1)

        from storage import get_max_backups
        max_keep = get_max_backups(config)
        existing = sorted(backup_dir.glob("VESPERA_backup_*.zip"))
        to_delete = existing[:-max_keep] if len(existing) > max_keep else []
        for old in to_delete:
            old.unlink()

        console.print(table)
        console.print()
        console.print('[green bold][OK] Backup complete[/green bold]')
        console.print(f'    File : [cyan]{zip_path}[/cyan]')
        console.print(f'    Size : {size_kb} KB')
        console.print(f'    Items: Vault {vault_count} + config {config_count} + metadata {meta_count}')
        console.print(f'    Keep : latest {max_keep} backups (deleted {len(to_delete)} old)')

    except Exception as e:
        console.print(f'[red][FAIL] Backup failed: {e}[/red]')
        return 1

    return 0


def _parse_md_table(text: str):
    rows = []
    for line in text.splitlines():
        line = line.strip()
        if line.startswith('|') and line.endswith('|'):
            cells = [c.strip() for c in line[1:-1].split('|')]
            if any('---' in c for c in cells):
                continue
            rows.append(cells)
    return rows[1:] if rows else []


def cmd_status(args):
    from storage import load_storage_config, get_backup_path
    import re

    root = repo_root()
    vault = default_vault_path()
    assets = default_asset_path()
    config = load_storage_config(root)
    backup_dir = get_backup_path(config)
    today = datetime.now().strftime("%Y%m%d")

    console.print(Panel.fit("[bold cyan]VESPERA Status[/bold cyan]", border_style="blue"))
    console.print()

    table = Table(show_header=True, header_style="bold magenta")
    table.add_column("Category", width=20)
    table.add_column("Status")

    # 1. Approval Queue
    aq_path = vault / "APPROVAL_QUEUE.md"
    if not aq_path.exists():
        aq_status = "[dim]Queue empty[/dim]"
    else:
        rows = _parse_md_table(aq_path.read_text(encoding="utf-8"))
        pending = sum(1 for r in rows if len(r) > 3 and "Pending" in r[3])
        aq_status = "[green]Clean[/green]" if pending == 0 else f"[yellow]{pending} pending[/yellow]"
    table.add_row("Approval Queue", aq_status)

    # 2. Asset Inbox
    pending_review = assets / "00_Inbox" / "Pending_Review"
    if not pending_review.exists():
        inbox_status = "[yellow]WARN — folder not found[/yellow]"
    else:
        count = len([f for f in pending_review.glob("*") if f.is_file()])
        inbox_status = "[green]Clean[/green]" if count == 0 else f"[yellow]{count} file(s)[/yellow]"
    table.add_row("Asset Inbox", inbox_status)

    # 3. Today's Task Intake
    inbox_dir = vault / "00_Inbox"
    if not inbox_dir.exists():
        intake_status = "[dim]Inbox not found[/dim]"
    else:
        today_tasks = list(inbox_dir.glob(f"{today}*.md"))
        intake_status = "[green]Clean[/green]" if len(today_tasks) == 0 else f"[yellow]{len(today_tasks)} task(s)[/yellow]"
    table.add_row("Today's Intake", intake_status)

    # 4. Recent Audit Log
    audit_path = vault / "AUDIT_LOG.md"
    if not audit_path.exists():
        table.add_row("Recent Audit", "[dim]No audit entries yet[/dim]")
    else:
        rows = _parse_md_table(audit_path.read_text(encoding="utf-8"))
        data_rows = [r for r in rows if len(r) >= 4 and r[0] and r[0] != "Timestamp"]
        last3 = data_rows[-3:] if data_rows else []
        if not last3:
            table.add_row("Recent Audit", "[dim]No audit entries yet[/dim]")
        else:
            first = True
            for r in last3:
                ts = r[0][:16] if len(r[0]) >= 16 else r[0]
                action = r[3] if len(r) > 3 else "—"
                label = "Recent Audit" if first else ""
                table.add_row(label, f"[dim]{ts}[/dim]  {action}")
                first = False

    # 5. Last Backup
    zips = sorted(backup_dir.glob("VESPERA_backup_*.zip")) if backup_dir.exists() else []
    if not zips:
        backup_status = "[dim]No backup found[/dim]"
    else:
        m = re.search(r"VESPERA_backup_(\d{8})_(\d{6})\.zip", zips[-1].name)
        if m:
            d, t = m.group(1), m.group(2)
            backup_status = f"{d[:4]}-{d[4:6]}-{d[6:]} {t[:2]}:{t[2:4]}"
        else:
            backup_status = zips[-1].name
    table.add_row("Last Backup", backup_status)

    console.print(table)
    console.print()
    console.print("[dim]Use [bold]vespera doctor[/bold] for full diagnostics.[/dim]")
    return 0


def build_parser():
    parser = argparse.ArgumentParser(
        prog="vespera",
        description="VESPERA Core CLI - local-first AI operations kit",
        epilog="Example: vespera log-task \"오늘 할 일 정리\""
    )
    sub = parser.add_subparsers(dest="command", required=True)

    health = sub.add_parser("healthcheck", help="Run healthcheck")
    health.add_argument("--vault", default="")
    health.add_argument("--assets", default="")
    health.set_defaults(func=cmd_healthcheck)

    route = sub.add_parser("route", help="Route a task")
    route.add_argument("task")
    route.set_defaults(func=cmd_route)

    log = sub.add_parser("log-task", help="Log a task")
    log.add_argument("task")
    log.add_argument("--project", default="General")
    log.add_argument("--vault", default="")
    log.set_defaults(func=cmd_log_task)

    audit = sub.add_parser("audit", help="Write audit log")
    audit.add_argument("action")
    audit.add_argument("--project", default="General")
    audit.add_argument("--actor", default="SAPGUN")
    audit.add_argument("--permission-level", type=int, default=0)
    audit.add_argument("--status", default="Logged")
    audit.add_argument("--notes", default="")
    audit.add_argument("--vault", default="")
    audit.set_defaults(func=cmd_audit)

    doctor = sub.add_parser("doctor", help="Run system diagnostics")
    doctor.set_defaults(func=cmd_doctor)

    init_cmd = sub.add_parser("init", help="Initialize environment")
    init_cmd.set_defaults(func=cmd_init)

    projects = sub.add_parser("projects", help="List all projects")
    projects.set_defaults(func=cmd_projects)

    assets = sub.add_parser("assets", help="Manage Asset Library")
    assets.set_defaults(func=cmd_assets)

    config = sub.add_parser("config", help="Show configuration files")
    config.set_defaults(func=cmd_config)

    backup = sub.add_parser("backup", help="Backup Vault and Assets")
    backup.set_defaults(func=cmd_backup)

    status = sub.add_parser("status", help="Quick status overview")
    status.set_defaults(func=cmd_status)

    return parser


def main():
    parser = build_parser()
    args = parser.parse_args()
    raise SystemExit(args.func(args))


if __name__ == "__main__":
    main()
