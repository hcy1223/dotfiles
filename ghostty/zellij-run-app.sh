#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./zellij-run-app.sh your_app --arg
#   KEY1=foo KEY2=bar KEY3=baz ./zellij-run-app.sh your_app --arg
#   SESSION_NAME=ai ./zellij-run-app.sh your_app --arg
#   ./zellij-run-app.sh                      # default: zsh

if [ "$#" -lt 1 ]; then
  set -- zsh
fi

ANTHROPIC_AUTH_TOKEN="" # Supply privately after restore.
ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"
ANTHROPIC_MODEL="qwen3.5-plus"

if [ -n "${ZELLIJ:-}" ]; then
  # Already inside a Zellij session: open a new pane and run the app there.
  zellij run -n app -- env \
    ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN" \
    ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL" \
    ANTHROPIC_MODEL="$ANTHROPIC_MODEL" \
    "$@"
else
  # No active session: create/enter one.
  # zellij 0.43.x does not support: zellij -s <name> -- <command>
  SESSION_NAME="${SESSION_NAME:-ai}"
  if [ "$#" -gt 0 ] && [ "$1" != "zsh" ]; then
    echo "Info: started session '$SESSION_NAME'. Run command inside session: $*" >&2
  fi
  exec env \
    ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN" \
    ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL" \
    ANTHROPIC_MODEL="$ANTHROPIC_MODEL" \
    zellij -s "$SESSION_NAME"
fi
