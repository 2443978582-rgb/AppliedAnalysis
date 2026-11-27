import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import AppliedAnalysis.LaplaceMethod.Defs

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory

theorem integral_exp_neg_mul {s R : ℝ} (hs : s ≠ 0) :
    ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = (1 - Real.exp (-(s * R))) / s := by
  let F : ℝ → ℝ := fun t => -(1 / s) * Real.exp ((-s) * t)
  have hderiv : ∀ t ∈ Set.uIcc (0 : ℝ) R, HasDerivAt F (Real.exp (-(s * t))) t := by
    intro t _
    have hlin : HasDerivAt (fun x : ℝ => (-s) * x) (-s) t := by
      simpa using (hasDerivAt_id t).const_mul (-s)
    have hexp : HasDerivAt (fun x : ℝ => Real.exp ((-s) * x))
        (Real.exp ((-s) * t) * (-s)) t :=
      (Real.hasDerivAt_exp ((-s) * t)).comp t hlin
    have hconst : HasDerivAt (fun x : ℝ => -(1 / s) * Real.exp ((-s) * x))
        ((-(1 / s) : ℝ) * (Real.exp ((-s) * t) * (-s))) t :=
      hexp.const_mul (-(1 / s))
    have hne : (1 / s : ℝ) * s = 1 := by field_simp
    have hone : (-(1 / s) : ℝ) * (-s) = 1 := by
      calc (-(1 / s) : ℝ) * (-s) = (1 / s) * s := by ring
        _ = 1 := hne
    have hval : (-(1 / s) : ℝ) * (Real.exp ((-s) * t) * (-s)) = Real.exp (-(s * t)) := by
      calc (-(1 / s) : ℝ) * (Real.exp ((-s) * t) * (-s))
          = ((-(1 / s) : ℝ) * (-s)) * Real.exp ((-s) * t) := by ring
        _ = Real.exp ((-s) * t) := by rw [hone, one_mul]
        _ = Real.exp (-(s * t)) := by rw [neg_mul]
    rw [hval] at hconst
    simpa only [F] using hconst
  have hint : IntervalIntegrable (fun t : ℝ => Real.exp (-(s * t))) volume 0 R :=
    (by fun_prop : Continuous (fun t : ℝ => Real.exp (-(s * t)))).intervalIntegrable 0 R
  have hmain : ∫ t in (0 : ℝ)..R, Real.exp (-(s * t)) = F R - F 0 :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  rw [hmain]
  have hFR : F R = -(1 / s) * Real.exp ((-s) * R) := rfl
  have hF0 : F 0 = -(1 / s) := by
    simp [F]
  rw [hFR, hF0]
  simp only [neg_mul]
  field_simp [hs]
  ring

end AppliedAnalysis.Laplace
