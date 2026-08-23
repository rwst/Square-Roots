# Square-Roots

Lean 4 formalization accompanying

> R. Stephan, *Even integral parts of powers of square roots*,
> [`doi:10.13140/RG.2.2.32215.43682`](https://www.researchgate.net/publication/413520035_Even_integral_parts_of_powers_of_square_roots).

Write `𝒵` for the set of reals `α > 1` admitting a nonzero real `ξ` with `⌊ξ αⁿ⌋` even
for every `n ≥ 1`, and `𝒮` for its complement in `(1, ∞)`. The paper proves

* **Theorem A.** `√3 ∈ 𝒵`, answering Problem 3 of Dubickas (2006).
* **Theorem B.** For an integer `m ≥ 2`, `√m ∈ 𝒮` if and only if `m = 2`.
* **Theorem C.** For `p ≥ 2` and a non-square `m ≥ 3` satisfying either
  `p ∣ m - 1` and `m ≥ p²`, or `p ∣ m` and `(m - p)(1 + √m) > p(m - 1)`,
  some `ξ ≠ 0` has `p ∣ ⌊ξ √mⁿ⌋` for every `n ≥ 1`.
* **Corollary 6.1.** `√5, √6, √7, √8 ∈ 𝒵`, so `𝒵` meets `(2,3)` — the only interval
  where an answer to Problem 5 of Dubickas (2006) could live.
* **Theorem 9.1.** The witnesses for `√3` have cardinality `2^ℵ₀`, so all but countably
  many of them are transcendental.

## Layout

| path | contents |
| :--- | :--- |
| `SZ/` | the development, eleven modules, namespace `SZ` |
| `SZ/checks/` | the five numerical cross-checks of Appendix A.2 (`…-x3`–`-x7`), plus the earlier-gate checks, in Python |
| `Challenge.lean` | the paper's results stated against Mathlib alone, unproved |
| `Solution.lean` | the development, re-exported for comparison |
| `comparator.json` | the certification config |
| `COMPARATOR.md` | what `lake test` certifies, and how to run it |

Appendix A.1 of the paper indexes the paper's statements by Lean identifier, records
where the Lean form differs from the printed one, and flags what is not formalized (the
thickness computation of §4.1, all of §8, and the remark of §5.1). Every declaration is
sorry-free and depends
on nothing beyond Lean's three standard axioms — no literature axiom, no `native_decide`.

## Building

```sh
lake build          # the development
lake test           # certify it with leanprover/comparator — see COMPARATOR.md
```

`lake test` additionally needs `lake build comparator lean4export` and a `landrun` binary;
`COMPARATOR.md` has the details.

## License

CC0 1.0 Universal (public-domain dedication); see `LICENSE`.

## Please cite

```
@misc{stephan2026evenintegralpartssquareroots,
      title={Even integral parts of powers of square roots}, 
      author={Ralf Stephan},
      abstract="Dubickas splits the half-line $(1,+\infty)$ into the set $\mathcal{Z}$ of those
$\alpha$ for which some nonzero real $\xi$ makes every integral part
$[\xi\alpha^{n}]$ even, and its complement $\mathcal{S}$; at $\alpha=3/2$
the question of which side one is on is Mahler's. We settle the side for
every square root: $\sqrt m\in\mathcal{S}$ if and only if $m=2$. In particular
$\sqrt3\in\mathcal{Z}$, which answers Problem~3 of Dubickas's paper, with the
explicit witness $\xi=1.34160899796112665163\ldots$, and $\sqrt5$,
$\sqrt6$, $\sqrt7$, $\sqrt8$ lie in $\mathcal{Z}$ as well --- four points of
$\mathcal{Z}$ in the interval $(2,3)$, the only interval where an answer to
Dubickas's Problem~5 could live, and the first there with a proof that
are neither rational nor Pisot nor Salem. The mechanism is
Cantor-set arithmetic rather than Diophantine approximation: because
$\sqrt m^{\,2}$ is an integer, the two-scale problem collapses to a single
base-$m$ covering induction on a pair of restricted-digit expansions, which
at $m=3$ is Utz's 1951 theorem on the distance set of the Cantor
discontinuum. Replacing parity by divisibility by $p$ gives, for every
$p\ge2$ and every $m\equiv1\pmod p$ with $m\ge p^{2}$, a nonzero $\xi$ with
$p\mid[\xi\sqrt m^{\,n}]$ for all $n$, hence with all sufficiently large
integral parts composite. The cases $m=2$ (reproof), $m=3$, the cases
$m>3$, the $p$-divisibility theorem and the transcendentality theorem are
all verified in Lean~4 and depend only on Lean's three standard axioms.",
      year={2026},
      doi={10.13140/RG.2.2.32215.43682},
      url={https://www.researchgate.net/publication/413520035_Even_integral_parts_of_powers_of_square_roots}, 
}
```
