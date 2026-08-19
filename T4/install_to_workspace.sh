#!/usr/bin/env bash
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_PATH="${1:-/workspace}"

test -d "$WORKSPACE_PATH/problems/P4"

cp "$PACK_ROOT/harness"/p4_*.sh "$WORKSPACE_PATH"/
mkdir -p "$WORKSPACE_PATH/toolkit/skills/edathon-p4-fast"
cp "$PACK_ROOT/skill/edathon-p4-fast/SKILL.md" "$WORKSPACE_PATH/toolkit/skills/edathon-p4-fast/SKILL.md"
chmod +x "$WORKSPACE_PATH"/p4_*.sh

echo "Installed T4 harness into $WORKSPACE_PATH"
echo "Next: bash /workspace/p4_env_check.sh"
