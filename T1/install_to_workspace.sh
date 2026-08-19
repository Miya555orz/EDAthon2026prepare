#!/usr/bin/env bash
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
WORKSPACE="${1:-/workspace}"

if [[ ! -d "$WORKSPACE/problems/P1" ]]; then
  echo "ERROR: workspace does not look like an EDAthon workspace: $WORKSPACE" >&2
  exit 2
fi

cp "$PACK_ROOT"/harness/p1_*.sh "$WORKSPACE"/

mkdir -p "$WORKSPACE/toolkit/skills/edathon-p1-fast"
cp "$PACK_ROOT/skill/edathon-p1-fast/SKILL.md" "$WORKSPACE/toolkit/skills/edathon-p1-fast/SKILL.md"

mkdir -p "$WORKSPACE/local-docker"
cp "$PACK_ROOT/local-docker/Dockerfile.p1-cocotb" "$WORKSPACE/local-docker/Dockerfile.p1-cocotb"

echo "Installed T1 harness and skill into $WORKSPACE"
