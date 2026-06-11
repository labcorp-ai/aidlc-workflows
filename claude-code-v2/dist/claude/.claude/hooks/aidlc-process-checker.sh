#!/bin/bash
# Runs the process checker after a sub-agent completes.
# Called by the PostToolUse hook in settings.json when tool_name == Task.
# Usage: bash .claude/hooks/aidlc-process-checker.sh <intent-dir>

if [ -z "$1" ]; then
  echo '{"reminder":"Pass the intent directory path to process-checker: node .claude/tools/process-checker.js <intent-dir>"}'
  exit 0
fi

node "$(dirname "$0")/../tools/process-checker.js" "$1"
