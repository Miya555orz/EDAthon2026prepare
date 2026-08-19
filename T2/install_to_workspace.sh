#!/usr/bin/env bash
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_PATH="${1:-/workspace}"

test -d "$WORKSPACE_PATH/problems/P2"

cp "$PACK_ROOT/harness"/p2_*.sh "$WORKSPACE_PATH"/
mkdir -p "$WORKSPACE_PATH/toolkit/skills/edathon-p2-fast"
cp "$PACK_ROOT/skill/edathon-p2-fast/SKILL.md" "$WORKSPACE_PATH/toolkit/skills/edathon-p2-fast/SKILL.md"
chmod +x "$WORKSPACE_PATH"/p2_*.sh

echo "Installed T2 harness into $WORKSPACE_PATH"
echo "Next: bash /workspace/p2_env_check.sh"
