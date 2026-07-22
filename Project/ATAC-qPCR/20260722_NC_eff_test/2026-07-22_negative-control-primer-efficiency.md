---
title: "Negative-control primer efficiency"
subtitle: "qPCR efficiency of four non-accessible-locus primer pairs (Maria gDNA, PowerUp SYBR)"
author:
  - name: "Joey Choi"
    affiliation: University of Zurich
    email: wonhyung.choi@uzh.ch
date: last-modified
---

# Goal

Characterize the qPCR amplification efficiency and melt behavior of the four **negative-control (NC) primer pairs** selected on 2026-07-16 for the ATAC-qPCR workflow — **MyoD_promoter**, **MyoD_promoter_upstream**, **RBFOX3_promoter**, **RBFOX3_enhancer** — before using them as background/floor controls.

This is an exploratory QC run to see how each pair titrates on clean reference gDNA; no fixed pass/fail cutoff is applied. Typical reference values (~90–110% efficiency, R² near 1, single melt peak) are used only as interpretation context. **Maria_GAPDH** — the reference primer pair from the 2026-07-16 PC-efficiency run — is included on the same plate as a plate-level anchor.

---

# Protocol

- **Conditions:** n = 2 technical replicates per target per input level; three-point titration **1 / 10 / 100 ng** (log₁₀ 0/1/2).
- **Targets (4 NC candidates):** MyoD_promoter, MyoD_promoter_upstream, RBFOX3_promoter, RBFOX3_enhancer; plus **Maria_GAPDH** (reference/anchor, same pair as the 2026-07-16 PC run).
- **Template:** Maria's reference gDNA (same clean template used in the 2026-07-16 PC-efficiency run).
- **Chemistry:** PowerUp SYBR Green Master Mix (2×), 20 µL reactions — 2 µL template + 2 µL primer + 10 µL 2× PowerUp + 6 µL water. _(Note: PowerUp here, not the iTaq SYBR used on the PC-efficiency plate.)_

**NC primer sequences** (from 2026-07-16 selection, mm10):

| Target                 | Forward                | Reverse              |
| ---------------------- | ---------------------- | -------------------- |
| MyoD_promoter          | AACTCCTATGCTTTGCCTGGT  | TGTCTACTCCTCCAGCCTGT |
| MyoD_promoter_upstream | AGAAGAATGGTGGCTCTCAGTC | CAGGACTGTGCTTGACTGCT |
| RBFOX3_promoter        | GCGAGCCAGCTGAATGTG     | GGGTGCCCTACAAGTCTCAC |
| RBFOX3_enhancer        | AATTCTGCTCCTTCGGCCTG   | ATATTCGGCTGCAGGACTCG |

**Plate layout.** Rows set gDNA input (A/B/C = 1/10/100 ng), two wells per target (technical duplicate). NC candidates in cols 1–2 / 4–5 / 7–8 / 10–11 of rows A–C; Maria_GAPDH anchor block in rows E–G, cols 1–2.

| Input (row) | Col 1–2       | Col 4–5                | Col 7–8         | Col 10–11       |
| ----------- | ------------- | ---------------------- | --------------- | --------------- |
| 1 ng (A)    | MyoD_promoter | MyoD_promoter_upstream | RBFOX3_promoter | RBFOX3_enhancer |
| 10 ng (B)   | MyoD_promoter | MyoD_promoter_upstream | RBFOX3_promoter | RBFOX3_enhancer |
| 100 ng (C)  | MyoD_promoter | MyoD_promoter_upstream | RBFOX3_promoter | RBFOX3_enhancer |

Reference anchor (rows E/F/G = 1/10/100 ng), cols 1–2: **Maria_GAPDH**.

**No no-template control (NTC) was included on this plate.**

**Readout.** CFX Maestro Cq export + melt. Standard curve fitted per target as Cq vs log₁₀(input); efficiency E = 10^(−1/slope) − 1.

---

# Note

_Results pending — qPCR run to be performed/analyzed. Standard curves, per-target efficiencies (slope, R², E), Cq table, and melt Tm to be added once data are exported._

**Points to watch when data comes back:**

- **Chemistry change vs. PC run.** This plate uses PowerUp SYBR; the 2026-07-16 PC-efficiency plate used iTaq SYBR. Maria_GAPDH read 100.4% efficiency on iTaq — a different anchor value here may reflect the master-mix switch rather than the template.
- **No NTC.** Without a no-template control, primer-dimer/contamination can only be inferred from single melt peaks, not formally excluded. For floor-control primers run near the detection limit, consider adding an NTC before locking the panel.
