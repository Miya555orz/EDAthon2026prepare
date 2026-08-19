#!/usr/bin/env bash
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_PATH="${1:-/workspace}"

test -d "$WORKSPACE_PATH/problems/P3"

cp "$PACK_ROOT/harness"/p3_*.sh "$WORKSPACE_PATH"/
mkdir -p "$WORKSPACE_PATH/toolkit/skills/edathon-p3-fast"
cp "$PACK_ROOT/skill/edathon-p3-fast/SKILL.md" "$WORKSPACE_PATH/toolkit/skills/edathon-p3-fast/SKILL.md"
chmod +x "$WORKSPACE_PATH"/p3_*.sh

echo "Installed T3 harness into $WORKSPACE_PATH"
echo "Next: bash /workspace/p3_env_check.sh"
