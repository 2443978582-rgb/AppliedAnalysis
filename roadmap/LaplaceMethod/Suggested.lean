/-
  本文件是 roadmap 的目标签名（spec），**不属于 lake 构建目标**，不参与 CI。

  规则：
  - 声明名与 `roadmap/LaplaceMethod/README.md` 的表格一致；
  - `sorry` 是刻意的：这里只固定接口，不提供证明；
  - 实现时把对应声明搬到 `AppliedAnalysis/LaplaceMethod/*.lean`，不要让本目录进入构建。
-/
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

noncomputable section

open MeasureTheory

namespace AppliedAnalysis.Laplace

/-! ## A1 定义与基本值 -/

/-- 截断 Laplace 变换：`∫₀ᴿ e^{-s t} f t dt`。 -/
noncomputable def laplaceTrunc (f : ℝ → ℝ) (s R : ℝ) : ℝ :=
  ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) * f t

theorem laplaceTrunc_zero (f : ℝ → ℝ) (s : ℝ) : laplaceTrunc f s 0 = 0 := by sorry

theorem laplaceTrunc_one (s R : ℝ) :
    laplaceTrunc (fun _ => 1) s R = ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) := by sorry

/-! ## A2 线性与单调 -/

theorem laplaceTrunc_add {f g : ℝ → ℝ} {s R : ℝ}
    (hf : IntervalIntegrable (fun t => Real.exp (-(s * t)) * f t) volume 0 R)
    (hg : IntervalIntegrable (fun t => Real.exp (-(s * t)) * g t) volume 0 R) :
    laplaceTrunc (f + g) s R = laplaceTrunc f s R + laplaceTrunc g s R := by sorry

theorem laplaceTrunc_nonneg {f : ℝ → ℝ} {s R : ℝ}
    (hf : ∀ t, 0 ≤ f t) (hR : 0 ≤ R) : 0 ≤ laplaceTrunc f s R := by sorry

theorem laplaceTrunc_mono {f g : ℝ → ℝ} {s R : ℝ}
    (hfg : ∀ t, f t ≤ g t) (hR : 0 ≤ R)
    (hf : IntervalIntegrable (fun t => Real.exp (-(s * t)) * f t) volume 0 R)
    (hg : IntervalIntegrable (fun t => Real.exp (-(s * t)) * g t) volume 0 R) :
    laplaceTrunc f s R ≤ laplaceTrunc g s R := by sorry

/-! ## A3 一致界 -/

theorem norm_laplaceTrunc_le {f : ℝ → ℝ} {s R M : ℝ}
    (hf : ∀ t, ‖f t‖ ≤ M) (hs : 0 < s) (hR : 0 ≤ R) :
    ‖laplaceTrunc f s R‖ ≤ M * (1 - Real.exp (-(s * R))) / s := by sorry

/-! ## A4 初等积分 -/

theorem integral_exp_neg_mul {s R : ℝ} (hs : s ≠ 0) :
    ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = (1 - Real.exp (-(s * R))) / s := by sorry

theorem integral_pow_mul_exp (n : ℕ) {s : ℝ} (hs : 0 < s) :
    Tendsto (fun R : ℝ => ∫ t in (0 : ℝ)..R, t ^ n * Real.exp (-(s * t))) atTop
      (𝓝 ((n.factorial : ℝ) / s ^ (n + 1))) := by sorry

/-! ## A5 Watson 引理（一阶） -/

theorem watson_first_order {g : ℝ → ℝ} {a : ℝ}
    (hg : (fun t : ℝ => g t - a) =O[𝓝[>] (0 : ℝ)] (fun t : ℝ => t)) :
    (fun lam : ℝ => ∫ t in Set.Ioi (0 : ℝ), Real.exp (-(lam * t)) * g t)
      ~[atTop] (fun lam : ℝ => a / lam) := by sorry

/-! ## A6 / A7 Laplace 方法首项 -/

theorem laplace_leading_interior {f g : ℝ → ℝ} {s : ℝ}
    (hderiv : deriv f s = 0) (hf'' : 0 < iteratedDeriv 2 f s)
    (hg : 0 < g s) (hgcont : ContinuousAt g s) :
    (fun lam : ℝ => ∫ t in (s - 1)..(s + 1), g t * Real.exp (-(lam * f t)))
      ~[atTop] (fun lam : ℝ =>
        g s * Real.exp (-(lam * f s)) *
          Real.sqrt (2 * Real.pi / (lam * iteratedDeriv 2 f s))) := by sorry

theorem laplace_leading_boundary {f g : ℝ → ℝ} {s : ℝ}
    (hf' : 0 < deriv f s) (hg : 0 < g s) (hgcont : ContinuousAt g s) :
    (fun lam : ℝ => ∫ t in s..(s + 1), g t * Real.exp (-(lam * f t)))
      ~[atTop] (fun lam : ℝ => g s * Real.exp (-(lam * f s)) / (lam * deriv f s)) := by
  sorry

/-! ## A8 高斯积分渐近 -/

theorem integral_exp_neg_mul_sq :
    (fun lam : ℝ => ∫ t in Set.Ioi (0 : ℝ), Real.exp (-(lam * t ^ 2)))
      ~[atTop] (fun lam : ℝ => Real.sqrt (Real.pi / lam)) := by sorry

/-! ## A9 / A10 应用 -/

theorem stirling_equivalent :
    (fun n : ℕ => (n.factorial : ℝ)) ~[atTop]
      (fun n : ℕ => Real.sqrt (2 * Real.pi * n) * (n / Real.exp 1) ^ n) := by sorry

theorem log_factorial_asymptotic :
    (fun n : ℕ => Real.log (n.factorial : ℝ) - (n * Real.log n - n))
      =O[atTop] (fun n : ℕ => Real.log n) := by sorry

end AppliedAnalysis.Laplace