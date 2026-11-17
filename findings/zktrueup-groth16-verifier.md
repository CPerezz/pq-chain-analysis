---
id: zktrueup-groth16-verifier
title: "Term Structure zkTrue-up: rollup blocks are proven with Groth16 on BN254; a recovered setup trapdoor would let a forged state release the rollup's $1.7k, but the rollup has been idle since 2025-08-04"
project: term-structure
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce"
  implementation: null
  name: Verifier (snarkJS Groth16)
  upgradeable: "no"
  admin: none; consumer ZkTrueUp diamond 0x09e01425780094a9754b2bd8a3298f73ce837cf9 can set a new verifier (admin Safe 0xa00d50a40b1635d293c87ba36503bd2504b5d818, 4 of 6)
  value_usd: 1749
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-08-04
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Term Structure, through Safe 0xa00d50a40b1635d293c87ba36503bd2504b5d818 (4 of 6), admin and owner of the ZkTrueUp diamond 0x09e01425780094a9754b2bd8a3298f73ce837cf9
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zktrueup-groth16-verifier/classification.jsonl
  - evidence/zktrueup-groth16-verifier/onchain.json
  - evidence/zktrueup-groth16-verifier/activity.json
  - evidence/zktrueup-groth16-verifier/source-excerpts.md
  - evidence/zktrueup-groth16-verifier/review.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review10 (source and on-chain review)
  ref: evidence/zktrueup-groth16-verifier/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`Verifier` is the snarkJS Groth16 verifier that Term Structure's zkTrue-up rollup diamond uses to accept block proofs (PQ-7). With the trusted-setup trapdoor, a quantum attacker could prove a false state and withdraw what the rollup holds, but block submission is limited to the rollup's committer role, so the attacker also needs that key. The rollup has not committed a block since 2025-08-04 and holds $1,749 (2026-11-17). Rated LOW (step 1): no activity in the last 12 months and almost nothing held; step 5 gives the same.

## Mechanism

- `Verifier.verifyProof(pA, pB, pC, pubSignals)` (snarkJS template, `contracts/zkTrueUp/verifier/Verifier.sol`): field checks, then `checkPairing` with the ecmul, ecadd and ecpairing precompiles against the embedded verification key.
- The ZkTrueUp diamond's `verifyBlocks` (committer/verifier role `0x0a4ab40c…`) calls the verifier from `getVerifier()`; executed blocks then allow withdrawals of the proven balances.

Source excerpts: [`source-excerpts.md`](../evidence/zktrueup-groth16-verifier/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify `Verifier.sol`): standalone, no owner, no storage.
- CHECKED (on-chain, 2026-11-17): diamond `getVerifier()` = `0x23369a60…`, `isEvacuMode()` false, `owner()` Safe `0xa00d50a4…` (threshold 4 of 6); diamond holds no ETH and $1,749 of tokens (WETH $1,025, USDT $600, USDC $77, DAI $30, WBTC $17, Blockscout) ([`review.json`](../evidence/zktrueup-groth16-verifier/review.json)).
- CHECKED (Blockscout): the diamond's last transactions are `commitBlocks`/`verifyBlocks`/`executeBlocks` by `0x0a4ab40c…` on 2025-08-04.
- CHECKED (external, L2BEAT Term Structure page): archived; the admin multisig `0xa00d50a4…` can update the main and the evacuation verifier and upgrade the diamond without delay.
- CHECKED (precompile trace, last year): 151 transactions with ecpairing (`txs_y1`, window ending March 2026); Xatu: none 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/zktrueup-groth16-verifier/activity.json)).
- NOT READ: the evacuation verifier's address (`getEvacuator()` reverted); it is not in the census.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x23369a60…` Verifier | no | $1,749 (ZkTrueUp diamond) | 2025-08-04 | 0 |

- Escrow: ZkTrueUp diamond `0x09e01425…`, $1,749 on 2026-11-17.

## Remediation

- If the rollup resumes, Term Structure's Safe `0xa00d50a4…` points the diamond at a hash-based (STARK/FRI) verifier, and replaces the evacuation verifier too.
- The Safe's owners are ECDSA keys (PQ-12).
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-08-04) and nothing held).
- 2026-11-17 review (Review10): LOW confirmed, step 1. Escrow measured ($1,749 in the ZkTrueUp diamond) and the verifier's admin path read on-chain (diamond `getVerifier()`, Safe 4 of 6).
