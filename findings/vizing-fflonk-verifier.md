---
id: vizing-fflonk-verifier
title: "Vizing (Polygon CDK validium): a quantum attacker who recovers the fflonk setup trapdoor can prove false Vizing state and drain its bridge, which holds about $165"
project: vizing
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x985e89135fb4968bca0db46422dc1ed31b985d52"
  implementation: null
  name: FflonkVerifier
  upgradeable: "no"
  admin: "none on the verifier; it is an immutable in Vizing's CDKValidium implementation 0xe2c688df3f4569d0f510553f94b47eb32cf9d177 behind proxy 0x283286888a834a60fb0ded64bfbc246ab175950b, upgradeable by ProxyAdmin 0xe9175f66c79664114a7aa8c86997b74c5775e1af owned by CDKValidiumTimelock 0x1ef0eff8cdb4df5ced75a3afd7c6e71e03568cac (24 h; proposer EOA 0x8ae7370cdbd0382d82e171dee7186c65348df287); read at block 26431457"
  value_usd: 165
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-03-25
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Vizing: timelock proposer 0x8ae7370cdbd0382d82e171dee7186c65348df287 schedules, executor 0x7932a59d1b92d4be1b7f968e24157cde7a85a35b executes, an upgrade of proxy 0x283286888a834a60fb0ded64bfbc246ab175950b to an implementation with a post-quantum verifier, through CDKValidiumTimelock 0x1ef0eff8cdb4df5ced75a3afd7c6e71e03568cac"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/vizing-fflonk-verifier/classification.jsonl
  - evidence/vizing-fflonk-verifier/onchain.json
  - evidence/vizing-fflonk-verifier/activity.json
  - evidence/vizing-fflonk-verifier/source-excerpts.md
  - evidence/vizing-fflonk-verifier/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/vizing-fflonk-verifier/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This fflonk verifier on BN254 checks the validity proofs of Vizing Mainnet (chain id 28518), a standalone Polygon CDK
validium (PQ-7). A quantum attacker who recovers the setup trapdoor can prove a false state and exit root and claim
from Vizing's L1 bridge, which holds about $165; the chain stopped sequencing on 2026-03-25. Rated LOW: an upgrade
through Vizing's timelock would fix it (MEDIUM, step 4), lowered by step 5 (escrow under $50k).

## Mechanism

- `CDKValidium._verifyAndRewardBatches` (CDKValidium.sol l.761 onward) calls `rollupVerifier.verifyProof(proof,
  [inputSnark])` (l.823) for `verifyBatchesTrustedAggregator` (l.715, trusted aggregator only) and `verifyBatches`
  (l.642, anyone once `trustedAggregatorTimeout` has passed); a verified batch sets the new state root and local exit
  root in the global exit root manager, against which the bridge pays `claimAsset`.
- `rollupVerifier` is `immutable` in the CDKValidium implementation (l.152, set in the constructor l.394), so changing
  the verifier means upgrading the validium proxy to a new implementation.
- `FflonkVerifier.verifyProof` (`0x9121da8a`): snarkJS fflonk verifier using `ecAdd`, `ecMul` and the pairing
  precompile.

Pattern PQ-7. Excerpts: [`source-excerpts.md`](../evidence/vizing-fflonk-verifier/source-excerpts.md).

## Evidence

- CHECKED (trace of tx `0xbd34eb33…`, block 24,732,176): trusted aggregator `0xdc543a9c…` -> proxy `0x28328688…`
  `verifyBatchesTrustedAggregator` -> delegatecall CDKValidium `0xe2c688df…` -> `0x985e8913….verifyProof` -> BN254
  precompiles ([`review-reads.json`](../evidence/vizing-fflonk-verifier/review-reads.json)).
- CHECKED (Sourcify verified source of CDKValidium `0xe2c688df…`, read 2026-11-17): the lines above.
- CHECKED (on-chain at block 26,431,457): proxy `0x28328688…` `networkName()` "Vizing Mainnet", `chainID()` 28518,
  `trustedSequencerURL()` https://rpc.vizing.com, `rollupVerifier()` = this verifier, `lastBatchSequenced()` =
  `lastVerifiedBatch()` = 69,633, `bridgeAddress()` `0x44db454c…`; EIP-1967 admin = ProxyAdmin `0xe9175f66…`, whose
  `owner()` is CDKValidiumTimelock `0x1ef0eff8…` (`getMinDelay()` 86,400 s); timelock roles from RoleGranted logs
  (block 19,474,791): proposer `0x8ae7370c…`, executor `0x7932a59d…`, admin `0xcfaa0033…` (all EOAs).
- CHECKED (Blockscout, 2026-11-17): bridge `0x44db454c…` (PolygonZkEVMBridge, same ProxyAdmin) holds 0.0769 ETH,
  20 USDC and 6 USDT, about $165 (ETH at $1,811.62); its and the validium's last transactions are on 2026-03-25.
- CHECKED (precompile trace to March 2026): 206 BN254 verifications in the year
  (`data/report/curated_contracts.csv`, `txs_y1`).
- CHECKED (Blockscout): CDKValidium and the verifier were created by `0x661d94814db578ddea934d3b438f588f397a72a3`.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x985e8913…` FflonkVerifier | no | $165 (bridge `0x44db454c…`) | 2026-03-25 | 0 |

The verifier holds nothing; the escrow is Vizing's L1 bridge. The data-availability committee (`0xdd9eb731…`) is a
separate ECDSA trust assumption not rated here.

## Remediation

- Vizing (timelock `0x1ef0eff8…`): upgrade the validium proxy to an implementation whose verifier is post-quantum
  (STARK/FRI), or, since the chain has stopped, leave it with the bridge empty.
- Users: withdraw anything left in the bridge.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM -> LOW, step 5: escrow measured at about $165 (Vizing's L1 bridge 0x44db454c…). Project identified as Vizing Mainnet (chain id 28518) from the validium proxy 0x28328688… that calls this verifier (`networkName()`); `project` set to `vizing` (id kept). Admin path read: verifier is an immutable of the CDKValidium implementation, upgradeable through ProxyAdmin 0xe9175f66… and CDKValidiumTimelock 0x1ef0eff8… (24 h); fix layer onchain-config -> contract-upgrade.
- 2026-11-17 integration: id renamed from `unidentified-985e8913-snark-verifier` (project identified).
