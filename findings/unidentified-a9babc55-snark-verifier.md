---
id: unidentified-a9babc55-snark-verifier
title: "Tornado Cash fork (deployer 0x166e5650): a recovered Groth16 setup trapdoor lets anyone withdraw from its 11 mixer pools (about USD 56 left)"
project: unidentified-a9babc55
status: confirmed
severity: HIGH
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xa9babc55c7da0eb203d082af0e5c1ad2c3f03743"
  implementation: null
  name: Verifier
  upgradeable: "no"
  admin: none (no admin functions; the 11 pools embed this address as an immutable; pool owner EOA 0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a cannot repoint it)
  value_usd: 56
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-01
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: deployer and pool owner EOA 0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a (new pools with a post-quantum verifier); depositors withdraw from the old pools
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/unidentified-a9babc55-snark-verifier/classification.jsonl
  - evidence/unidentified-a9babc55-snark-verifier/onchain.json
  - evidence/unidentified-a9babc55-snark-verifier/activity.json
  - evidence/unidentified-a9babc55-snark-verifier/source-excerpts.md
  - evidence/unidentified-a9babc55-snark-verifier/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review04)
  ref: evidence/unidentified-a9babc55-snark-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: []
---

## Summary

`0xa9babc55…` is the Groth16 verifier of a Tornado Cash fork: 11 fixed-denomination mixer pools (5 USDT, 6 ETH)
deployed by EOA `0x166e5650…` call it from `withdraw`. A quantum attacker who recovers the setup trapdoor (PQ-7) can
forge withdrawal proofs for nullifiers nobody deposited and empty every pool. The pools hold about USD 56 now
(20 USDT and 0.02 ETH, block 26,431,520). Rated HIGH: CRITICAL at step 4 (pooled funds, verifier embedded immutably,
depositors cannot all be counted on to move), lowered one level at step 5 (under USD 50k).

## Mechanism

- `Verifier.verifyProof(bytes proof, uint256[6] input)` (source lines 200–233) decodes the Groth16 proof, builds
  `vk_x` from the hard-coded `verifyingKey()` with `ecAdd`/`ecMul` (precompiles 6, 7) and checks one `ecPairing`
  (precompile 8) on BN254. The six public inputs are Tornado's `root, nullifierHash, recipient, relayer, fee, refund`.
- The verifying key is byte-for-byte Tornado Cash Classic's (`alfa1` and `IC[0]` equal those in
  `0xce172ce1f20ec0b3728c9965470eaf994a03557a`, finding `tornado-groth16-verifier`), so this fork relies on Tornado's
  2020 setup ceremony; the same trapdoor forges proofs for both.
- Each pool's `withdraw(bytes,bytes32,bytes32,address,address,uint256,uint256)` (selector `0x21a0adb6`) calls
  `verifier.verifyProof` and, on success, marks the nullifier spent and pays one denomination to `recipient`. With a
  forged proof an attacker withdraws repeatedly with fresh nullifier hashes against any known root.
- Pattern PQ-7. Source excerpts: [`source-excerpts.md`](../evidence/unidentified-a9babc55-snark-verifier/source-excerpts.md).

## Evidence

- CHECKED (Blockscout-verified source, `Verifier`, pragma ^0.7.0): `verifyProof` and the hard-coded verifying key;
  no owner, no setter.
- CHECKED (Sourcify source of `0xce172ce1…`): its `alfa1` and `IC[0]` match this verifier's.
- CHECKED (precompile trace `data/agg/y1_tx_caller.parquet`, plus `eth_getTransactionByHash` on all 180 transactions in
  which the verifier called `ecPairing`, blocks 22,101,235–24,680,797): every one is a `withdraw` call to one of the
  11 pools listed below.
- CHECKED (`eth_call` at block 26,431,520): every pool returns `verifier() = 0xa9babc55…` and
  `owner() = 0x166e5650…`. In the two pool code variants (11,207 and 12,023 bytes; `0xcb498d5c…`, `0x9a9351f3…`) the
  verifier address is a constant in the runtime code, and it is not in storage slots 0–15 of `0xcb498d5c…`, so it
  cannot be repointed. INFERRED: the same for the other nine pools, which share those two code sizes. Pools are plain
  contracts, not proxies.
- CHECKED (Blockscout): the verifier and pools `0xd5f9eda2…` and `0x9a9351f3…` were created by
  `0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a`, an EOA with no name, tag or ENS name. Pool source is not verified.
- CHECKED (pool bytecode selectors, 4byte lookup): Tornado functions plus fee and ownership functions; none of the
  decoded selectors sets the verifier.
- CHECKED (on-chain read at block 26,431,214): the verifier holds nothing ([`onchain.json`](../evidence/unidentified-a9babc55-snark-verifier/onchain.json)).
- CHECKED (Xatu, any function): last transaction reaching the verifier 2026-10-01; none in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/unidentified-a9babc55-snark-verifier/activity.json)).
- CHECKED (`eth_getBalance`, USDT `balanceOf` at block 26,431,520): pool balances in
  [`escrow.json`](../evidence/unidentified-a9babc55-snark-verifier/escrow.json).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa9babc55…` Verifier | no | — (secures USD 56 in the pools) | 2026-10-01 | 0 |

Escrow (the pools the verifier releases), block 26,431,520, ETH at USD 1,811.62:

| Pool | Denomination | Deposits (`nextIndex`) | Holds | Withdrawals in trace (y1) |
|---|---|---|---|---|
| `0xcb498d5c…` | 10,000 USDT | 93 | 0.0013 USDT | 71 |
| `0xa410030e…` | 1,000 USDT | 43 | 0 | 30 |
| `0xd5f9eda2…` | 50,000 USDT | 34 | 0 | 26 |
| `0x9a9351f3…` | 0.01 ETH | 25 | 0.02 ETH | 15 |
| `0x273ae47a…` | 10 USDT | 24 | 20 USDT | 13 |
| `0x52da6d61…` | 10 ETH | 8 | 0 | 8 |
| `0x9164fbd2…` | 50 ETH | 7 | 0 | 7 |
| `0xce6e83eb…` | 5,000 USDT | 11 | 0 | 4 |
| `0xbdc351c1…` | 0.1 ETH | 14 | 0 | 4 |
| `0x4f716560…` | 1 ETH | 4 | 0 | 1 |
| `0xa369028f…` | 5 ETH | 2 | 0 | 1 |

Total held: about USD 56. The pools have moved larger sums (up to 50,000 USDT per withdrawal) but are drained now;
whatever is deposited later is exposed the same way. Tornado Cash's own pools, which share the setup, are covered by
`tornado-groth16-verifier`.

## Remediation

- Post-quantum replacement: a hash-based proof system (STARK/FRI) for the withdrawal circuit, in new pools; neither
  the verifier nor the pools can be changed in place.
- Who acts: the deployer and pool owner `0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a`, by deploying new pools; each
  depositor by withdrawing from the old pools before a CRQC exists. No protocol change is needed or would help.
- Users: withdraw any remaining notes now; do not deposit into these pools.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review04): CRITICAL -> HIGH, step 5: the consumer is identified as 11 Tornado Cash fork pools (immutable verifier, owner EOA 0x166e5650) holding about USD 56 at block 26,431,520; step 4 alone would be CRITICAL. Evidence level bytecode -> source-read (verifier source is Blockscout-verified); status candidate -> confirmed.
