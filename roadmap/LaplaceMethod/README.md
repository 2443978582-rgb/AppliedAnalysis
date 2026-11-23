# Laplace 方法与渐近展开

- 状态：v1（**未实现**，`AppliedAnalysis/LaplaceMethod/` 目前不存在）
- 维护：人类专属文件。AI 只读，不得修改本目录任何内容
- 对应代码目录：`AppliedAnalysis/LaplaceMethod/`

---

## 1. 范围

把应用数学中最核心的渐近工具形式化：**Laplace 型积分的首项渐近**及其经典推论。

- 截断 Laplace 变换的定义、线性、正性与一致界
- 初等积分 `∫₀^R e^{-st} dt`、`∫₀^∞ tⁿ e^{-st} dt = n!/s^{n+1}`
- Watson 引理一阶形式（端点奇性主导）
- Laplace 方法首项渐近：内部极大点 / 边界极大点两种情形
- 高斯积分渐近 `∫ e^{-λ t²} ~ √(π/λ)`
- Stirling 公式与其对数形式（作为推论）

**不在范围**（不要顺手做）：

- 稳相法（stationary phase）、Airy 型一致渐近
- 多参数 / 多维 Laplace 方法（`ℝⁿ`、Hessian 情形）
- 复平面上的鞍点法、最速下降路径
- 数值算法与图表

---

## 2. 记号与约定

```
laplaceTrunc f s R = ∫₀^R e^{-s t} · f t dt        （截断，永远是正常积分）
```

约定：

| 项 | 约定 |
|----|------|
| 截断积分 | 一律 `∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) * f t`，不写 Lebesgue 全集 |
| 反常积分 | 只能以 `Tendsto (fun R => laplaceTrunc f s R) atTop (𝓝 L)` 形式出现 |
| 渐近等价 | 用 `~[atTop]`（`Asymptotics.IsEquivalent`），不用 `IsBigO` 假装 |
| 命名空间 | `AppliedAnalysis.Laplace` |
| 定理命名 | `laplaceTrunc_*` / `integral_*` / `watson_*` / `laplace_leading_*` |

硬性要求：任何`~[atTop]`结论都必须由**显式的上下界夹逼**得到，不得直接引用未证明的渐近展开。

---

## 3. 可依赖的 Mathlib 基础

| 能力 | 位置 |
|------|------|
| 区间积分与 FTC | `Mathlib.Analysis.SpecialFunctions.Integrals.Basic`、`MeasureTheory.Integral.IntervalIntegral.*` |
| `Real.exp` 的单调性、导数、正性 | `Real.exp_pos`、`Real.exp_le_exp`、`Real.hasDerivAt_exp`、`Real.exp_neg` |
| 高斯积分 | `Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral` |
| 阶乘与 Gamma | `Nat.factorial`、`Real.Gamma`、`Real.Gamma_nat_eq_factorial` |
| 渐近记号 | `Asymptotics.IsEquivalent`、`IsBigO`、`=O[atTop]`、`~[atTop]` |
| 对数与幂 | `Real.log_le_sub_one_of_pos`、`Real.log_pow`、`rpow` 系列 |

若发现目标定理 Mathlib 已有（例如 Stirling 公式）：**不要重证**，改为引用并在 PR 中降级为 corollary。

---

## 4. 交付清单

| # | 目标 | 文件 | 主要声明 | 难度 |
|---|------|------|----------|------|
| A1 | 定义与基本值 | `LaplaceMethod/Defs.lean` | `laplaceTrunc` `laplaceTrunc_zero` `laplaceTrunc_one` | L1 |
| A2 | 线性与单调 | `LaplaceMethod/Basic.lean` | `laplaceTrunc_add` `laplaceTrunc_nonneg` `laplaceTrunc_mono` | L1 |
| A3 | 一致界 | `LaplaceMethod/Bound.lean` | `norm_laplaceTrunc_le` | L2 |
| A4 | 初等积分 | `LaplaceMethod/Watson.lean` | `integral_exp_neg_mul` `integral_pow_mul_exp` | L2 |
| A5 | Watson 引理（一阶） | `LaplaceMethod/Watson.lean` | `watson_first_order` | L3 |
| A6 | 内部极大点首项 | `LaplaceMethod/Method.lean` | `laplace_leading_interior` | L3 |
| A7 | 边界极大点首项 | `LaplaceMethod/Method.lean` | `laplace_leading_boundary` | L3 |
| A8 | 高斯积分渐近 | `LaplaceMethod/Method.lean` | `integral_exp_neg_mul_sq` | L2 |
| A9 | Stirling 公式 | `LaplaceMethod/Applications.lean` | `stirling_equivalent` | L3 |
| A10 | 对数阶乘渐近 | `LaplaceMethod/Applications.lean` | `log_factorial_asymptotic` | L2 |

> 权威签名见 `Suggested.lean`；两者不一致时以 `Suggested.lean` 为准，并提 PR 修正本文件。

---

## 5. 逐项验收细则

### A1 定义与基本值
- `laplaceTrunc f s 0 = 0` 走 `∫_0^0 = 0`。
- `laplaceTrunc_one`：`f ≡ 1` 时退化为 `∫₀^R e^{-st} dt`，不得提前引用 A4（保持依赖顺序）。

### A2 线性与单调
- `laplaceTrunc_add` 需显式给出两个 `IntervalIntegrable` 假设（区间积分加法引理的前提）。
- `laplaceTrunc_nonneg`：`0 ≤ f` 与 `0 ≤ s` 时逐点非负，用 `intervalIntegral.integral_nonneg`。
- `laplaceTrunc_mono`：`f ≤ g` 逐点且可积时单调；不允许先证 `f - g` 的版本再绕回来（多一步无意义改写）。

### A3 一致界
- 结论形状：`‖laplaceTrunc f s R‖ ≤ M * (1 - Real.exp (-(s * R))) / s`，`s > 0`、`‖f‖ ≤ M`。
- 必须用 `norm_integral_le_of_norm_le_const` 或同族引理，并单独给出 `∫₀^R e^{-st}` 的上界。

### A4 初等积分
- `integral_exp_neg_mul`：`s ≠ 0` 时 `∫₀^R e^{-st} dt = (1 - e^{-sR})/s`。
- `integral_pow_mul_exp`：`Tendsto (fun R => ∫ t in 0..R, t^n * e^{-st}) atTop (𝓝 (n! / s^{n+1}))`，`s > 0`。归纳法 + 分部积分，必须显式写出 `n → n+1` 的递推。

### A5 Watson 引理（一阶）
- 前提：`(fun t => g t - a) =O[𝓝[>] 0] (fun t => t)`（只要求右极限附近）。
- 结论：`(fun λ => ∫₀^∞ e^{-λt} g t) ~[atTop] (fun λ => a / λ)`；反常积分用 `Tendsto` 形式表达。
- 必须给出**余项界**：`‖∫₀^∞ e^{-λt}(g t - a)‖ ≤ C / λ²`，再据此夹逼。

### A6 内部极大点
- 前提：`deriv f s = 0`、`0 < iteratedDeriv 2 f s`、`0 < g s`，`g` 在 `s` 连续。
- 结论：`∫_{s-1}^{s+1} g·e^{-λf} ~ g s · e^{-λ f s} · √(2π / (λ f''(s)))`。
- 必须先用二次型界 `f(t) ≥ f(s) + c(t-s)²/2` 做夹逼，c 取 `f''(s)/2` 的局部下界；**禁止**直接引用未形式化的 Laplace 方法结论。

### A7 边界极大点
- 前提：`f` 在 `s` 右邻域严格递增，`0 < deriv f s`；积分区间为 `[s, s+1]`。
- 结论：`~ g s · e^{-λ f s} / (λ · deriv f s)`。

### A8 高斯积分渐近
- 结论：`Tendsto (fun λ => ∫ t in 0..1, Real.exp (-(λ * t ^ 2))) atTop (𝓝 0)` 不够；要求
  `(fun λ => ∫ t in (0:ℝ)..∞, Real.exp (-(λ * t^2))) ~[atTop] (fun λ => Real.sqrt (Real.pi / λ))`，
  反常积分同样用 `Tendsto` 表达。
- 允许用 `GaussianIntegral` 的已知结果做换元，但换元必须逐步可查。

### A9 Stirling 公式
- **先查 Mathlib**：若已有 `Nat.factorial ~ √(2πn)(n/e)ⁿ` 的等价形式，本项改为 corollary 引用并在 PR 说明。
- 否则：`(fun n : ℕ => (n.factorial : ℝ)) ~[atTop] (fun n => Real.sqrt (2 * Real.pi * n) * (n / Real.exp 1) ^ n)`。

### A10 对数阶乘渐近
- 结论：`(fun n => Real.log n.factorial - (n * Real.log n - n)) =O[atTop] (fun n => Real.log n)`。
- 必须由 A9 推出，不得独立证明（保证依赖链单向）。

---

## 6. 每个 PR 的硬性验收

- [ ] 只做清单中的一项（或同一文件内不可分的一组）
- [ ] 无 `sorry` / `admit` / `native_decide` / `set_option` / `maxHeartbeats`
- [ ] `#print axioms` 仅含 `propext` `Classical.choice` `Quot.sound`
- [ ] 未修改 Mathlib 与 `.lake/`
- [ ] 根文件 `AppliedAnalysis.lean` 的 import 已更新，`lake build` 通过
- [ ] 新增 ≤ 2000 行，单文件 ≤ 1000 行
- [ ] 声明名与 `Suggested.lean` 完全一致

---

## 7. 参考文献

- Bender & Orszag, *Advanced Mathematical Methods for Scientists and Engineers*, Ch. 6（Laplace 方法）
- de Bruijn, *Asymptotic Methods in Analysis*, Ch. 4（Watson 引理）
- Bleistein & Handelsman, *Asymptotic Expansions of Integrals*, Ch. 4
- DLMF §2.3（渐近积分的定义与基本性质）