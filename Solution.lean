/-
(C) 2026 Ralf Stephan, in collaboration with Claude Code.
Released under CC0 1.0 Universal (public-domain dedication).
See https://creativecommons.org/publicdomain/zero/1.0/
-/
import SZ.Cells
import SZ.CoverTree
import SZ.ThmC

/-!
# The development, as `leanprover/comparator` sees it

The *solution* module of the challenge/solution pair: it re-exports every declaration of
`SZ/` that `Challenge.lean` states, together with the proofs.  Three imports suffice —
`SZ.Cells`, `SZ.CoverTree` and `SZ.ThmC` are the three leaves of the import graph, and
between them they pull in all eleven modules of `SZ/`:

* `SZ.Cells` → `SZ.SliceHygiene` → `SZ.Slice` → `SZ.Defs`, `SZ.DigitParity`;
  and `SZ.SqrtTwo`, `SZ.SqrtThree`, `SZ.Tijdeman`
* `SZ.CoverTree` → `SZ.SqrtThree` → `SZ.CoverGame` → `SZ.DigitParity`
* `SZ.ThmC` → `SZ.SliceHygiene`

Every module is sorry-free and free of `native_decide`, so one solution library suffices:
there is no expensive or axiom-bearing corner to quarantine.  Run the comparison with
`lake test`; see `COMPARATOR.md`.
-/
