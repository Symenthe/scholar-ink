#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

echo "=== Workflow Run 详情 ==="
gh run view --repo Symenthe/scholar-ink 2>&1

echo ""
echo "=== Workflow Run 日志 ==="
gh run view --log --repo Symenthe/scholar-ink 2>&1 | tail -50
