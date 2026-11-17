---
id: adi-chain-zk-verifiers
title: "ADI Chain: with the BN254 setup trapdoor a quantum attacker can forge ADI Chain batch proofs and withdraw the USD 5.4M of ADI held in its L1 vault; ADI's governance can swap the verifier"
project: adi-chain
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39"
  implementation: null
  name: ZKsyncOSDualVerifier (ADI Chain 36900)
  upgradeable: config-only
  admin: "owner Governance 0x8253f33026c49a430963fe3991441c02175bda95 (owner Safe 0xb272b188855128c10a933edb62cc64c22b1f3754, 2 of 3; security council Safe 0x95f0c748f60624ddad536d979993fa23fd86021a, 2 of 3; minDelay 3 days) can addVerifier/removeVerifier; the chain's verifier is set via ZKsyncOSChainTypeManager 0x08a1d2962fc29aa46e869a1e7561112cc1026efa (owner the same Governance)"
  value_usd: 5432276
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9"
  implementation: null
  name: ZKsyncOSVerifierPlonk (plonk leg, version 0, of 0xccbdfd7f…)
  upgradeable: "no"
  admin: "none (immutable); removable from ZKsyncOSDualVerifier 0xccbdfd7f… by Governance 0x8253f33026c49a430963fe3991441c02175bda95"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a"
  implementation: null
  name: ZKsyncOSVerifierFflonk (fflonk leg, version 0, of 0xccbdfd7f…; not routed to by verify)
  upgradeable: "no"
  admin: "none (immutable); removable from ZKsyncOSDualVerifier 0xccbdfd7f… by Governance 0x8253f33026c49a430963fe3991441c02175bda95"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x08513a4646d1bc8c348c67a3680bb19626e7f13f"
  implementation: null
  name: ZKsyncOSVerifierPlonk (retired; used via ZKsyncOSDualVerifier 0x5e7cf1c3…)
  upgradeable: "no"
  admin: "none (immutable); retired: ADI Chain's current verifier 0xccbdfd7f… does not reference it (block 26,431,772)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-09-09
  txs_30d: 0
- address: "0x8f870cf6621aeaf6026dffc77f484fdab370c4ba"
  implementation: null
  name: L1VerifierPlonk (retired; used via DualVerifier 0x28e31e2b…)
  upgradeable: "no"
  admin: "none (immutable); retired: ADI Chain's current verifier 0xccbdfd7f… does not reference it (block 26,431,772)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-01-17
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "ADI Chain governance: Governance 0x8253f33026c49a430963fe3991441c02175bda95 (owner Safe 0xb272b188855128c10a933edb62cc64c22b1f3754, 2 of 3) adds a post-quantum verifier to ZKsyncOSDualVerifier 0xccbdfd7f… and removes the BN254 one, or upgrades the chain through ZKsyncOSChainTypeManager 0x08a1d2962fc29aa46e869a1e7561112cc1026efa; the post-quantum verifier code would come from Matter Labs' ZKsync OS stack"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/adi-chain-zk-verifiers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify sources of the verifier and legs; cast reads of Bridgehub 0x7a38c18a…, diamond, governance and vault at block 26,431,772; Blockscout holdings
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [zksync-plonk-fflonk-verifier]
---

## Summary

ADI Chain (chain ID 36900) is a ZK Stack chain built on Matter Labs' ZKsync OS, with its own Bridgehub, chain
type manager and governance on Ethereum. Its batches are proven with a PLONK SNARK over BN254. With the setup
trapdoor a quantum attacker can prove a false batch, including withdrawals that never happened, and take what the
chain's L1 vault holds: 731,127 ADI, USD 5.43M on 2026-11-17. Rated MEDIUM: step 4: no verifier is upgradeable, but
ADI's Governance contract (behind a 2-of-3 Safe and a 3-day delay) can register a new verifier in the
`ZKsyncOSDualVerifier` without an Ethereum protocol change.

## Mechanism

- The diamond 0x0583ef2b… (`getVerifier()` = 0xccbdfd7f…) calls `ZKsyncOSDualVerifier.verify(_publicInputs, _proof)`
  when a batch proof is submitted. `verify` takes the type and version from `_proof[0]`, hashes the public inputs and,
  for type 2, calls `plonkVerifiers[version].verify` (`ZKsyncOSDualVerifier.sol` line 75); version 0 is
  `ZKsyncOSVerifierPlonk` 0xc1288a84…. No type routes to `fflonkVerifiers`, so the registered fflonk leg
  0xf6b3708b… cannot be reached through `verify`.
- `ZKsyncOSVerifierPlonk.verify` (line 344) checks the proof with modexp (0x05), ecMul (0x07), ecAdd (0x06) and
  ecPairing (0x08) (lines 383-1673). `ZKsyncOSVerifierFflonk` uses the same precompiles (lines 1501-1614).
- The owner of `ZKsyncOSDualVerifier` (`Ownable2Step`) can `addVerifier(version, fflonk, plonk)` and
  `removeVerifier(version)`.
- A verified batch's withdrawals are paid from the chain's `L1NativeTokenVault`. Pattern PQ-7.
- The chain's DA validator is `BlobsL1DAValidatorZKsyncOS` 0xfb630a20…, which checks `blobhash` but makes no KZG
  point-evaluation call (not a PQ-8 finding).

## Evidence

- CHECKED (Sourcify exact matches): `ZKsyncOSDualVerifier` 0xccbdfd7f…, `ZKsyncOSVerifierPlonk` 0xc1288a84…,
  `ZKsyncOSVerifierFflonk` 0xf6b3708b…; the two retired verifiers from the census excerpts
  ([`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/adi-chain-zk-verifiers/source-excerpts.md)).
- CHECKED (cast, block 26,431,772; [`state.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/adi-chain-zk-verifiers/state.json)):
  `Bridgehub 0x7a38c18a….getAllZKChainChainIDs()` = [36900]; diamond `getVerifier()` 0xccbdfd7f…, `getAdmin()`
  ChainAdminOwnable 0x0a8a2473… (owner Safe 0xf50293ac…, 2 of 3), protocol version 30.2, 16,700 batches executed,
  `settlementLayer(36900)` = 1. `ZKsyncOSDualVerifier.owner()` = Governance 0x8253f330…, `pendingOwner()` = 0; only
  version 0 is set (versions 1-10 empty). Governance `owner()` = Safe 0xb272b188… (2 of 3), `securityCouncil()` = Safe
  0x95f0c748… (2 of 3), `minDelay()` = 259,200 s. The Bridgehub, vault and chain type manager share ProxyAdmin
  0x8140abb6…, owned by the same Governance. No verifier has an EIP-1967 implementation slot.
- CHECKED (Blockscout and cast, 2026-11-17): `L1AssetRouter` 0xf25227ef… → `nativeTokenVault()` 0x0a0f8912… holds
  731,127.27 ADI (token 0x8b1484d5…, USD 7.43, 24-hour volume USD 6.0M), USD 5,432,276; `chainBalance(36900, ADI)`
  equals that balance. The router, `L1Nullifier` 0x5e5a7207… and the diamond hold nothing of value.
- CHECKED (debug_traceTransaction of the retired verifiers' last proofs in the yearly data): both were called by
  diamond 0x0583ef2b…, through ZKsyncOSDualVerifier 0x5e7cf1c3… and DualVerifier 0x28e31e2b… respectively.
- CHECKED (Xatu, any function): last calls 2026-09-09 and 2026-01-17 for the retired verifiers, none in the 30-day
  window ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/adi-chain-zk-verifiers/activity.json)). The live verifier and its legs were
  deployed after the March 2026 trace; their activity was not measured.
- INFERRED: the chain name from chainid.network (36900 = ADI Chain); the team behind the governance Safes is not
  named on-chain.

## Impact and exposure

| Contract | Role | Upgradeable | Escrow | Last active |
|---|---|---|---|---|
| `0xccbdfd7f…` ZKsyncOSDualVerifier | live router | config-only (Governance) | $5.43M (ADI) | not measured |
| `0xc1288a84…` ZKsyncOSVerifierPlonk | live plonk leg | no | (on the router) | not measured |
| `0xf6b3708b…` ZKsyncOSVerifierFflonk | registered, not routed to | no | — | not measured |
| `0x08513a46…` ZKsyncOSVerifierPlonk | retired | no | — | 2026-09-09 |
| `0x8f870cf6…` L1VerifierPlonk | retired | no | — | 2026-01-17 |

- Escrow: `L1NativeTokenVault` `0x0a0f8912162ff83a036883dbada42eff647a3065`, USD 5.43M, all ADI (the chain's base
  token). This is a separate vault from Matter Labs' shared vault in `zksync-plonk-fflonk-verifier`.
- The two retired verifiers were in `zksync-plonk-fflonk-verifier` and were moved here because ADI Chain's own
  governance controls its verifier.

## Remediation

- Register a post-quantum (STARK/FRI or WHIR) verifier of the ZKsync OS (Airbender) proof in `ZKsyncOSDualVerifier`
  with `addVerifier` and remove the BN254 legs with `removeVerifier`, or point the chain at a new verifier through a
  ZKsyncOSChainTypeManager upgrade. The verifier code would come from Matter Labs' ZKsync OS releases.
- Who acts: Governance 0x8253f330… (Safe 0xb272b188…, 2 of 3; 3-day delay). The Safes' owners are ECDSA keys and
  would also need post-quantum signers.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: the two retired verifiers were classified from verified source (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`) and grouped in `zksync-plonk-fflonk-verifier`.
- 2026-11-17 review (Review06): finding created and rated MEDIUM (step 4: ADI's Governance can register a new verifier; escrow USD 5.43M). The two retired verifiers moved here from `zksync-plonk-fflonk-verifier` (rated MEDIUM there); added ADI Chain's live ZKsyncOSDualVerifier and its two legs.
