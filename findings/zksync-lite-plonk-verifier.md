---
id: zksync-lite-plonk-verifier
title: "zkSync Lite: the BN254 PLONK block verifier can no longer release anything, because the rollup is in exodus mode and its funds moved to a claim distributor"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: none
alternative: sole
role: core
contracts:
- address: "0x5290e9582b4fb706eadf87bb1c129e897e04d06d"
  implementation: "0x57b09100e6160503abdebc76012b6c358ea4e462"
  name: Proxy → Verifier (KeysWithPlonkVerifier)
  upgradeable: "yes"
  admin: UpgradeGatekeeper 0x38a43f4330f24fe920f943409709fc9a6084c939, master Safe 0xe24f4870ab85de8e356c5fc56138587206c70d99 (1 of 1, owner Matter Labs Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828, 4 of 7)
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-05-04
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "nothing required while zkSync Lite stays in exodus mode; upgrades go through UpgradeGatekeeper 0x38a43f4330f24fe920f943409709fc9a6084c939 (master Safe 0xe24f4870ab85de8e356c5fc56138587206c70d99)"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zksync-lite-plonk-verifier/classification.jsonl
  - evidence/zksync-lite-plonk-verifier/onchain.json
  - evidence/zksync-lite-plonk-verifier/activity.json
  - evidence/zksync-lite-plonk-verifier/source-excerpts.md
  - evidence/zksync-lite-plonk-verifier/state.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify source of ZkSync implementation 0x803b96fa…; cast reads on 2026-11-17
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [zksync-blob-kzg]
---

## Summary

zkSync Lite's verifier checks PLONK proofs on BN254, so a quantum attacker with the setup trapdoor could forge block
proofs. But the zkSync Lite contract is in exodus mode: `proveBlocks`, the only caller of the block verifier, reverts,
and the remaining balances were moved to a claim distributor on 2026-05-08. A forged proof releases nothing; the
rollup contract still holds USD 23.5k (stETH) that this verifier cannot reach. Rated LOW: step 4: the path is
closed and nothing can be taken through it.

## Mechanism

- `ZkSync.proveBlocks` (implementation 0x803b96fa…, `ZkSync.sol` lines 568-601) calls
  `verifier.verifyAggregatedBlockProof(...)` on this proxy; the implementation (`PlonkCore.sol`,
  `KeysWithPlonkVerifier.sol`) checks the aggregated PLONK proof with the BN254 pairing precompile.
  `Verifier.verifyExitProof` (exit proofs for exodus withdrawals) exists in the verifier but is no longer called by
  the current `ZkSync` implementation.
- `proveBlocks` starts with `requireActive()` (`require(!exodusMode)`). `setClaimRoot` (security council) set
  `exodusMode = true` and the claim distributor; `migrateToken` sends the contract's balances to that distributor. No
  function sets `exodusMode` back to false.
- Pattern PQ-7 (trusted-setup SNARK), now on a closed path.

## Evidence

- CHECKED (verified source on Sourcify, ZkSync implementation 0x803b96fa… and verifier 0x57b09100…): the calls and
  guards above.
- CHECKED (cast, 2026-11-17): `exodusMode()` = true; `totalBlocksCommitted/Proven/Executed` = 453,633 each; verifier
  proxy implementation 0x57b09100…, EIP-1967 admin and `getMaster()` = UpgradeGatekeeper 0x38a43f43…, whose master is
  Safe 0xe24f4870… (1 of 1, owned by Safe 0x4e494334…, 4 of 7) ([`state.json`](../evidence/zksync-lite-plonk-verifier/state.json)).
- CHECKED (Blockscout, 2026-11-17): the zkSync Lite contract 0xabea9132… holds USD 23,510 (stETH USD 23,505); its
  latest logs are 50 `TokenMigrationExecuted` events on 2026-05-08.
- CHECKED (Xatu, any function): last call to the verifier on 2026-05-04, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/zksync-lite-plonk-verifier/activity.json)); `curated_contracts.csv`: 2,245 BN254
  calls in the last year.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x5290e958…` Verifier (proxy) | yes (UpgradeGatekeeper) | $0; escrow reachable $0 | 2026-05-04 | 0 |

- Escrow: the zkSync Lite contract `0xabea9132b05a70803a4e85094fd0e1800777fbef` holds USD 23.5k, but no path that
  uses this verifier can release it, so `value_usd` is 0 with basis `escrow`. Claims now go through the claim
  distributor's Merkle proofs (not a pre-quantum check of this finding).
- The draft listed a 2-member family keyed on `0x57b09100…`; the census family is the zkSync Lite `Proxy` bytecode
  (it also contains the main contract and governance), not further verifiers, so it was removed.
- Related: ZKsync Era and ZK Stack verifiers are in `zksync-plonk-fflonk-verifier`.

## Remediation

- None needed while exodus mode holds. If zkSync Lite were ever upgraded back to processing blocks, the verifier
  would need a post-quantum (STARK/FRI) replacement through the UpgradeGatekeeper.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review06): MEDIUM -> LOW, step 4: zkSync Lite is in exodus mode (`proveBlocks` reverts) and its funds moved to a claim distributor on 2026-05-08, so a forged proof releases nothing (impact funds-loss -> none). Spurious proxy-bytecode family removed; admin chain read on-chain.
