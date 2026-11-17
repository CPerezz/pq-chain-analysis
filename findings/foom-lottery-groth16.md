---
id: foom-lottery-groth16
title: "FOOM (foom.cash): forged Groth16 proofs to FoomLottery's immutable verifiers can pay out its FOOM pool (closed and nearly empty since 2026-02)"
project: foom
status: confirmed
severity: HIGH
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xc043865fb4d542e2bc5ed5ed9a2f0939965671a6"
  implementation: null
  name: WithdrawG16Verifier
  upgradeable: "no"
  admin: none (plain contract; consumer FoomLottery 0x239af915abcd0a5dcb8566e863088423831951f8 stores it as an immutable)
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-03-02
  txs_30d: 0
- address: "0xad61d88f29dd1c598dd683ad69375cdf45fbf769"
  implementation: null
  name: Update5G16Verifier
  upgradeable: "no"
  admin: none (immutable in FoomLottery 0x239af915abcd0a5dcb8566e863088423831951f8)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-27
  txs_30d: 0
- address: "0xdbf505b7f76075f699efc66ab0868e6bbce4084c"
  implementation: null
  name: Update11G16Verifier
  upgradeable: "no"
  admin: none (immutable in FoomLottery 0x239af915abcd0a5dcb8566e863088423831951f8)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-27
  txs_30d: 0
- address: "0x26fb9b040a680e800db862d4b1479269a4cba356"
  implementation: null
  name: Update3G16Verifier
  upgradeable: "no"
  admin: none (immutable in FoomLottery 0x239af915abcd0a5dcb8566e863088423831951f8)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-27
  txs_30d: 0
- address: "0xcd6a87d333c9c3bf9302b04ad36928eec5bba587"
  implementation: null
  name: Update1G16Verifier
  upgradeable: "no"
  admin: none (immutable in FoomLottery 0x239af915abcd0a5dcb8566e863088423831951f8)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-28
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: FOOM team (deployer 0x442de4b67b9cb75f73b33df3b11f694c89f811c2; FoomLottery owner EOA 0x5f3dbd36c6c04c34da658540c7bba8261c2634d3) deploys a new lottery with post-quantum proofs; the verifiers in FoomLottery cannot be changed
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/foom-lottery-groth16
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_2.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review02 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/foom-lottery-groth16/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: []
---

## Summary

FoomLottery (`0x239af915…`) pays out FOOM only against snarkjs Groth16 proofs on BN254 (PQ-7), checked by verifier
contracts whose addresses are immutables of the lottery. With the trusted-setup trapdoor, a quantum attacker can forge a
withdraw proof for any known Merkle root and fresh nullifier and call `collect()` repeatedly to take the lottery's FOOM,
or forge tree-update proofs in `reveal()`. Neither the verifiers nor the lottery can be upgraded. The lottery was
closed by its owner on 2026-02-26 and now holds 15.3 FOOM (about USD 0.000001), so almost nothing is exposed today.
Rated HIGH: step 4 gives CRITICAL (pooled funds, verification cannot change), step 5 lowers one level because the
measured escrow is under USD 50k.

## Mechanism

- `FoomLottery.collect(_pA,_pB,_pC,_root,_nullifierHash,_recipient,_relayer,_fee,_refund,_rewardbits,_invest)` checks
  `roots[_root] > 0` and an unused nullifier, then `require(withdraw.verifyProof(_pA,_pB,_pC,[_root,_nullifierHash,_rewardbits,recipient,relayer,_fee,_refund]))`
  and transfers `betMin * (bits of 2^10, 2^16, 2^22)` FOOM (betMin = 1e6 FOOM) to `_recipient`
  (FoomLottery.sol lines 386–444). `withdraw` is `WithdrawG16Verifier` `0xc043865f…`.
- `FoomLottery.reveal(_revealSecret,_pA,_pB,_pC,_newRoot)` inserts queued bets into the tree and stores `_newRoot`
  after `updateN.verifyProof(...)` (N = 1, 3, 5, 11, 21, 44, 89, 179 by queue size; lines 526–669). Only the holder of
  the generator's committed secret can call it, so a forged update proof lets the generator (or anyone who also learns
  the secret) insert winning leaves.
- `cancelbet()` uses `CancelBetG16Verifier` (`0x64eb221c…`) to refund a queued bet.
- Each verifier's `verifyProof` is the snarkjs template: it folds the public signals into `vk_x` with `ecMul`/`ecAdd`
  and calls the pairing precompile `staticcall(..., 8, _pPairing, 768, ...)` against hard-coded `alpha`, `beta`,
  `gamma`, `delta` (e.g. `src/Withdraw.sol` lines 77–208, `src/Update5.sol` lines 83–222; see
  [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/foom-lottery-groth16/source-excerpts.md)). The trapdoor of that setup makes proofs
  of false statements verify.

## Evidence

- CHECKED (verified source, Sourcify): all five verifiers are snarkjs Groth16 verifiers calling precompile 0x08;
  FoomLottery `0x239af915…` (`src/FoomLottery.sol`) declares `withdraw`, `cancel`, `update1` … `update179` as
  `immutable` and has no function that changes them; it is not a proxy.
- CHECKED (on-chain read at block 26,431,454, 2026-11-17, [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/foom-lottery-groth16/escrow.json)):
  FoomLottery's `withdraw()`, `update1()`, `update3()`, `update5()`, `update11()` return the five verifier addresses in
  this finding; EIP-1967 implementation slot is zero; `owner()` = `0x5f3dbd36…` (no code, nonce 5); `commitHash()` = 2
  (closed); `D().betsLimit` = 0 (no new tickets); `D().commitBlock` = 24,540,485 (2026-02-26), so `adminwithdraw()` is
  allowed after block 26,642,885.
- CHECKED (same block): FoomLottery holds 15.32 FOOM, 0 ETH, 0 WETH; at Blockscout's FOOM rate (USD 4.05e-8) that is
  about USD 0.000001.
- CHECKED (Blockscout creator and transactions): all verifiers and FoomLottery were created by `0x442de4b6…`; the
  lottery's FOOM was paid out between 2026-02-26 and 2026-02-28; its last transaction is a `payOut` on 2026-03-03.
- CHECKED (on-chain read at block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/foom-lottery-groth16/onchain.json)): the
  verifiers hold nothing and have no proxy, owner or Safe.
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/foom-lottery-groth16/activity.json)): no transactions to the verifiers
  2026-10-16 to 2026-11-16; last activity 2026-02-27 to 2026-03-02.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs | Pre-quantum txs (12 months) |
|---|---|---|---|---|---|
| `0xc043865f…` WithdrawG16Verifier | no | 0 | 2026-03-02 | 0 | 2,795 |
| `0xad61d88f…` Update5G16Verifier | no | 0 | 2026-02-27 | 0 | 1,230 |
| `0xdbf505b7…` Update11G16Verifier | no | 0 | 2026-02-27 | 0 | 812 |
| `0x26fb9b04…` Update3G16Verifier | no | 0 | 2026-02-27 | 0 | 699 |
| `0xcd6a87d3…` Update1G16Verifier | no | 0 | 2026-02-28 | 0 | 294 |

Yearly counts are `txs_y1` from `studies/top-callers-classification/results/curated_contracts.csv`.

Escrow: FoomLottery `0x239af915abcd0a5dcb8566e863088423831951f8` holds 15.32 FOOM (about USD 0, block 26,431,454);
recorded as `value_usd: 0` (basis `escrow`) on the WithdrawG16Verifier entry. The lottery is closed, but `collect()`
does not check the closed state, so forged withdrawals would still pay out whatever FOOM it receives; the owner can
`reopen()` it at any time.

Siblings checked: the same lottery also uses `CancelBetG16Verifier` `0x64eb221c…`, `Update21G16Verifier`
`0xdb203504…`, `Update44G16Verifier` `0x5b7f3691…`, `Update89G16Verifier` `0x252073bd…` and `Update179G16Verifier`
`0x326b8386…` (same deployer, same template, same exposure); they are not in the census data and are not listed above.
An earlier FoomLottery `0xd5a3bbb9…` (2025-06-30, its own verifier set) holds 3,000,000 FOOM (about USD 0.12) and has
had no transaction since 2025-07-02.

## Remediation

- Post-quantum replacement: a new lottery whose withdraw, cancel and update proofs use a hash-based proof system
  (STARK/FRI or WHIR) and whose verifier addresses can be replaced; the circom/snarkjs Groth16 circuits must be
  rewritten for it.
- Who acts: the FOOM team (deployer `0x442de4b6…`, lottery owner EOA `0x5f3dbd36…`). The owner cannot change the
  verifiers; it can keep the lottery closed and, after block 26,642,885, call `adminwithdraw()` to remove the residual
  balance. No protocol change is needed.
- Users: nothing is locked for them now; a post-quantum user would need the new deployment.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review02): CRITICAL -> HIGH, step 5: escrow FoomLottery 0x239af915… measured at 15.32 FOOM (about USD 0) at block 26,431,454 after the lottery was closed on 2026-02-26; step 4 alone gives CRITICAL (immutable verifiers in an immutable consumer). Evidence level bytecode -> source-read (all five verifiers verified on Sourcify); status candidate -> confirmed.
