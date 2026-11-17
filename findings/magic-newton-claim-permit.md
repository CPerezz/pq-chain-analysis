---
id: magic-newton-claim-permit
title: "Magic Newton NEWT airdrop: claimOnBehalf accepted only an ECDSA signature from the eligible account, but the claim window closed on 2025-07-24 and the contract holds no NEWT, so nothing is left to forge"
project: magic-newton
status: confirmed
severity: LOW
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: none
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x95835589f6e03a9a0f3bae95ab41c75122101fc8"
  implementation: null
  name: NewtonClaim
  upgradeable: "no"
  admin: owner Safe 0xcd14dc086511f33f91093410cdd0f3eab9ee8beb (3 of 8; pause, withdraw after endTime; read at block 26,431,214)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-07-24
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: none needed; the claim window (immutable endTime 2025-07-24) has closed and the balance is zero
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/magic-newton-claim-permit/classification.jsonl
  - evidence/magic-newton-claim-permit/onchain.json
  - evidence/magic-newton-claim-permit/activity.json
  - evidence/magic-newton-claim-permit/source-excerpts.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

NewtonClaim (`0x95835589…`) distributed the NEWT airdrop from a Merkle root. Besides `claim()` by the eligible account
itself, `claimOnBehalf` let anyone submit an ECDSA signature from the eligible account directing the tokens to another
beneficiary (PQ-1). Both paths are restricted to the claim window, whose immutable `endTime` passed on 2025-07-24, and
the contract holds 0 NEWT, so a quantum attacker can no longer take anything through it. Rated LOW, step 1: no activity
in the last 12 months and nothing held.

## Mechanism

- `claimOnBehalf(index, account, beneficiary, amount, merkleProof, v, r, s)` (`src/NewtonClaim.sol`) is `whenNotPaused
  inWindow`; `ClaimPermit._verifyClaimPermit` hashes `(index, account, beneficiary, amount, keccak256(merkleProof))`
  under EIP-712 and requires `ECDSA.recover(hash, v, r, s) == account` (`ClaimPermit.sol` line 51); then the Merkle
  leaf `(index, account, amount)` is checked and `amount` NEWT goes to `beneficiary`.
- `MerkleDistributor.claim(index, amount, proof)` pays `msg.sender` only and has no signature (the alternative path).
- `inWindow` reverts with `ClaimWindowFinished` once `block.timestamp > endTime`; `withdraw()` (owner) is allowed only
  after `endTime`.
- Excerpts: [`source-excerpts.md`](../evidence/magic-newton-claim-permit/source-excerpts.md).

## Evidence

- CHECKED (Sourcify, fetched 2026-11-17): `src/NewtonClaim.sol`, `ClaimPermit.sol`, `MerkleDistributor.sol` as above.
- CHECKED (on-chain read at block 26,431,607): `endTime()` = 1,753,362,000 (2025-07-24 13:00 UTC); `token()` = NEWT
  `0xd0ec028a…`, NEWT `balanceOf(contract)` = 0; `owner()` = Safe `0xcd14dc08…`; `paused()` false.
- CHECKED (on-chain read at block 26,431,214): not a proxy; Safe threshold 3 of 8; no ETH or tokens
  ([`onchain.json`](../evidence/magic-newton-claim-permit/onchain.json)).
- CHECKED (Xatu, any function): no transaction called the contract from 2026-03-18 to 2026-11-16
  ([`activity.json`](../evidence/magic-newton-claim-permit/activity.json)); the last `ecrecover` call in the precompile
  trace is on 2025-07-24, with 40,423 such transactions in the year to March 2026 (`txs_y1`,
  `data/report/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x95835589…` NewtonClaim | no | $0 | 2025-07-24 | 0 |

Nothing is exposed: the window cannot reopen (`endTime` is immutable) and the contract holds no NEWT. The NEWT token
itself was not assessed here.

## Remediation

None needed for this contract. A future Magic Newton distribution should let contract accounts claim through ERC-1271
(account code checked first) or keep claims to `msg.sender` with a Merkle proof, which is already hash-based.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-07-24) and nothing held).
- 2026-11-17 review (Review19): LOW kept, step 1. Claim window found closed (immutable `endTime` 2025-07-24) and NEWT balance zero; impact set to none, alternative to alternative-exists (`claim()` by the account), fix to none; title corrected (claimOnBehalf, not a permit).
