# AppliedAnalysis

应用分析的形式化数学库 —— **Tau Ceti 式 AI 协作工作流的最小闭环**。

人类只写规格（roadmap）与评审规则（rubrics），AI 在明确边界内实现，Lean 内核负责最终正确性。

## 当前状态

| 项 | 状态 |
|----|------|
| 仓库骨架 | ✅ 可构建（依赖已解析，Mathlib v4.33.1） |
| Roadmap | 1 条：`LaplaceMethod`（v1，未实现） |
| 代码 | 0 行实现 |
| 评审规则 | `rubrics/correctness.md`（v1） |

## 结构与边界

```
AppliedAnalysis/
├── AppliedAnalysis.lean        # 库根文件（只加 import）
├── AppliedAnalysis/            # ← AI 唯一可写的代码区
│   └── LaplaceMethod/          #   按 roadmap 实现（当前不存在）
├── roadmap/                    # ← 人类专属：规格，AI 只读
│   └── LaplaceMethod/
│       ├── README.md           #   定义、A1–A10 清单、验收细则
│       └── Suggested.lean      #   目标签名（权威）
├── rubrics/                    # ← 人类专属：评审判据
│   ├── _common.md
│   └── correctness.md
├── scripts/                    # ← 人类专属：机械守卫
│   ├── source-guard.sh
│   └── pr-size-guard.sh
├── AGENTS.md                   # AI 行为契约
└── .github/                    # CI 与 PR 模板
```

## 快速开始

```bash
# 1. Lean 工具链（lean-toolchain: v4.33.1；Mathlib 同步 pin v4.33.1）
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y

# 2. 依赖与缓存（首次约数 GB，必须做）
lake exe cache get

# 3. 构建
lake build --iofail

# 4. 机械守卫
bash scripts/source-guard.sh
```

> `lake exe cache get` 是唯一"不做就完全跑不起来"的一步。
>
> 若构建报 `failed to read file '.../*.olean'`：这是本机可用内存不足（导入 Mathlib 需数 GB 常驻内存），关掉其他程序后重试，与仓库配置无关。

## 工作流

1. **人类**：在 `roadmap/LaplaceMethod/README.md` 增删交付项，并在 `Suggested.lean` 写死签名。
2. **AI**：按 `AGENTS.md` 在 `AppliedAnalysis/LaplaceMethod/` 实现，只做一项，自检三条命令。
3. **评审**：用 `rubrics/correctness.md` 对抗式审查（默认 BLOCK，直到找出问题）。

## Roadmap 索引

| 领域 | 状态 | 交付数 |
|------|------|--------|
| [Laplace 方法与渐近展开](roadmap/LaplaceMethod/README.md) | 未实现 | 10（A1–A10） |
