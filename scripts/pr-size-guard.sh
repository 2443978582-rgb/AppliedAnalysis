#!/usr/bin/env bash
# PR 规模与越界守卫。依赖 git；在 CI 中通过 PR_BASE 指定基线分支。
set -euo pipefail

BASE="${PR_BASE:-origin/main}"
MAX_LINES=2000
MAX_FILES=50
MAX_NEW_FILE_LINES=1000
FAIL=0

if git rev-parse --verify "$BASE" >/dev/null 2>&1; then
  RANGE="$BASE...HEAD"
else
  echo "⚠️  基线 $BASE 不存在，退回比较工作区"
  RANGE="HEAD"
fi

ADDED=$(git diff --numstat "$RANGE" -- . | awk '{a += $1} END {print a + 0}')
FILES=$(git diff --name-only "$RANGE" -- . | wc -l | tr -d ' ')

echo "== 规模：+$ADDED 行 / $FILES 个文件 =="
if [ "$ADDED" -gt "$MAX_LINES" ]; then
  echo "❌ 新增 $ADDED 行，超过上限 $MAX_LINES"
  FAIL=1
fi
if [ "$FILES" -gt "$MAX_FILES" ]; then
  echo "❌ 改动 $FILES 个文件，超过上限 $MAX_FILES"
  FAIL=1
fi

echo "== 越界改动 =="
while IFS= read -r f; do
  [ -z "$f" ] && continue
  case "$f" in
    AppliedAnalysis/*) ;;
    AppliedAnalysis.lean) ;;
    *)
      echo "❌ AI 不得修改: $f"
      FAIL=1
      ;;
  esac
done < <(git diff --name-only --diff-filter=ACMR "$RANGE" -- .)

echo "== 新文件行数 =="
while IFS= read -r f; do
  [ -z "$f" ] && continue
  [ -f "$f" ] || continue
  n=$(wc -l < "$f")
  if [ "$n" -gt "$MAX_NEW_FILE_LINES" ]; then
    echo "❌ $f 有 $n 行，超过新文件上限 $MAX_NEW_FILE_LINES"
    FAIL=1
  fi
done < <(git diff --name-only --diff-filter=A "$RANGE" -- .)

if [ "$FAIL" -ne 0 ]; then
  echo "❌ 规模守卫未通过"
  exit 1
fi
echo "✅ 规模守卫通过"
