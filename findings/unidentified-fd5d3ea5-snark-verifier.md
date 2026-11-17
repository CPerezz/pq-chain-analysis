---
id: unidentified-fd5d3ea5-snark-verifier
title: "Unidentified shielded pool 0x428c850b: transfer and withdraw proofs are gnark Groth16 on BN254; a recovered setup trapdoor lets an attacker withdraw the pool's $157"
project: unidentified-fd5d3ea5
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xfd5d3ea58cce8da4b1606db610c8129eca278ac7"
  implementation: null
  name: gnark Groth16 verifier, transfer (unverified; pool TRANSFER_VERIFIER)
  upgradeable: "no"
  admin: none; the pool 0x428c850be686e933dd641ee43574ba35f550c94c holds it as an immutable, changeable by upgrading the pool (ProxyAdmin 0xb5161775ded280eb0e8e07ed2eadf7f1d324f142, owner Safe 0xf31620437c3b2aec737d12b325d56c546d0c6646, 2 of 3)
  value_usd: 157
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-07-26
  txs_30d: 0
- address: "0xb5ebd94b3c69c3449a64e67b055298e588f2434a"
  implementation: null
  name: gnark Groth16 verifier, withdraw (unverified; pool WITHDRAW_VERIFIER)
  upgradeable: "no"
  admin: as for the transfer verifier (pool upgrade by Safe 0xf31620437c3b2aec737d12b325d56c546d0c6646)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
families: []
fix:
  layer: contract-upgrade
  who_acts: owner Safe 0xf31620437c3b2aec737d12b325d56c546d0c6646 (2 of 3) of ProxyAdmin 0xb5161775ded280eb0e8e07ed2eadf7f1d324f142, upgrading pool proxy 0x428c850be686e933dd641ee43574ba35f550c94c to an implementation with hash-based verifiers
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-fd5d3ea5-snark-verifier/classification.jsonl
  - evidence/unidentified-fd5d3ea5-snark-verifier/onchain.json
  - evidence/unidentified-fd5d3ea5-snark-verifier/activity.json
  - evidence/unidentified-fd5d3ea5-snark-verifier/source-excerpts.md
  - evidence/unidentified-fd5d3ea5-snark-verifier/review.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review10 (bytecode and on-chain review)
  ref: evidence/unidentified-fd5d3ea5-snark-verifier/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`0xfd5d3ea5…` is the transfer verifier of an unverified shielded pool at `0x428c850b…` (note commitments, nullifiers, Poseidon2 Merkle tree, three pools, relayer fees); its withdraw verifier `0xb5ebd94b…` is the same kind. Both are gnark Groth16 verifiers on BN254 (PQ-7). With the setup trapdoor, a quantum attacker can prove spends of notes that do not exist and withdraw what the pool holds: 0.0304 ETH and $102 of USDT/USDC, $157 on 2026-11-17. Rated LOW: step 4 gives MEDIUM (a 2-of-3 Safe can upgrade the pool to new verifiers), lowered by step 5 (under USD 50k).

## Mechanism

- Pool proxy `0x428c850b…` (EIP-1967, implementation `0xf176dd06…`, unverified) exposes `TRANSFER_VERIFIER()` = `0xfd5d3ea5…`, `WITHDRAW_VERIFIER()` = `0xb5ebd94b…`, `POSEIDON2()`, plus `registerUser(bytes)`, `commitments`, `nullifiers`, `merkleRoots`, `getLastRoot`, `pools`, `setPoolFees`, `claimProtocolFees`, `claimRelayerFees` (selectors resolved through the OpenChain signature database). All three addresses are PUSH20 constants in the implementation bytecode, i.e. immutables.
- Both verifiers carry `compressProof(uint256[8])` (`0x44f63692`), the selector of gnark's Solidity Groth16 export, and the BN254 field constants; every verification calls ecadd, ecmul and ecpairing.
- Users reach the pool through batched calls (sample `0x8c1568ec…`: Multicall3 `aggregate3` into the pool, selector `0x881a00d4`).

## Evidence

- CHECKED (bytecode, 2026-11-17): verifier fingerprints; implementation getters and immutables as above ([`review.json`](../evidence/unidentified-fd5d3ea5-snark-verifier/review.json)).
- CHECKED (on-chain, block 26,431,710): pool EIP-1967 implementation `0xf176dd06…` and admin `0xb5161775…`; ProxyAdmin `owner()` Safe `0xf3162043…`, threshold 2 of 3; `totalPools()` 3, `totalElements()` 552; pool creator `0x3c72eb2c…` (also the verifiers' deployer per the classification).
- CHECKED (Blockscout, 2026-11-17): pool holds 0.0304 ETH, 80.42 USDT, 21.46 USDC; last pool transaction 2026-07-26.
- CHECKED (precompile trace): transfer verifier 220 transactions in the last year, last block 24,339,519; withdraw verifier ecpairing calls, last block 24,339,528 (alltime trace). Xatu: no calls to `0xfd5d3ea5…` 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/unidentified-fd5d3ea5-snark-verifier/activity.json)); the withdraw verifier's recent activity was not measured.
- NOT ESTABLISHED: the project. Pool, implementation and verifiers are unverified; the creator, Safe owners and callers carry no labels on Blockscout; a web search for the addresses found nothing.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0xfd5d3ea5…` Groth16 verifier (transfer) | no | $157 (pool `0x428c850b…`) | 2026-07-26 | 0 |
| `0xb5ebd94b…` Groth16 verifier (withdraw) | no | (same pool) | — | — |

- Escrow: pool `0x428c850b…` holds 0.0304 ETH ($55 at $1,811.62) plus $102 of USDT and USDC, $157 on 2026-11-17.
- The withdraw verifier was not in any finding; it is added here (same pool, same mechanism).

## Remediation

- The pool's owners (Safe `0xf3162043…`, 2 of 3) upgrade the implementation to verifiers based on hash-based proofs (STARK/FRI or WHIR); the circuits' Poseidon2 commitments can stay.
- The Safe's owners are ECDSA keys (PQ-12).
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM -> LOW, step 5: escrow measured at $157 (the pool's holdings). Consumer identified as a shielded pool whose proxy a 2-of-3 Safe can upgrade (verifiers are immutables of the implementation); added the pool's withdraw verifier. Status candidate -> confirmed (bytecode fingerprint plus consumer getters and on-chain reads). Project still unidentified.
