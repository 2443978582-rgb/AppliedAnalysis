import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import AppliedAnalysis.LaplaceMethod.Defs

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

theorem integral_exp_neg_mul {s R : ℝ} (hs : s ≠ 0) :
    ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = (1 - Real.exp (-(s * R))) / s := by
  have hderiv : ∀ t ∈ Set.uIcc (0 : ℝ) R,
      HasDerivAt (fun t : ℝ => -(1 / s) * Real.exp (-(s * t))) (Real.exp (-(s * t))) t := by
    intro t _
    have hlin : HasDerivAt (fun t : ℝ => -(s * t)) (-s) t := by
      simpa using ((hasDerivAt_id t).const_mul s).neg
    have hexp : HasDerivAt (fun t : ℝ => Real.exp (-(s * t)))
        (Real.exp (-(s * t)) * (-s)) t :=
      (Real.hasDerivAt_exp (-(s * t))).comp t hlin
    have hmul := hexp.const_mul (-(1 / s))
    convert hmul using 1
    field_simp
    ring
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv]
  · simp only [mul_zero, Real.exp_zero]
    field_simp
    ring
  · exact (by fun_prop : Continuous fun t : ℝ => Real.exp (-(s * t))).intervalIntegrable 0 R

end AppliedAnalysis.Laplace
