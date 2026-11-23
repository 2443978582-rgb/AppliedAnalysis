#!/usr/bin/env bash
# 源码守卫：检查禁用写法、公理、元编程 import、文件规模。
# 用法: bash scripts/source-guard.sh [目标目录，默认 AppliedAnalysis]
set -euo pipefail

TARGET_DIR="${1:-AppliedAnalysis}"
FAIL=0

if [ ! -d "$TARGET_DIR" ]; then
  echo "⚠️  目录 $TARGET_DIR 不存在（尚未开始实现），跳过源码检查"
  exit 0
fi

echo "== 1/4 禁用写法 =="
BAD='\b(sorry|admit|native_decide|decide\s*!|unsafe|extern)\b|set_option'
if grep -RInE "$BAD" "$TARGET_DIR" --include='*.lean'; then
  echo "❌ 检测到禁用写法（sorry/admit/native_decide/unsafe/extern/set_option）"
  FAIL=1
else
  echo "✅ 无禁用写法"
fi

echo "== 2/4 公理与新常量 =="
if grep -RInE '^[[:space:]]*(axiom|constant|opaque)[[:space:]]' "$TARGET_DIR" --include='*.lean'; then
  echo "❌ 不允许新增 axiom/constant/opaque"
  FAIL=1
else
  echo "✅ 无新增公理或未定义常量"
fi

echo "== 3/4 元编程 import 边界 =="
if grep -RInE '^[[:space:]]*(meta[[:space:]]+)?import[[:space:]]+(Lean|Lake)\b' \
     "$TARGET_DIR" --include='*.lean'; then
  echo "❌ 禁止 import Lean/Lake 实现模块（数学与元编程必须分离）"
  FAIL=1
else
  echo "✅ import 边界干净"
fi

echo "== 4/4 文件规模 =="
while IFS= read -r f; do
  n=$(wc -l < "$f")
  if [ "$n" -gt 1000 ]; then
    echo "❌ $f 有 $n 行（上限 1000）"
    FAIL=1
  fi
done < <(find "$TARGET_DIR" -name '*.lean' -type f)
[ "$FAIL" -eq 0 ] && echo "✅ 单文件行数合规"

if [ "$FAIL" -ne 0 ]; then
  echo "❌ 源码守卫未通过"
  exit 1
fi
echo "✅ 源码守卫通过"
