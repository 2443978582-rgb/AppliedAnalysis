# AGENTS.md — AI 可写边界

本文件是**约束**，不是建议。任何违反以下条款的改动一律视为无效 PR。

## 1. 你的角色

你是**实现者**，不是设计者。数学内容由人类在 `roadmap/` 中规定，你只负责把它写成能通过 Lean 内核的代码。

## 2. 可写范围（只有这些）

| 路径 | 权限 |
|------|------|
| `AppliedAnalysis/LaplaceMethod/*.lean` | 新建 / 修改 |
| `AppliedAnalysis.lean` | 只能添加 `import` 行 |

## 3. 禁写范围（只读）

`roadmap/`、`rubrics/`、`scripts/`、`.github/`、`lakefile.toml`、`lean-toolchain`、`.lake/`、任何 Mathlib 文件。

若认为 roadmap 有错：**停下来**，在 PR 描述里写清楚，不要自己改。

## 4. 硬性禁令（出现即拒绝）

- `sorry`、`admit`、`native_decide`
- `set_option`（含 `maxHeartbeats`、`diagnostics`）
- 新增 `axiom`、`constant`、`opaque`
- `unsafe`、`extern`、自定义 `macro` / `elab` 绕过检查
- 为了通过而弱化陈述（`~[atTop]` 改成 `IsBigO`、加多余假设、缩小定义域）

## 5. 规模限制

- 单个 PR 只做 roadmap 清单中的**一项**（或同一文件内天然不可分的一组，如 A1+A2）
- 新增行数 ≤ 2000，单文件 ≤ 1000
- 不做"顺手重构"：不改已有证明的写法，除非它无法编译

## 6. 交付前自检

```bash
lake build --iofail
bash scripts/source-guard.sh
bash scripts/pr-size-guard.sh
```

三条全绿才算完成。报告时贴命令与输出摘要，不要只说"已完成"。

## 7. 陈述忠实性

- 声明名、参数顺序、结论必须与 `roadmap/LaplaceMethod/Suggested.lean` 一致
- 允许增加 `private` 辅助引理；它们不得出现在公开 API
- 不允许用更强的定理"顺带"完成多项（会让评审无法定位错误来源）
- 渐近结论必须由显式界夹逼得到，不得引用未形式化的教科书结论
