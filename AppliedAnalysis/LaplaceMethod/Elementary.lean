import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import AppliedAnalysis.LaplaceMethod.Defs

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

theorem integral_exp_neg_mul {s R : ℝ} (hs : s ≠ 0) :
    ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = (1 - Real.exp (-(s * R))) / s := by
  let F : ℝ → ℝ := fun t => -(1 / s) * Real.exp (-(s * t))
  have hderivAt : ∀ t, HasDerivAt F (Real.exp (-(s * t))) t := by
    intro t
    have h1 : HasDerivAt (fun x : ℝ => -(s * x)) (-s) t := by
      simpa using ((hasDerivAt_id t).const_mul s).neg
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
    have h5 : HasDerivAt F (Real.exp (-(s * t))) t := by
      rw [← h4]
      exact h3
    exact h5
  have hderiv : deriv F = fun t : ℝ => Real.exp (-(s * t)) := by
    funext t
    exact (hderivAt t).deriv
  have hdiff : ∀ x ∈ Set.uIcc (0 : ℝ) R, DifferentiableAt ℝ F x := by
    intro x _
    exact (hderivAt x).differentiableAt
  have hcont : ContinuousOn (fun t : ℝ => Real.exp (-(s * t))) (Set.uIcc (0 : ℝ) R) := by
    continuousOn_iff_continuousAt.mpr
    intro _ _
    exact (by fun_prop : Continuous (fun t : ℝ => Real.exp (-(s * t)))).continuousAt
  have hmain : ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = F R - F 0 := by
    simpa [show (fun t : ℝ => Real.exp (-(s * t))) = F' from rfl] using
      integral_deriv_eq_sub' F hderiv hdiff hcont
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
