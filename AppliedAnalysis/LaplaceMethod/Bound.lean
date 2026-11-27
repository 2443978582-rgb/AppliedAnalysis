import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import AppliedAnalysis.LaplaceMethod.Defs
import AppliedAnalysis.LaplaceMethod.Elementary

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

theorem norm_laplaceTrunc_le {f : ℝ → ℝ} {s R M : ℝ}
    (hf : ∀ t, ‖f t‖ ≤ M) (hs : 0 < s) (hR : 0 ≤ R) :
    ‖laplaceTrunc f s R‖ ≤ M * (1 - Real.exp (-(s * R))) / s := by
  rw [laplaceTrunc]
  have hmaj : IntervalIntegrable (fun t : ℝ => Real.exp (-(s * t)) * M) volume 0 R :=
    (by fun_prop : Continuous fun t : ℝ => Real.exp (-(s * t)) * M).intervalIntegrable 0 R
  calc ‖∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) * f t‖
      ≤ ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) * M := by
        refine intervalIntegral.norm_integral_le_of_norm_le hR ?_ hmaj
        filter_upwards with t
        intro _
        rw [norm_mul, Real.norm_of_nonneg (Real.exp_pos _).le]
        exact mul_le_mul_of_nonneg_left (hf t) (Real.exp_pos _).le
    _ = M * (1 - Real.exp (-(s * R))) / s := by
        rw [intervalIntegral.integral_mul_const M (fun t : ℝ => Real.exp (-(s * t)))]
        rw [integral_exp_neg_mul (ne_of_gt hs)]
        ring

end AppliedAnalysis.Laplace
