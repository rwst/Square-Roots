# Certifying this development with `leanprover/comparator`

The Lean development in `SZ/` proves the lettered results of

> R. Stephan, *Even integral parts of powers of square roots*,
> [`doi:10.13140/RG.2.2.32215.43682`](https://www.researchgate.net/publication/413520035_Even_integral_parts_of_powers_of_square_roots).

Reading 4400 lines of Lean is not how one checks that claim. `lake test` runs
[`leanprover/comparator`](https://github.com/leanprover/comparator), which reduces the
check to reading one 130-line file, `Challenge.lean`.

## What is certified

`Challenge.lean` states the paper's results against Mathlib alone and proves none of them
(every proof is `sorry`). `Solution.lean` imports the development. Comparator builds each
in a `landrun` sandbox, exports both environments with `lean4export`, and verifies that

1. the ten theorems named in `comparator.json` have, in the solution, **exactly** the
   statements the challenge gives them — including every definition those statements
   mention, compared constant by constant;
2. their proofs use no axiom outside `propext`, `Quot.sound`, `Classical.choice`
   (Lean's three standard axioms — no literature axiom, no `native_decide`, no `sorry`);
3. the whole solution environment is re-accepted by the Lean kernel.

The ten theorems:

| Lean identifier                              | paper                                  |
| :------------------------------------------- | :------------------------------------- |
| `SZ.sqrtTwo_mem_S`                           | Proposition 2.3 — `√2 ∈ 𝒮`             |
| `SZ.sqrtThree_mem_MahlerZ`                   | **Theorem A** — `√3 ∈ 𝒵`               |
| `SZ.sqrtThree_notMem_S`                      | Theorem A, complementary form           |
| `SZ.sqrt_natCast_mem_S_iff`                  | **Theorem B** — `√m ∈ 𝒮 ↔ m = 2`       |
| `SZ.mem_MahlerZ_of_three_le`                 | Theorem B, the cells `m ≥ 9`            |
| `SZ.sqrt_mem_MahlerZ_of_four_le`             | Theorem B, the printed uniform route    |
| `SZ.exists_dvd_floor_sqrt`                   | **Theorem C** — `p ∣ ⌊ξ √mⁿ⌋`          |
| `SZ.exists_eventually_composite_sqrt`        | Theorem C, compositeness corollary      |
| `SZ.continuum_le_mk_witnesses_sqrtThree`     | **Theorem 9.1**, cardinality half       |
| `SZ.exists_transcendental_witness_sqrtThree` | Theorem 9.1, transcendence half         |

What is *not* certified is what the paper already flags as unformalized: the thickness
computation of §4.1 and all of §8. Appendix A of the paper indexes the remaining
formalized statements — the reduction, the covering induction, the tail hygiene, the
individual cells — which `lake build` checks but comparator does not compare.

`comparator.json` has no `definition_names`: nothing is left open for a solution to fill
in, so the "definition hole" caveat of comparator's README does not apply here.

## Running it

Three binaries are needed. Two come from this project's dependencies:

```sh
lake build comparator lean4export
```

The third, `landrun`, comparator uses to sandbox every build; it is Linux-only (it uses
Landlock) and has to be installed once by hand:

```sh
git clone https://github.com/Zouuup/landrun && cd landrun
go build -o ~/.local/bin/landrun cmd/landrun/main.go
```

Then

```sh
lake test
```

which ends in `Your solution is okay!`. Each binary is found on `PATH` or in the usual
`.lake` location, and each can be overridden: `COMPARATOR_BIN`,
`COMPARATOR_LEAN4EXPORT`, `COMPARATOR_LANDRUN`. To run a different config,
`lake test -- other.json`.

For the strongest form of the guarantee, comparator's README asks that the run be
confined further, against a Landlock escape:

```sh
systemd-run --property=RestrictAddressFamilies=~AF_UNIX --user --pty -E PATH="$PATH" \
  --working-directory "$(pwd)" -- bash -c 'lake env .lake/packages/comparator/.lake/build/bin/comparator comparator.json'
```

## Reading `Challenge.lean`

The file is meant to be read, so it is worth saying what to look for.

* **The two definitions.** `SZ.MahlerZ` is `𝒵` of equation (1.1) and `SZ.S` is its
  complement `𝒮` in `(1, ∞)`; both are repeated verbatim from `SZ/Defs.lean`. If they say
  what the paper says, the ten theorems say what the paper says — comparator guarantees
  the development cannot have replaced them with anything else.
* **Everything else is inline.** In particular the witness set `W` of Theorem 9.1 is
  written out rather than referred to by its name `SZ.witnessSet` in the development. The
  reason is mechanical, not mathematical: Lean lifts a nested proof out of a `def`'s body
  into an auxiliary constant, and the *name* of that constant records which declaration of
  the enclosing module first needed it — `SZ.valS._proof_1`, as it happens, from
  `SZ/CoverTree.lean`. A challenge cannot reproduce such a name honestly, so the
  development carries `SZ.continuum_le_mk_witnesses_sqrtThree`, the same bound with the
  set spelled out. A theorem's *type* is never rewritten this way, so the inline form
  compares cleanly.
* **The deviations from the printed statements** are the ones Appendix A of the paper
  records, and they all make the Lean statement *stronger* or equal: Theorem C and
  Theorem 9.1 produce `ξ > 0` where the paper asks only for `ξ ≠ 0`; "composite" is an
  explicit factorization with both factors `> 1`; and Theorem B's cells `m ≥ 9` are
  certified in the sharper form `3 ≤ α → α ∈ 𝒵`, valid for every real `α`, not just for
  square roots of integers.

## Trust boundary

Comparator's guarantee is conditional on the assumptions listed in its README: that
`lakefile.lean`, `comparator.json` and the transitive imports of `Challenge.lean` (here:
Mathlib) are trusted, that `landrun` sandboxes correctly, that the Lean kernel is correct,
and that the run is not under a privileged user. Note the second of those imports:
`Challenge.lean` imports six Mathlib modules and nothing from `SZ/`, and no module of
`SZ/` imports `Challenge.lean` — the two sides meet only inside comparator.

`enable_nanoda` is `false`. Setting it to `true` and putting `nanoda_bin` on `PATH`
re-checks the solution with the independent
[nanoda](https://github.com/ammkrn/nanoda_lib) kernel, weakening assumption 5 to "the Lean
*or* the nanoda kernel is correct".
