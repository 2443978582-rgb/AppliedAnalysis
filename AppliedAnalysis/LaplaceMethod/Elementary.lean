import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import AppliedAnalysis.LaplaceMethod.Defs

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

theorem integral_exp_neg_mul {s R : ℝ} (hs : s ≠ 0) :
    ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = (1 - Real.exp (-(s * R))) / s := by
  let F : ℝ → ℝ := fun t => -(1 / s) * Real.exp (-(s * t))
  have hF_deriv : ∀ t ∈ Set.uIcc (0 : ℝ) R, HasDerivAt F (Real.exp (-(s * t))) t := by
    intro t _
    have h1 : HasDerivAt (fun x : ℝ => -(s * x)) (-s) t := by
      simpa using (hasDerivAt_id t).const_mul s |>.neg
    have h2 : HasDerivAt (fun x : ℝ => Real.exp (-(s * x)))
        (Real.exp (-(s * t)) * (-s)) t := by
      exact (Real.hasDerivAt_exp (-(s * t))).comp t h1
    have h3 : HasDerivAt (fun x : ℝ => -(1 / s) * Real.exp (-(s * x)))
        ((-(1 / s) : ℝ) * (Real.exp (-(s * t)) * (-s))) t :=
      h2.const_mul (-(1 / s))
    have h4 : (-(1 / s) : ℝ) * (Real.exp (-(s * t)) * (-s)) = Real.exp (-(s * t)) := by
      ring_nf
      field_simp [hs]
      ring
    have h6 : HasDerivAt F (Real.exp (-(s * t))) t := by
      rw [← h4]
      exact h3
    exact h6
  have hint : IntervalIntegrable (fun t : ℝ => Real.exp (-(s * t))) volume 0 R := by
    exact (by fun_prop : Continuous (fun t : ℝ => Real.exp (-(s * t)))).intervalIntegrable 0 R
  have hmain : ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = F R - F 0 :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hF_deriv hint
  have hF0 : F 0 = -(1 / s) := by
    simp only [F, Real.exp_zero]
    ring
  have hgoal : F R - F 0 = (1 - Real.exp (-(s * R))) / s := by
    rw [hF0]
    have hF_R : F R = -(1 / s) * Real.exp (-(s * R)) := by rfl
    rw [hF_R]
    field_simp [hs]
    ring
  rw [hmain]
  exact hgoal

end AppliedAnalysis.Laplace
