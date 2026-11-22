---
id: bytecode-fingerprint-scan
title: "Static scan of deployed bytecode for curve constants, lattice verifiers and fixed-gas ecrecover calls"
authors: [kevaundray]
status: published
started: null
published: 2026-11-04
topic: pre-quantum-exposure
code:
  - https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/scripts
---

## Goal

Look at code instead of runs: give a lower bound for elliptic-curve use that the precompile census cannot see, find
the post-quantum (lattice) signature verifiers already on mainnet, and find contracts that call `ecrecover` with a
hard-coded 3,000 gas.

## Setup

- Xatu `canonical_execution_contracts`, every partition from genesis to head, read from
  <https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/>.
- Runtime code is kept only for contracts created at block 18,000,000 (August 2023) or later: 2.48M unique bytecodes.
  Older contracts are indexed without their code.
- Python 3.13 with `duckdb`, `pyarrow`, `pandas`.

## Procedure

| Step | Script | What it does |
|---|---|---|
| 1 | `02_contracts_pass.py` | One pass over the contracts table, read remotely or from partitions fetched with `download_xatu.sh`: address, block, deployer, factory, code hash; the code of the first contract per code hash |
| 2 | `code_features.py`, `05_code_scan.py` | Searches each unique bytecode for fixed byte sequences |

The byte sequences: field and group constants of secp256k1 (including the `n/2` malleability bound), P-256, BN254,
BLS12-381 and ed25519; the STARK field; Falcon and ML-DSA NTT tables and moduli; and `PUSH1 0x01 PUSH2 0x0bb8` followed
by `STATICCALL` or `CALL`, which is a call to `ecrecover` with exactly 3,000 gas.

A contract is called a lattice verifier only when it carries a twiddle-factor or zeta table. A small modulus constant
alone (12289 or 8380417) matched unrelated contracts.

## Reproduce

Check out the scripts at the commit linked in the header and run, from the repository root of that commit,
`python scripts/02_contracts_pass.py 0 17999`, then `python scripts/02_contracts_pass.py 18000 <head/1000>`, then
`python scripts/05_code_scan.py`.

## Results

Reported in [REPORT.md](../../REPORT.md), section 2 (notes and "Lattice (and other PQ) on mainnet"):

- Six lattice verifiers on mainnet, with about 13 calls between them: [`results/lattice_contracts.csv`](results/lattice_contracts.csv).
- 44,085 unique bytecodes (52,817 contracts) embed the secp256k1 `n/2` constant. The same count is 3,803 contracts for
  BN254, 230 for P-256 and 220 for BLS12-381.
- The exact `staticcall(3000, 0x01, …)` sequence appears in 3 unique codes.

## Limits

- Only code deployed since block 18,000,000 is scanned.
- A fixed byte sequence finds one encoding of a call. The same call compiled differently is missed.
- The scan output itself is not published: the three fixed-gas codes are counted in the report but their addresses
  are not in `results/`.
- Activity of the six lattice verifiers comes from Blockscout internal transactions, not from the scan.
