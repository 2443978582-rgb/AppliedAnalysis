import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import AppliedAnalysis.LaplaceMethod.Defs

noncomputable section

namespace AppliedAnalysis.Laplace

open MeasureTheory Filter
open scoped Topology

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

theorem integral_pow_mul_exp (n : ℕ) {s : ℝ} (hs : 0 < s) :
    Tendsto (fun R : ℝ => ∫ t in (0 : ℝ)..R, t ^ n * Real.exp (-(s * t))) atTop
      (𝓝 ((n.factorial : ℝ) / s ^ (n + 1))) := by
  have hInt : IntegrableOn (fun t : ℝ => t ^ n * Real.exp (-(s * t))) (Set.Ioi 0) := by
    have h := integrableOn_rpow_mul_exp_neg_mul_rpow (p := 1) (s := (n : ℝ)) (b := s)
      (by
        have h0 : (0 : ℝ) ≤ (n : ℝ) := by positivity
        linarith)
      (by norm_num) hs
    refine h.congr_fun (fun t _ => ?_) measurableSet_Ioi
    simp only [Real.rpow_one, Real.rpow_natCast, neg_mul]
  have hIoi : ∫ t : ℝ in Set.Ioi 0, t ^ n * Real.exp (-(s * t))
      = (n.factorial : ℝ) / s ^ (n + 1) := by
    have hcongr : ∫ t : ℝ in Set.Ioi 0, t ^ n * Real.exp (-(s * t))
        = ∫ t : ℝ in Set.Ioi 0, t ^ (n : ℝ) * Real.exp (-(s * t)) := by
      refine setIntegral_congr_fun measurableSet_Ioi (fun t _ => ?_)
      rw [Real.rpow_natCast]
    rw [hcongr]
    have hmain := Real.integral_rpow_mul_exp_neg_mul_Ioi (a := (n : ℝ) + 1) (r := s)
      (by positivity) hs
    have hexp : ((n : ℝ) + 1 - 1) = (n : ℝ) := by ring
    rw [hexp, Real.Gamma_nat_eq_factorial] at hmain
    rw [hmain]
    have hcast : (n : ℝ) + 1 = ((n + 1 : ℕ) : ℝ) := by push_cast; ring
    rw [hcast, Real.rpow_natCast, one_div_pow]
    ring
  have hT := intervalIntegral_tendsto_integral_Ioi
    (f := fun t : ℝ => t ^ n * Real.exp (-(s * t))) (μ := volume) 0 hInt tendsto_id
  simpa [hIoi] using hT

end AppliedAnalysis.Laplace
