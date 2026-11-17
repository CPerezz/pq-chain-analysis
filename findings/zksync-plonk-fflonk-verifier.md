---
id: zksync-plonk-fflonk-verifier
title: "ZKsync (Matter Labs): with the BN254 setup trapdoor a quantum attacker can forge batch proofs for any ZK Stack chain and withdraw its funds from the shared L1 vault (USD 127M); verifiers are repointed by ZKsync governance"
project: zksync
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711"
  implementation: null
  name: "DualVerifier (ZKsync Era, Sophon, Abstract, Lens; v33)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 93271011
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0xcef0218c0c6db0768e48debee26e41b8dade7081"
  implementation: null
  name: "DualVerifier (Cronos zkEVM, GRVT, chain 1345; v30.1)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 7555374
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0x47fc5273145e053a18c0bbf6d88f8d6d573c3d0e"
  implementation: null
  name: "DualVerifier (ZERO Network, ZKcandy; v29.5)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 440837
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0x53f5de9de3b2da90633a2c74beb3b9912cdd1579"
  implementation: null
  name: "DualVerifier (chains 9637, 2904; v28.0)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 358
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0xd71ddc9956781bf07dbfb9fca891f971dbe9868a"
  implementation: null
  name: "DualVerifier (chain 1217, zkXPLA; v28.1)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 5315
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0x4d335c5c08fec91a39965351abb6e315ad2e9ff3"
  implementation: null
  name: "DualVerifier (Memento; v29.2)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 275
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45"
  implementation: null
  name: "DualVerifier (ZKsync Gateway 9075; v29.4)"
  upgradeable: "no"
  admin: "none (FFLONK_VERIFIER/PLONK_VERIFIER immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0xdb3300726556afa413a11af474a8cfda4d7fc5a5"
  implementation: null
  name: "Verifier (legacy PLONK, used directly by Treasure; v26)"
  upgradeable: "no"
  admin: "none (immutable); chains' verifier is set by protocol upgrades of EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3: ZKsync token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08)"
  value_usd: 10042
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-07-15
  txs_30d: 0
- address: "0xda5e793b8ae713241d5cb681fd987704e59f7459"
  implementation: null
  name: "ZKsyncOSDualVerifier (ZKsync OS chains 30715, 5010405, 2787, 30716, 88629869, 1942323)"
  upgradeable: "config-only"
  admin: "owner Governance 0xc66f0b45c05cf654eec093650fd67865e85e8566 (owner Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828, 4 of 7; minDelay 0) can addVerifier/removeVerifier; chains' verifier set via ZKsyncOSChainTypeManager 0x1adf137f59949c9081157d5de1e002d1c992071f (owner ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3)"
  value_usd: 5762
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1"
  implementation: null
  name: "ZKsyncOSVerifierPlonk (plonk leg, versions 0 and 6, of ZKsyncOSDualVerifier 0xda5e793b…)"
  upgradeable: "no"
  admin: "none (immutable); removable from ZKsyncOSDualVerifier 0xda5e793b… by its owner"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 240
- address: "0x870c0a2bd4f253dd867b2239a0d8d86f87d64128"
  implementation: null
  name: "EraVerifierFflonk (leg of DualVerifier 0x5d5d33b1…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x5d5d33b1…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001"
  implementation: null
  name: "EraVerifierPlonk (leg of DualVerifier 0x5d5d33b1…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x5d5d33b1…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x8470d6b3fd71b5fe3906b4ea04498d18f721ede9"
  implementation: null
  name: "EraVerifierFflonk (leg of DualVerifier 0xcef0218c…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0xcef0218c…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x0daab2b7b38ab48712996e760152c569fa356dbf"
  implementation: null
  name: "EraVerifierPlonk (leg of DualVerifier 0xcef0218c…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0xcef0218c…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x9f5c39a2790f38542065e7854b90407371923375"
  implementation: null
  name: "L1VerifierFflonk (leg of DualVerifier 0x47fc5273…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x47fc5273…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xd22ca89e8991fce568456914c616d303e3142395"
  implementation: null
  name: "L1VerifierPlonk (leg of DualVerifier 0x47fc5273…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x47fc5273…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xd5dbe903f5382b052317d326fa1a7b63710c6a5b"
  implementation: null
  name: "L1VerifierFflonk (leg of DualVerifier 0x53f5de9d…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x53f5de9d…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-26
  txs_30d: 0
- address: "0x5bafef6729228add8775af4cecd2e68a51424ee1"
  implementation: null
  name: "L1VerifierPlonk (leg of DualVerifier 0x53f5de9d…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x53f5de9d…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-10
  txs_30d: 0
- address: "0x1ac4f629fdc77a7700b68d03bf8d1a53f2210911"
  implementation: null
  name: "L1VerifierFflonk (leg of DualVerifier 0xd71ddc99…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0xd71ddc99…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-04-15
  txs_30d: 0
- address: "0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6"
  implementation: null
  name: "L1VerifierPlonk (leg of DualVerifier 0xd71ddc99…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0xd71ddc99…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-07-07
  txs_30d: 0
- address: "0xd324a7c8556a059371b207fb96fd77be24e2042c"
  implementation: null
  name: "L1VerifierFflonk (leg of DualVerifier 0x4d335c5c…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x4d335c5c…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-16
  txs_30d: 0
- address: "0xe201837d151e5ac33af3305f287ad6f6a7dfccd7"
  implementation: null
  name: "L1VerifierPlonk (leg of DualVerifier 0x4d335c5c…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0x4d335c5c…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xa38a0df579f9eca29fba560b9885b1113b1df442"
  implementation: null
  name: "L1VerifierFflonk (leg of DualVerifier 0xcd279bd5…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0xcd279bd5…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-08-11
  txs_30d: 0
- address: "0x7f33d100f482093182111d69a4a457289e99f4ec"
  implementation: null
  name: "L1VerifierPlonk (leg of DualVerifier 0xcd279bd5…)"
  upgradeable: "no"
  admin: "none (immutable leg of DualVerifier 0xcd279bd5…); replaced by pointing chains at a new DualVerifier"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x1f517f2bab178add6e282297a4728bcc50e9f6cf"
  implementation: null
  name: "L1VerifierFflonk (retired; ZERO Network and Memento via DualVerifier 0x079004d9…)"
  upgradeable: "no"
  admin: "none (immutable); retired: not referenced by any registered chain's verifier at block 26,431,458"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-09-29
  txs_30d: 0
- address: "0xad36ffc4066855aef3bdf6bf03ca427bb084636e"
  implementation: null
  name: "L1VerifierPlonk (retired; ZERO Network and Memento via DualVerifier 0x079004d9…)"
  upgradeable: "no"
  admin: "none (immutable); retired: not referenced by any registered chain's verifier at block 26,431,458"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-07-16
  txs_30d: 0
- address: "0xe3743181a4b0a0c1260826105c6bba4b6e18d79d"
  implementation: null
  name: "L1VerifierFflonk (retired; Lens via DualVerifier 0x4f06ef57…)"
  upgradeable: "no"
  admin: "none (immutable); retired: not referenced by any registered chain's verifier at block 26,431,458"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-18
  txs_30d: 0
- address: "0x06aa7a7b07108f7c5539645e32dd5c21cbf9eb66"
  implementation: null
  name: "Verifier (PLONK, retired; Sophon)"
  upgradeable: "no"
  admin: "none (immutable); retired: not referenced by any registered chain's verifier at block 26,431,458"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-03-27
  txs_30d: 0
- address: "0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1"
  implementation: null
  name: "ZKsyncOSVerifierPlonk (retired; chain 30715 via ZKsyncOSDualVerifier 0x5b4b58a5…)"
  upgradeable: "no"
  admin: "none (immutable); retired: not referenced by any registered chain's verifier at block 26,431,458"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-18
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "ZKsync governance: protocol upgrades through EraChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c and ZKsyncOSChainTypeManager 0x1adf137f59949c9081157d5de1e002d1c992071f, both owned by ProtocolUpgradeHandler 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3 (token governance, security council 0x29d2e773a31c07d375c50f0110422832bd044d08), accepted by each chain's admin; ZKsyncOSDualVerifier legs by Governance 0xc66f0b45c05cf654eec093650fd67865e85e8566 (Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828, 4 of 7)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-plonk-fflonk-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify/Blockscout sources of DualVerifier, ZKsyncOSDualVerifier and legs; Bridgehub and diamond reads at block 26,431,458; traces of the retired verifiers' last proofs
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [zksync-blob-kzg, adi-chain-zk-verifiers]
---

## Summary

Every ZK Stack chain registered in Matter Labs' L1 Bridgehub (22 chains, including ZKsync Era, Sophon, Abstract,
Lens, Cronos zkEVM and GRVT) proves its batches on Ethereum with a PLONK or fflonk SNARK over BN254. With the
setup trapdoor a quantum attacker can prove a false batch for a chain, including withdrawals that never happened, and
claim up to that chain's balance from the shared `L1NativeTokenVault` (USD 127.05M on 2026-11-17; Era's share alone
35,435 ETH and 20.4M USDC). Rated MEDIUM: step 4: no verifier is upgradeable, but ZKsync governance can point every
chain at a new verifier through a protocol upgrade (or, for ZKsync OS chains, Matter Labs' Governance contract can
swap the verifier leg), without an Ethereum protocol change.

## Mechanism

- When a batch proof is submitted (through the chain's ValidatorTimelock), the diamond's ExecutorFacet calls the
  verifier returned by `getVerifier()` (seen in the traces). For Era-based
  chains this is a `DualVerifier` (Sourcify, `DualVerifier.sol`): `verify(_publicInputs, _proof)` reads `_proof[0]`
  and routes to the immutable `FFLONK_VERIFIER` (type 0) or `PLONK_VERIFIER` (type 1). Chain 61166 (Treasure) still
  uses the legacy single `Verifier` 0xdb330072… directly.
- ZKsync OS chains use `ZKsyncOSDualVerifier` 0xda5e793b… (`Ownable2Step`): `verify` routes type 2 to
  `plonkVerifiers[version]` (versions 0 and 6 = 0x433fe66e…) after hashing the public inputs; its owner can
  `addVerifier`/`removeVerifier`.
- The legs (`L1VerifierFflonk`/`EraVerifierFflonk`, `L1VerifierPlonk`/`EraVerifierPlonk`,
  `ZKsyncOSVerifierPlonk`) check the proof with `ecAdd`/`ecMul`/`ecPairing` and `modexp` inverses (source excerpts
  for the census contracts). The proof wraps a hash-based Boojum/Airbender STARK, so only this final wrapper is
  pre-quantum.
- A verified batch's L2→L1 logs authorise withdrawals through `L1Nullifier`/`L1AssetRouter` from the
  `L1NativeTokenVault`, limited per chain by `L1AssetTracker.chainBalance` (`L1NativeTokenVault.sol`,
  `handleChainBalanceDecreaseOnL1`).
- Pattern PQ-7.

## Evidence

- CHECKED (block 26,431,458; [`zk-stack-state.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-plonk-fflonk-verifier/zk-stack-state.json)):
  `Bridgehub 0x303a465b….getAllZKChainChainIDs()` and, per chain, `getZKChain`, `getVerifier`, `getProtocolVersion`,
  `getChainTypeManager`, `getAdmin`, `getTotalBatchesExecuted`; `FFLONK_VERIFIER()`/`PLONK_VERIFIER()` of each
  DualVerifier; `fflonkVerifiers`/`plonkVerifiers(0..8)` and `owner()` of the ZKsyncOSDualVerifier. No verifier has an
  EIP-1967 implementation or admin slot; only the ZKsyncOSDualVerifier has an owner.
- CHECKED (same block): EraChainTypeManager 0xc2ee6b6a…, ZKsyncOSChainTypeManager 0x1adf137f… and the Bridgehub are
  owned by 0xe30dca30… (and their ProxyAdmins too); 0xe30dca30… reports `securityCouncil()` 0x29d2e773…. Governance
  0xc66f0b45… (owner of the ZKsyncOSDualVerifier) is owned by Safe 0x4e494334… (4 of 7) with `minDelay` 0.
- CHECKED (escrow, block 26,431,458 and Blockscout 2026-11-17): `L1AssetRouter` 0x8829ad80… → `nativeTokenVault()`
  0xbed1eb54… holds 43,211.7 ETH and 502 tokens, USD 127,050,524 (USDC 23.0M, GRVT 7.3M, zkCRO 5.5M, USDT 5.5M, CRO
  2.8M, BEAM 2.0M, WBTC 1.4M, …); per-chain ETH and USDC balances from `L1AssetTracker` 0x7fd8b995…. Every chain's
  `settlementLayer` is 1 (Ethereum), so no chain's funds are behind the Gateway.
- CHECKED (debug_traceTransaction of each retired verifier's last proof in the yearly data;
  [`retired-paths.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-plonk-fflonk-verifier/retired-paths.json)): which diamond called it (see the
  table).
- CHECKED (Xatu, any function): last calls and 30-day transactions in the table
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-plonk-fflonk-verifier/activity.json)). The DualVerifiers and new legs were
  deployed after the March 2026 trace; their activity was not measured (null).
- INFERRED: chain names from chainid.network (324 ZKsync Era, 388 Cronos zkEVM, 50104 Sophon, 543210 ZERO Network,
  2741 Abstract, 325 GRVT, 61166 Treasure, 320 ZKcandy, 232 Lens, 375 zkXPLA, 51888 Memento, 36900 ADI Chain); 9075 is
  the ZKsync Gateway; 1345, 9637, 1217, 2904 and the ZKsync OS chain IDs have no registry entry.

## Impact and exposure

Live verifiers (block 26,431,458). Value = ETH + USDC chain balances of the chains using the verifier, in the shared
vault (other tokens per chain not read, so lower bounds); it is put on the DualVerifier, not on its legs.

| Verifier | Legs (fflonk / plonk) | Chains | ETH + USDC escrow |
|---|---|---|---|
| `0x5d5d33b1…` DualVerifier | `0x870c0a2b…` / `0x71ef07eb…` | 324, 50104, 2741, 232 | $93.27M |
| `0xcef0218c…` DualVerifier | `0x8470d6b3…` / `0x0daab2b7…` | 388, 325, 1345 | $7.56M |
| `0x47fc5273…` DualVerifier | `0x9f5c39a2…` / `0xd22ca89e…` | 543210, 320 | $0.44M |
| `0x53f5de9d…` DualVerifier | `0xd5dbe903…` / `0x5bafef67…` (census) | 9637, 2904 | $358 |
| `0xd71ddc99…` DualVerifier | `0x1ac4f629…` / `0x2db2ffde…` (census) | 1217, 375 | $5.3k |
| `0x4d335c5c…` DualVerifier | `0xd324a7c8…` (census) / `0xe201837d…` | 51888 | $275 |
| `0xcd279bd5…` DualVerifier | `0xa38a0df5…` (census) / `0x7f33d100…` | 9075 (Gateway) | $0 |
| `0xdb330072…` Verifier (legacy, census) | — | 61166 | $10.0k |
| `0xda5e793b…` ZKsyncOSDualVerifier | — / `0x433fe66e…` (census) | 30715, 5010405, 2787, 30716, 88629869, 1942323 | $5.8k |

Total in the vault: USD 127.05M (the per-row values sum to USD 101.3M because only ETH and USDC were split by chain).

Retired census verifiers (no registered chain points at them now; nothing exposed through them):

| Contract | Used by (traced) | Last called |
|---|---|---|
| `0x1f517f2b…` L1VerifierFflonk | ZERO Network (543210) and Memento (51888) via DualVerifier 0x079004d9… | 2025-09-29 |
| `0xad36ffc4…` L1VerifierPlonk | ZERO Network (543210) and Memento (51888) via DualVerifier 0x079004d9… | 2025-07-16 |
| `0xe3743181…` L1VerifierFflonk | Lens (232) via 0x4f06ef57… | 2026-06-18 |
| `0x06aa7a7b…` Verifier (PLONK) | Sophon (50104), directly | 2025-03-27 |
| `0xfab3b4b8…` ZKsyncOSVerifierPlonk | chain 30715 via 0x5b4b58a5… | 2025-12-18 |

- All 13 census contracts here are Matter Labs code (zkSync-family) and served chains of Matter Labs' Bridgehub.
  Two further census verifiers (0x08513a46…, 0x8f870cf6…) served ADI Chain (36900), which is registered in a separate
  Bridgehub 0x7a38c18a… under its own governance; they and ADI Chain's live verifiers are in `adi-chain-zk-verifiers`.
- Ethereum-side ZK Stack contracts outside the Bridgehub list were not searched further.

## Remediation

- Replace the BN254 wrapper with an on-chain STARK/FRI (or WHIR) verifier of the Boojum/Airbender proof, at higher
  gas, and point every chain at it: a protocol upgrade of each ChainTypeManager (ProtocolUpgradeHandler 0xe30dca30…,
  token governance with security council), accepted by each chain's admin. For ZKsync OS chains, Governance
  0xc66f0b45… can also `addVerifier` a post-quantum leg and `removeVerifier` the old one directly.
- Chains still on old protocol versions (Treasure on v26, chains 9637/2904/1217/375 on v28) must take the upgrade
  too; until they do, their (small) balances stay exposed.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review06): MEDIUM confirmed (step 4: governance repoints verifiers; escrow USD 127.05M in L1NativeTokenVault). Added the 16 live verifiers (7 DualVerifiers, the ZKsyncOSDualVerifier and 8 legs) that were deployed after the census; marked 7 census verifiers retired with the chain that last used them; 2 of those served ADI Chain on a separate Bridgehub.
- 2026-11-17 review (Review06): moved the two ADI Chain verifiers (0x08513a46…, 0x8f870cf6…) to `adi-chain-zk-verifiers`, because ADI Chain's own governance, not ZKsync governance, controls that chain's verifier. Rating unchanged: MEDIUM (step 4).
