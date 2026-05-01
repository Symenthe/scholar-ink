#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

echo "=== gh auth status ==="
gh auth status 2>&1

echo ""
echo "=== 启用 GitHub Pages ==="
gh api repos/Symenthe/scholar-ink/pages -X POST \
  -f "build_type=legacy" \
  -f "source[branch]=main" \
  -f "source[path]=/" 2>&1

echo ""
echo "等待部署完成后访问: https://seencoloo.github.io/scholar-ink/"
