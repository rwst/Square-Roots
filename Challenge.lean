/-
(C) 2026 Ralf Stephan, in collaboration with Claude Code.
Released under CC0 1.0 Universal (public-domain dedication).
See https://creativecommons.org/publicdomain/zero/1.0/
-/
import Mathlib.Algebra.AlgebraicCard
import Mathlib.Algebra.Order.Archimedean.Real.Basic
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Algebra.Ring.Parity
import Mathlib.Analysis.Real.Sqrt
import Mathlib.SetTheory.Cardinal.Continuum

/-!
# The trusted statement of record

The lettered results of

> R. Stephan, *Even integral parts of powers of square roots*,
> `doi:10.13140/RG.2.2.32215.43682`,

stated against Mathlib alone and left unproved.  This module is what
`leanprover/comparator` reads as the *challenge*; `Solution.lean` re-exports the
development of `SZ/` as the *solution*, and `lake test` checks that the latter proves
exactly the statements below, from Lean's three standard axioms and nothing else.  See
`COMPARATOR.md`.

Nothing in `SZ/` imports this file, and this file imports nothing from `SZ/`: that
independence is the point.  Everything the statements mention is either Mathlib's or
defined here — the two definitions `MahlerZ` and `S`, one-liners repeated verbatim from
`SZ/Defs.lean`.  So `comparator.json` needs no `definition_names`: there is no hole for a
solution to fill.

Only `𝒵` and `𝒮` are repeated because only they carry mathematical content that a reader
has to check against the paper.  Everything else is spelled out inline — in particular the
witness set `W` of Theorem 9.1, whose Lean home `SZ.witnessSet` is a `def` and so cannot
be repeated identically here: Lean lifts the nested `(3 : ℝ)` instance proof out of a
definition's body into an auxiliary constant whose *name* depends on which declaration of
the enclosing module happened to need it first.  `SZ.continuum_le_mk_witnesses_sqrtThree`
states the same bound with the set written out, and a theorem's type is never rewritten
that way.

## The ten certified statements

| statement                                    | paper                                  |
| :------------------------------------------- | :------------------------------------- |
| `SZ.sqrtTwo_mem_S`                           | Proposition 2.3 (`√2 ∈ 𝒮`)             |
| `SZ.sqrtThree_mem_MahlerZ`                   | **Theorem A** (`√3 ∈ 𝒵`)               |
| `SZ.sqrtThree_notMem_S`                      | Theorem A, complementary form           |
| `SZ.sqrt_natCast_mem_S_iff`                  | **Theorem B** (`√m ∈ 𝒮 ↔ m = 2`)       |
| `SZ.mem_MahlerZ_of_three_le`                 | Theorem B, the cells `m ≥ 9`            |
| `SZ.sqrt_mem_MahlerZ_of_four_le`             | Theorem B, the printed uniform route    |
| `SZ.exists_dvd_floor_sqrt`                   | **Theorem C** (`p ∣ ⌊ξ √mⁿ⌋`)          |
| `SZ.exists_eventually_composite_sqrt`        | Theorem C, the compositeness corollary  |
| `SZ.continuum_le_mk_witnesses_sqrtThree`     | **Theorem 9.1**, cardinality half       |
| `SZ.exists_transcendental_witness_sqrtThree` | Theorem 9.1, transcendence half         |

The conventions are those of the paper's Section 1.1: `⌊·⌋` is the floor, `ξ` ranges over
nonzero reals of either sign, and the quantifier is `n ≥ 1`.
-/

namespace SZ

/-- **Dubickas's set `𝒵`**: the reals `α > 1` for which some nonzero real `ξ` makes every
integral part `⌊ξ αⁿ⌋`, `n ≥ 1`, even.  Equation (1.1) of the paper. -/
def MahlerZ : Set ℝ :=
  {α : ℝ | 1 < α ∧ ∃ ξ : ℝ, ξ ≠ 0 ∧ ∀ n : ℕ, 1 ≤ n → Even ⌊ξ * α ^ n⌋}

/-- **Dubickas's set `𝒮`**: the complement of `𝒵` in `(1, ∞)`. -/
def S : Set ℝ := {α : ℝ | 1 < α} \ MahlerZ

/-! ## The `m = 2` cell -/

/-- **Proposition 2.3.**  `√2 ∈ 𝒮` — the one base whose restricted-digit set collapses to
a point.  This is the whole `𝒮` side of Theorem B. -/
theorem sqrtTwo_mem_S : Real.sqrt 2 ∈ S := sorry

/-! ## Theorem A -/

/-- **Theorem A.**  `√3 ∈ 𝒵`, answering Problem 3 of Dubickas's paper: there is a nonzero
real `ξ` with `⌊ξ (√3)ⁿ⌋` even for every `n ≥ 1`. -/
theorem sqrtThree_mem_MahlerZ : Real.sqrt 3 ∈ MahlerZ := sorry

/-- **Theorem A**, complementary form: `√3 ∉ 𝒮`. -/
theorem sqrtThree_notMem_S : Real.sqrt 3 ∉ S := sorry

/-! ## Theorem B -/

/-- **Theorem B.**  For an integer `m ≥ 2`, `√m ∈ 𝒮` if and only if `m = 2`. -/
theorem sqrt_natCast_mem_S_iff {m : ℕ} (hm : 2 ≤ m) : Real.sqrt m ∈ S ↔ m = 2 := sorry

/-- **Theorem B, the cells `m ≥ 9`**, in the sharper form the development proves them:
every real `α ≥ 3` lies in `𝒵` (Dubickas's Theorem 1(i), after Tijdeman, reproved here
rather than cited). -/
theorem mem_MahlerZ_of_three_le {α : ℝ} (hα : 3 ≤ α) : α ∈ MahlerZ := sorry

/-- **Theorem B by the printed proof**: the uniform greedy puts `√m` in `𝒵` for every
non-square `m ≥ 4`, without the shortcut through `[3, ∞) ⊆ 𝒵`. -/
theorem sqrt_mem_MahlerZ_of_four_le {m : ℕ} (hm : 4 ≤ m) (hns : ¬ IsSquare m) :
    Real.sqrt m ∈ MahlerZ := sorry

/-! ## Theorem C -/

/-- **Theorem C.**  Let `p ≥ 2` and let `m ≥ 3` be a non-square integer with either
(i) `p ∣ m - 1` and `m ≥ p²`, or (ii) `p ∣ m` and `(m - p)(1 + √m) > p(m - 1)`.  Then some
real `ξ ≠ 0` has `p ∣ ⌊ξ √mⁿ⌋` for every `n ≥ 1`.  (Formalized with the sharper `ξ > 0`.) -/
theorem exists_dvd_floor_sqrt (p : ℤ) (m : ℕ) (hp : 2 ≤ p) (hm : 3 ≤ m) (hns : ¬ IsSquare m)
    (hcase : (p ∣ (m : ℤ) - 1 ∧ p ^ 2 ≤ (m : ℤ)) ∨
      (p ∣ (m : ℤ) ∧ (p : ℝ) * ((m : ℝ) - 1) < ((m : ℝ) - (p : ℝ)) * (1 + Real.sqrt m))) :
    ∃ ξ : ℝ, 0 < ξ ∧ ∀ n : ℕ, 1 ≤ n → p ∣ ⌊ξ * Real.sqrt m ^ n⌋ := sorry

/-- **Theorem C, the corollary.**  Under the same hypotheses the integral parts
`⌊ξ √mⁿ⌋` are composite for every sufficiently large `n`.  *Composite* is rendered as an
explicit factorization with both factors `> 1`. -/
theorem exists_eventually_composite_sqrt (p : ℤ) (m : ℕ) (hp : 2 ≤ p) (hm : 3 ≤ m)
    (hns : ¬ IsSquare m)
    (hcase : (p ∣ (m : ℤ) - 1 ∧ p ^ 2 ≤ (m : ℤ)) ∨
      (p ∣ (m : ℤ) ∧ (p : ℝ) * ((m : ℝ) - 1) < ((m : ℝ) - (p : ℝ)) * (1 + Real.sqrt m))) :
    ∃ ξ : ℝ, 0 < ξ ∧ (∀ n : ℕ, 1 ≤ n → p ∣ ⌊ξ * Real.sqrt m ^ n⌋) ∧
      ∃ N : ℕ, 1 ≤ N ∧ ∀ n : ℕ, N ≤ n →
        ∃ a b : ℤ, 1 < a ∧ 1 < b ∧ ⌊ξ * Real.sqrt m ^ n⌋ = a * b := sorry

/-! ## Theorem 9.1 -/

/-- **Theorem 9.1, cardinality half.**  The set
`W = {ξ > 0 : ⌊ξ √3ⁿ⌋ ∈ 2ℤ for all n ≥ 1}` of witnesses for `√3` has cardinality `2^ℵ₀`. -/
theorem continuum_le_mk_witnesses_sqrtThree :
    Cardinal.continuum ≤
      Cardinal.mk {ξ : ℝ | 0 < ξ ∧ ∀ n : ℕ, 1 ≤ n → Even ⌊ξ * Real.sqrt 3 ^ n⌋} := sorry

/-- **Theorem 9.1, transcendence half.**  Problem 3 has a transcendental witness: some
transcendental `ξ ≠ 0` has `⌊ξ (√3)ⁿ⌋` even for every `n ≥ 1`. -/
theorem exists_transcendental_witness_sqrtThree :
    ∃ ξ : ℝ, ξ ≠ 0 ∧ Transcendental ℚ ξ ∧
      ∀ n : ℕ, 1 ≤ n → Even ⌊ξ * Real.sqrt 3 ^ n⌋ := sorry

end SZ
