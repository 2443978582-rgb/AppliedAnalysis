import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import AppliedAnalysis.LaplaceMethod.Defs

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

theorem laplaceTrunc_add {f g : ℝ → ℝ} {s R : ℝ}
    (hf : IntervalIntegrable (fun t => Real.exp (-(s * t)) * f t) volume 0 R)
    (hg : IntervalIntegrable (fun t => Real.exp (-(s * t)) * g t) volume 0 R) :
    laplaceTrunc (f + g) s R = laplaceTrunc f s R + laplaceTrunc g s R := by
  rw [laplaceTrunc, laplaceTrunc, laplaceTrunc]
  rw [← intervalIntegral.integral_add hf hg]
  apply intervalIntegral.integral_congr_ae
  filter_upwards with t
  intro _
  simp only [Pi.add_apply]
  ring

theorem laplaceTrunc_nonneg {f : ℝ → ℝ} {s R : ℝ}
    (hf : ∀ t, 0 ≤ f t) (hR : 0 ≤ R) : 0 ≤ laplaceTrunc f s R := by
  rw [laplaceTrunc]
  refine intervalIntegral.integral_nonneg hR ?_
  intro t _
  exact mul_nonneg (le_of_lt (Real.exp_pos _)) (hf t)

theorem laplaceTrunc_mono {f g : ℝ → ℝ} {s R : ℝ}
    (hfg : ∀ t, f t ≤ g t) (hR : 0 ≤ R)
    (hf : IntervalIntegrable (fun t => Real.exp (-(s * t)) * f t) volume 0 R)
    (hg : IntervalIntegrable (fun t => Real.exp (-(s * t)) * g t) volume 0 R) :
    laplaceTrunc f s R ≤ laplaceTrunc g s R := by
  rw [laplaceTrunc, laplaceTrunc]
  refine intervalIntegral.integral_mono hR hf hg ?_
  intro t
  exact mul_le_mul_of_nonneg_left (hfg t) (le_of_lt (Real.exp_pos _))

end AppliedAnalysis.Laplace
