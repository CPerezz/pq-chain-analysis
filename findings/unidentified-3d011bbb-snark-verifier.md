---
id: unidentified-3d011bbb-snark-verifier
title: "Not affected: EOA 0x3d011bbb… only sent plain ETH transfers to precompile addresses; no SNARK verification"
project: unidentified-3d011bbb
status: not-affected
severity: NONE
patterns: []
primitives: [bn254]
trigger: none
impact: none
alternative: sole
role: auxiliary
contracts:
- address: "0x3d011bbbceef340d8c9c0f44ef7b84a06da1fc9c"
  implementation: null
  name: none (EOA, no code)
  upgradeable: "no"
  admin: EOA key holder (no code)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-10-19
  txs_30d: 1
families: []
fix:
  layer: none
  who_acts: nobody; no pre-quantum verification exists here
  protocol_change: not-needed
evidence:
  level: trace
  links:
  - evidence/unidentified-3d011bbb-snark-verifier/classification.jsonl
  - evidence/unidentified-3d011bbb-snark-verifier/onchain.json
  - evidence/unidentified-3d011bbb-snark-verifier/activity.json
  - evidence/unidentified-3d011bbb-snark-verifier/source-excerpts.md
  - evidence/unidentified-3d011bbb-snark-verifier/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review02 (registry review)
  ref: evidence/unidentified-3d011bbb-snark-verifier/notes.md
  date: 2026-11-17
  verdict: refuted
  rating: NONE
related: []
---

## Summary

The census listed this address because the precompile trace attributed BN254 `ecadd`/`ecmul` calls to it. It is an
EOA with no code, and those "calls" are its own transactions sent straight to the precompile addresses with ETH and
empty calldata. Nothing verifies a proof or signature, and nothing is gated or held on behalf of others, so there is no
post-quantum exposure beyond the account's own key. Not affected (NONE).

## Mechanism

None. The 11 traced transactions (blocks 24,128,228–24,160,772) are type-2 transfers from `0x3d011bbb…` to `0x…02`
(sha256), `0x…03` (ripemd160), `0x…06` (ecadd) and `0x…07` (ecmul), each with 0.0003–0.001 ETH and no input; the
precompile runs on empty input and the ETH stays at the precompile address. There is no `ecpairing` call and no
contract involved.

## Evidence

- CHECKED (`data/agg/y1_tx_caller.parquet`): 11 transactions, sha256 ×5, ecmul ×4, ecadd ×1, ripemd160 ×1, with gas
  used 21,060–27,000 (a bare transfer plus the precompile's base cost).
- CHECKED (`cast tx`/`cast receipt`, four of them, [`notes.md`](../evidence/unidentified-3d011bbb-snark-verifier/notes.md)):
  `from` = `0x3d011bbb…`, `to` = the precompile address, value 1e15 or 3e14 wei, empty calldata.
- CHECKED (latest block on 2026-11-17): no code, nonce 9,000, balance 2.80 ETH (the account's own funds,
  [`onchain.json`](../evidence/unidentified-3d011bbb-snark-verifier/onchain.json) at block 26,431,214: USD 5,074).
- CHECKED (Xatu, [`activity.json`](../evidence/unidentified-3d011bbb-snark-verifier/activity.json)): one transaction
  2026-10-16 to 2026-11-16 (last 2026-10-19).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x3d011bbb…` EOA (no code) | no | own funds only | 2026-10-19 | 1 |

The account's ETH is protected only by its own ECDSA key, which is out of scope (user EOAs). The `held` value was
removed: it is not exposure through a pre-quantum check.

## Remediation

None needed for this registry. The owner, like any EOA holder, protects the 2.80 ETH by moving to a post-quantum
account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review02): MEDIUM -> NONE, not-affected: the traced BN254 calls are the EOA's own ETH transfers to precompile addresses with empty calldata (transactions read with cast); no verifier, no gated value. Patterns PQ-7 removed; trigger trusted-setup -> none; impact funds-loss -> none; held value removed.
