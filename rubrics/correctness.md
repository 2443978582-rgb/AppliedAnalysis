# rubric: correctness（正确性）

前缀见 `_common.md`。本 rubric 只判断"证明是否真的成立、陈述是否与规格一致"。

按以下顺序逐条检查，任一失败即 BLOCK。

## C1 定义一致性

- `laplaceTrunc` 是否与 `roadmap/LaplaceMethod/README.md` §2 逐字对应：
  - 被积函数 `Real.exp (-(s * t)) * f t`（乘数顺序不得颠倒后声称"等价"）
  - 下限 `(0 : ℝ)`，区间写法 `∫ t in (0 : ℝ)..R`
  - 参数顺序 `(f : ℝ → ℝ) (s R : ℝ)`
- 若定义被改写，必须给出等价性引理；仅当 roadmap 允许时才可接受。

## C2 陈述忠实性

- 参数、假设、结论是否与 `Suggested.lean` 完全一致（含名字）。
- 检查是否**偷偷加强假设**（例如给 `laplaceTrunc_nonneg` 加 `s ≥ 0`——本不需要）。
- 检查是否**偷偷弱化结论**：
  - `~[atTop]` 降级成 `=O[atTop]` 或"存在子列"
  - `Tendsto` 降级成"部分和有界"
  - 把 `= (1 - e^{-sR})/s` 写成 `≤`
- 渐近等价必须双向可除（`f/g → 1`），不能只给一侧不等式。

## C3 证明完整性

- 全仓库是否还有 `sorry` / `admit` / `native_decide`。
- `#print axioms` 是否只含 `propext`、`Classical.choice`、`Quot.sound`。
- 是否新增 `axiom` / `constant` / `opaque` / `unsafe`。

## C4 循环论证与隐藏前提

- 被证定理是否反向依赖后续更强的定理（如 A10 直接引用 A9 之外的"Stirling 完整版"）。
- 是否把结论当作 `have` 前提引入（例如 A5 中直接假设余项 `O(λ⁻²)` 却不证明）。
- 是否引用了 roadmap 之外、仓库内也未证明的"已知结果"。

## C5 边界情况

- `R = 0`、`R < 0`（区间积分反向的符号）是否在陈述与证明中被正确处理。
- `s ≤ 0` 时哪些结论仍成立、哪些必须排除（如 `norm_laplaceTrunc_le` 要求 `0 < s`）。
- `n = 0` 时 `integral_pow_mul_exp` 是否退化为 `1/s`。
- A6 的 `f''(s) > 0` 是否被用于给出正的二次型下界，而不是仅当装饰。

## C6 与 Mathlib 的重复

- 每条公开声明先用 `exact?` / `grep` 查 Mathlib 是否已有同义定理。
- 尤其检查：`integral_exp_neg_mul`、`stirling_equivalent`、`integral_exp_neg_mul_sq`。
- 若 Mathlib 已有：BLOCK，要求改为引用或降级为 corollary 并说明。

## C7 命名与作用域

- 公开声明是否都在 `AppliedAnalysis.Laplace` 命名空间下。
- 辅助引理是否 `private`；`private` 名字不得泄漏进公开 API。
