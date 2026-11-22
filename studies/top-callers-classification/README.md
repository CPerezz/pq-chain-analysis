---
id: top-callers-classification
title: "The 433 largest callers of pre-quantum cryptography, read at source level and turned into findings"
authors: [kevaundray]
status: published
started: null
published: 2026-11-17
topic: pre-quantum-exposure
code:
  - https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/scripts
---

## Goal

For the contracts that carry most of the usage, read the code and say what the pre-quantum check is for, who holds
the key, whether another path exists and whether the code can change. Then write one finding per project and
mechanism, rated by whether the exposure can be removed without a protocol change.

## Setup

- **Scope:** the 433 largest callers from [precompile-callers-census](../precompile-callers-census/): 346 applications
  and 87 wallets. The 346 applications cover 86 % of application transactions and 91 % of application value.
- **Code:** verified source from Sourcify and Blockscout, or bytecode where no source is verified.
- **State:** proxy kind and implementation, admin and owner, Safe threshold, balances, read at block 26,431,214 for
  212 of the findings and within about 750 blocks of it for the rest.
- **Activity:** Xatu, 30 days from 2026-10-16 to 2026-11-16, any function of the contract.
- State, activity and excerpts were collected on a 96-core machine; they read about 45 GB from Xatu.

## Procedure

| Step | By | What it does |
|---|---|---|
| 1 | Agents reading source or bytecode | One classification per contract: function, signer, reliance, ECDSA order, upgradeability, admin, post-quantum replacement, confidence, with the evidence in words |
| 2 | `12_state.py` | On-chain state of every classified contract at one block |
| 3 | `13_activity.py` | 30-day activity and last-active date |
| 4 | `14_excerpts.py` | Source lines around each signature or proof check |
| 5 | `15_findings.py` | Drafts one finding per project and mechanism, rated with the rubric in [`AGENTS.md`](../../AGENTS.md#severity) |
| 6 | Review passes | A second read of each finding against source and chain; corrections are in each finding's History |

The classification working files (`data/curation/`) are at
<https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation>, and the
raw reads behind each finding are linked from the finding as `evidence.raw`.

## Reproduce

Step 1 was done by hand and is an input: start from the classification files linked above. Then check out the
scripts at the commit in the header and run `12_state.py`, `13_activity.py`, `14_excerpts.py` and `15_findings.py` in
that order from the repository root of that commit, with `ETH_RPC_URL` set. `15_findings.py` never overwrites an
existing finding.

## Results

- 225 findings, filed in [`findings/`](../../findings/). The 217 that are confirmed or
  candidates cover 555 contracts. 202 are
  confirmed, 15 are candidates and 8 are not affected. Confirmed and candidate findings are rated CRITICAL 2, HIGH 18,
  MEDIUM 96, LOW 101.
- Of the 346 applications, 34 offer a real alternative path, 117 can only rotate keys, 96 depend on the check alone,
  and 99 have a verifier the consumer can repoint.
- The narrative is [REPORT.md](../../REPORT.md), sections 4 to 6.

Tables: [`results/curated_contracts.csv`](results/curated_contracts.csv) is the per-contract classification with a
year of usage. The `curated_by_*`, `curated_*_x_*`, `curated_top*` and `curated_coverage` tables in
[`results/`](results/) are its breakdowns. [`permit_tokens_market_cap.csv`](results/permit_tokens_market_cap.csv) and
[`l2_tvs_by_state_validation.csv`](results/l2_tvs_by_state_validation.csv) back two tables of the report.

## Limits

- The classifications were produced by agents. Of the 433 rows, 65 are low confidence; among the 346 applications the
  split is 209 high, 75 medium, 62 low.
- Everything here was read, nothing was executed: 186 findings rest on verified source, 38 on bytecode, 1 on a trace.
- "Immutable" means the code cannot change. Keys or verifier addresses may still be settable.
- A value is what the contract holds, what a forged message could release elsewhere, or a token's market cap as an
  upper bound. Each finding says which.
