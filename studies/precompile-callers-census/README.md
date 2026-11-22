---
id: precompile-callers-census
title: "Which mainnet contracts call pre-quantum cryptography, in what role, and how much value moves through them"
authors: [kevaundray]
status: published
started: null
published: 2026-11-04
topic: pre-quantum-exposure
code:
  - https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/scripts
---

## Goal

Count the contracts that rely on pre-quantum cryptography when they run, say whether each is an account or an
application and whether its code can change, and measure the value that moves through them. This is the denominator
for every other study here: it says who is in scope before anyone reads a line of source.

## Setup

- **Usage:** the precompile-usage corpus made with [precompile-tracer](https://github.com/CPerezz/precompile-tracer):
  geth `callTracer` over every mainnet transaction, blocks 2.4M to 24.7M, about 56 GB of parquet at
  <https://s3-dcl1.ethquokkaops.io/evm-parquet/>. It holds successful precompile calls only.
- **Window, "the year":** blocks 22,100,000 to 24,699,999 (2025-03-22 to 2026-03-18), the last full year of the corpus.
- **State:** code, proxy slots, ETH and ERC-20 balances at block ≈26.33M (2026-11-03), read through a mainnet RPC with
  `eth_call` state overrides, and from Blockscout.
- **Value:** Xatu transfer tables on a 1-in-10 block sample, priced with DefiLlama in 30-day bins.
- Python 3.13 with `duckdb`, `pyarrow`, `pandas`, `requests`.

## Procedure

A contract counts if, as the execution context, it made a successful call to an elliptic-curve precompile (`ecrecover`
0x01, BN254 0x06 to 0x08, KZG 0x0a, BLS12-381 0x0b to 0x11, P-256 0x100), or to `modexp` 0x05 with an elliptic-curve
field or order modulus or an RSA-size modulus (1024 bits or more). The execution context is the proxy for a proxy and
the EOA for an EIP-7702 delegation.

| Step | Script | What it does |
|---|---|---|
| 1 | `01_precompile_agg.py` | Per-caller aggregates over the corpus; `modexp` moduli |
| 2 | `03_probe_callers.py`, `03b_caller_family.py` | Code and balance at head; code families (7702 delegate, EIP-1167 clone, code hash) |
| 3 | `04_families.py` | Proxy resolution, selectors and fingerprints of the logic code per family |
| 4 | `download_sample.sh`, `06_value_flows.py` | 1-in-10 transfer sample; USD value per transaction as its largest transfer |
| 5 | `blockscout.py`, `sourcify.py`, `07_classify.py` | Contract names and verified sources; then rule-based role (7702 EOA, contract wallet, application) and mutability |
| 6 | `08_holdings.py` | Current holdings |
| 7 | `09_report_tables.py` | The tables in `results/` |

## Reproduce

Check out the scripts at the commit linked in the header. Put the corpus in `~/work/xatu/precompile-usage/`, set
`ETH_RPC_URL` to a mainnet RPC that supports `eth_call` state overrides, and run the steps above in order from the
repository root of that commit. The scripts write to `data/`; the tables that were published are the ones in
`results/`.

## Results

The narrative with every table is [REPORT.md](../../REPORT.md), sections 2 and 3. Headline numbers for the year:

- Any pre-quantum check: 787,419 addresses, 32,178,616 transactions (about 5.2 % of mainnet), about $1.3T.
- `ecrecover`: 1,463,133 callers ever, 678,009 active, 30,792,126 transactions.
- Of the active `ecrecover` callers: 510,639 EIP-7702 EOAs, 122,740 contract wallets, 41,121 applications.

Tables: [`results/t1_categories.csv`](results/t1_categories.csv), [`t1_meta.csv`](results/t1_meta.csv),
[`t2_roles_mutability.csv`](results/t2_roles_mutability.csv), [`t3_value_by_role.csv`](results/t3_value_by_role.csv),
[`eth_held_by_role.csv`](results/eth_held_by_role.csv), [`chain_tx_estimate.json`](results/chain_tx_estimate.json).

## Limits

- It observes runs, not code. Signature checks done in contract code without a precompile are missed, and so are
  contracts that were not called in the window. Failed calls are not in the corpus.
- The caller is the execution context, so a library reached by `DELEGATECALL` is counted under the calling proxy.
- Usage ends on 2026-03-18, while code, proxies and holdings were read on 2026-11-03.
- Value is the largest transfer in each transaction, from a 1-in-10 sample. It measures size, not net flow, and groups
  overlap. Holdings cover about 3.9k addresses and the first 50 tokens of each; ETH balances are complete.
- Role and mutability for the long tail are heuristics (selectors, proxy slots, names).
