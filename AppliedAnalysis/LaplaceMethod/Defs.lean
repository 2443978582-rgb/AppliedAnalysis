/-!
  本模块实现 roadmap A1：Laplace 截断变换的定义与基本值。
-/
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

/-- 截断 Laplace 变换：`∫₀ᴿ e^{-s t} f t dt`。 -/
noncomputable def laplaceTrunc (f : ℝ → ℝ) (s R : ℝ) : ℝ :=
  ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) * f t

/-! ### 基本值 -/

theorem laplaceTrunc_zero (f : ℝ → ℝ) (s : ℝ) : laplaceTrunc f s 0 = 0 := by
  rw [laplaceTrunc]
  have h : ∫ t in (0 : ℝ)..(0 : ℝ), Real.exp (-(s * t)) * f t = 0 :=
    intervalIntegral.integral_same (μ := volume)
  exact h

theorem laplaceTrunc_one (s R : ℝ) :
    laplaceTrunc (fun _ => 1) s R = ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) := by
  rw [laplaceTrunc]
  apply intervalIntegral.integral_congr_ae
  filter_upwards with t
  intro _
  rw [mul_one]

end AppliedAnalysis.Laplace
