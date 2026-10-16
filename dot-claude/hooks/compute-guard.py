#!/usr/bin/env python3
"""PreToolUse(Bash) guard for the shared Slurm cluster.

- Bare `sbatch` is denied: submissions must go through the cap-checking
  `slurm-submit` wrapper (see the slurm-cluster skill).
- Any `scancel` asks the user first: never cancel someone else's job unprompted.
"""

import json
import re
import sys

CMD_START = r"(?:^|[\s;&|(`'\"])"
SBATCH = re.compile(CMD_START + r"sbatch(?:\s|$|['\"])")
SBATCH_HARMLESS = re.compile(r"sbatch\s+(?:--version|--help|--usage|-V)\b")
SCANCEL = re.compile(CMD_START + r"scancel(?:\s|$|['\"])")


def decide(decision, reason):
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": decision,
                "permissionDecisionReason": reason,
            }
        },
        sys.stdout,
    )
    sys.exit(0)


try:
    cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
except (json.JSONDecodeError, AttributeError):
    sys.exit(0)

if SCANCEL.search(cmd):
    decide(
        "ask",
        "scancel on the shared cluster: confirm these are jobs Claude submitted "
        "(~/.local/state/claude-slurm/submitted.tsv)",
    )

if SBATCH.search(cmd) and "slurm-submit" not in cmd and not SBATCH_HARMLESS.search(cmd):
    decide(
        "deny",
        "Bare sbatch is blocked. Submit via "
        "~/.claude/skills/slurm-cluster/scripts/slurm-submit, which enforces the job caps, "
        "--time limit and umask 077 (see the slurm-cluster skill).",
    )
