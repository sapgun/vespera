import argparse
from pathlib import Path

from router import route_task
from audit import write_audit_log
from paths import default_vault_path, default_asset_path, repo_root

def cmd_healthcheck(args):
    root = repo_root()
    vault = Path(args.vault) if args.vault else default_vault_path()
    assets = Path(args.assets) if args.assets else default_asset_path()

    checks = [
        ("Repo README", root / "README.md", True),
        ("Config folder", root / "config", True),
        ("Docs folder", root / "docs", True),
        ("Scripts folder", root / "scripts", True),
        ("Obsidian Vault", vault, False),
        ("Asset Library", assets, False),
        ("Asset Pending Review", assets / "00_Inbox" / "Pending_Review", False),
    ]

    ok = warn = fail = 0

    print()
    print("KAIROS Core Healthcheck")
    print("=======================")
    print()

    for label, path, required in checks:
        if path.exists():
            print(f"[OK]   {label} -> {path}")
            ok += 1
        else:
            if required:
                print(f"[FAIL] {label} missing -> {path}")
                fail += 1
            else:
                print(f"[WARN] {label} missing -> {path}")
                warn += 1

    print()
    print("Summary")
    print("-------")
    print(f"OK:   {ok}")
    print(f"WARN: {warn}")
    print(f"FAIL: {fail}")

    return 1 if fail else 0

def cmd_route(args):
    result = route_task(args.task)

    print()
    print("KAIROS Core Router")
    print("==================")
    print()
    print(f"Task: {args.task}")
    print(f"Route Type: {result.route_type}")
    print(f"Primary: {result.primary}")
    print(f"Secondary: {result.secondary}")
    print(f"Reviewer: {result.reviewer}")
    print(f"Permission Level: Level {result.permission_level}")
    print()
    print("Suggested Prompt:")
    print(result.suggested_prompt)
    print()

    if result.permission_level >= 2:
        print("Approval Required: Human-in-the-loop approval is required before execution.")
        print()

    return 0

def cmd_audit(args):
    vault = args.vault or str(default_vault_path())

    audit_file = write_audit_log(
        vault_path=vault,
        project=args.project,
        actor=args.actor,
        action=args.action,
        permission_level=args.permission_level,
        status=args.status,
        notes=args.notes,
    )

    print()
    print("KAIROS Core Audit")
    print("=================")
    print()
    print(f"[OK] Audit entry written -> {audit_file}")
    print()

    return 0

def build_parser():
    parser = argparse.ArgumentParser(
        prog="kairos",
        description="KAIROS Core CLI - local-first AI operations kit",
    )

    sub = parser.add_subparsers(dest="command", required=True)

    health = sub.add_parser("healthcheck", help="Run KAIROS core healthcheck")
    health.add_argument("--vault", default="")
    health.add_argument("--assets", default="")
    health.set_defaults(func=cmd_healthcheck)

    route = sub.add_parser("route", help="Route a task")
    route.add_argument("task")
    route.set_defaults(func=cmd_route)

    audit = sub.add_parser("audit", help="Write audit log")
    audit.add_argument("action")
    audit.add_argument("--project", default="General")
    audit.add_argument("--actor", default="SAPGUN")
    audit.add_argument("--permission-level", type=int, default=0)
    audit.add_argument("--status", default="Logged")
    audit.add_argument("--notes", default="")
    audit.add_argument("--vault", default="")
    audit.set_defaults(func=cmd_audit)

    return parser

def main():
    parser = build_parser()
    args = parser.parse_args()
    raise SystemExit(args.func(args))

if __name__ == "__main__":
    main()
