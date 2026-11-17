---
id: zircuit-halo2-verifier
title: "Zircuit: retired Halo2-KZG VerifierV2 proxy; a forged BN254 proof would release nothing, since no Zircuit L1 contract calls it"
project: zircuit
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0xc25d093d3a3f58952252d2e763beaf2559dc9737"
  implementation: "0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0"
  name: Proxy → VerifierV2 (snark-verifier Halo2-KZG, BN254)
  upgradeable: "yes"
  admin: EIP-1967 admin ProxyAdmin 0x5b1ef673d9c316b3ee9ed3b4e3cc84952bfc5257, owner Safe 0x4a4962275df8c60a80d3a25faec5aa7de116a746 (v1.3.0, 4 of 10; read at block 26431535)
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-08-25
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "None needed: Zircuit already removed the verifier from its withdrawal path (L2OutputOracle no longer calls it; OptimismPortal2 0x17bfafa932d2e23bd9b909fd5b4d2e2a27043fb1 uses PermissionedDisputeGame). Safe 0x4a4962275df8c60a80d3a25faec5aa7de116a746 (4 of 10) owns both ProxyAdmins and could only re-expose it by an upgrade"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zircuit-halo2-verifier/classification.jsonl
  - evidence/zircuit-halo2-verifier/onchain.json
  - evidence/zircuit-halo2-verifier/activity.json
  - evidence/zircuit-halo2-verifier/source-excerpts.md
  - evidence/zircuit-halo2-verifier/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review16 (verified source of VerifierV2 and the L2OutputOracle/OptimismPortal implementations, on-chain reads)
  ref: evidence/zircuit-halo2-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`0xc25d093d…` is Zircuit's Halo2-KZG proof verifier (VerifierV2, BN254 pairings, PQ-7). With the setup trapdoor a
quantum attacker could make it accept a false batch proof, but no Zircuit L1 contract calls it any more: the
L2OutputOracle stopped using it in 2025 and Zircuit withdrawals have been proven against a PermissionedDisputeGame
since block 25,681,868 (2026-08-04). Exposure through this verifier: USD 0 (the Zircuit bridge escrow of about
USD 6.1M is secured by the dispute game, not by this proof). Rated LOW at step 1: no call in the last 12 months
(last 2025-08-25) and nothing held or released.

## Mechanism

- `VerifierV2` (`src/L1/VerifierV2.sol`, implementation `0x5d4f36e7…`): a generated snark-verifier contract with only
  a `fallback`. It checks the proof with BN254 `ecMul` (0x07) and `ecAdd` (0x06) calls (lines 1772-2119) and one
  `ecPairing` (0x08) call at line 2159, reverting on failure; `digest` (line 5) pins the circuit's verifying key.
- Former consumer: Zircuit `L2OutputOracle` v3.0.0 (implementation `0x6ab82bb1…`, proxy `0x92ef6af4…`).
  `proposeL2OutputV2` (callable only by the `proposer`) called `verifyV2`, which `staticcall`s `verifierV2` with the
  bundle proof and `VerifierV2(verifierV2).digest()` and requires success. An accepted output root let the
  OptimismPortal prove withdrawals against it.
- Current path: `L2OutputOracle` v1.8.0 (`0xf243bed1…`) has no verifier; `OptimismPortal2` v5.6.1
  (`0xe89f13c5…`) proves withdrawals against games from `DisputeGameFactory` `0x6b9e8150…` of the respected game type
  1, implementation `PermissionedDisputeGame` `0xe1dffcbe…` (no SNARK verification).

Pattern PQ-7. Source excerpts: [`source-excerpts.md`](../evidence/zircuit-halo2-verifier/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of `0x5d4f36e7…`, `VerifierV2`): fallback-only verifier, precompiles 0x06/0x07/0x08,
  `digest` constant.
- CHECKED (precompile trace, all mainnet transactions to March 2026): 1,370 `ecPairing` calls by `0xc25d093d…`
  between blocks 22,027,176 and 23,219,158 (1,262 distinct transactions in the yearly corpus from block 22,100,580);
  the last, tx `0xccf6f95c…` (2025-08-25), was
  `proposeL2OutputV2` sent to L2OutputOracle `0x92ef6af4…` by `0xe8c20ea8…`; 8 more sampled transactions were all
  sent to `0x92ef6af4…`.
- CHECKED (Xatu traces, blocks 24,700,000-26,423,999): no transaction or call frame to `0xc25d093d…`
  ([`activity.json`](../evidence/zircuit-halo2-verifier/activity.json)).
- CHECKED (EIP-1967 slots, block 26,431,535): implementation `0x5d4f36e7…`, admin ProxyAdmin `0x5b1ef673…`, whose
  `owner()` is Safe `0x4a496227…` (v1.3.0, threshold 4 of 10 owners). The L2OutputOracle, OptimismPortal2 and
  L1StandardBridge proxies have a different ProxyAdmin, `0x3a317fce…`, owned by the same Safe.
- CHECKED (archive reads of the L2OutputOracle implementation slot, Blockscout/Sourcify verified source): v3.0.0
  `0x6ab82bb1…` with `verifierV2` at block 23,219,158; v3.1.0 (SP1 `verifierV3` only, no VerifierV2 reference)
  from block 23,871,214 (2025-11-24); v1.8.0 `0xf243bed1…` from block 25,681,868 (2026-08-04), when the portal
  implementation also changed.
- CHECKED (block 26,431,535): `OptimismPortal2.anchorStateRegistry()` = `0x2613d77f…`,
  `respectedGameType()` = 1, `DisputeGameFactory.gameImpls(1)` = `0xe1dffcbe…` (verified `PermissionedDisputeGame`),
  209 games; portal `guardian()` = Safe `0x4a496227…`.
- CHECKED (escrow, block 26,431,535 / Blockscout 2026-11-17): OptimismPortal2 holds 754.758 ETH (USD 1,367,334 at
  USD 1,811.62); L1StandardBridge `0x386b76d9…` holds 0 ETH and tokens worth USD 4,734,658 at Blockscout
  `exchange_rate` (largest: ZRC 2.80B at 0.00092594, weETHs 778.9 at 1,931.46, weETH 190.2 at 2,009.37, USDT
  118,370, WBTC 1.96 at 64,633) ([`escrow.json`](../evidence/zircuit-halo2-verifier/escrow.json)). Not secured by
  this verifier.
- INFERRED: Zircuit's staking pool does not depend on VerifierV2 (the only consumer in verified source and in the
  sampled transactions is the L2OutputOracle); not counted.

## Impact and exposure

| Contract | Upgradeable | Held now | Escrow secured | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0xc25d093d…` Proxy → VerifierV2 (Halo2-KZG) | yes (ProxyAdmin `0x5b1ef673…`, Safe 4/10) | 0 | USD 0 (no consumer) | 2025-08-25 | 0 |

The rollup escrow that this verifier used to secure, OptimismPortal2 `0x17bfafa9…` (ETH) and L1StandardBridge
`0x386b76d9…` (tokens), about USD 6.10M on 2026-11-17, is now released only against PermissionedDisputeGame
outputs, so a forged Halo2 proof releases nothing. The SP1 verifier that replaced it (L2OutputOracle v3.1.0
`verifierV3`) is likewise no longer on the path since 2026-08-04. The verifier is exposed again only if the Safe
upgrades a consumer to call it. Similar unverified fallback-only Halo2 verifiers are tracked separately
(`0x39854df3…` and `0x9f66505c…`, both Scroll's, in `scroll-plonk-verifier-bn254`); they are not linked to Zircuit here.

## Remediation

Nothing to do for the current deployment: the consumer already moved away from the verifier. Zircuit's Safe
`0x4a4962275df8c60a80d3a25faec5aa7de116a746` (4 of 10) should not point a consumer back at VerifierV2; any future
validity proof on L1 should use a hash-based (STARK/FRI or WHIR) verifier. No protocol change is needed.
[INFERRED, not checked here: the PermissionedDisputeGame admits only the configured proposer and challenger, so the
current path depends on their keys, a separate operator-key exposure outside this finding.]

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-08-25) and nothing held).
- 2026-11-17 review (Review16): LOW -> LOW, step 1: last call 2025-08-25 and nothing held; consumer traced to L2OutputOracle `proposeL2OutputV2`, which was upgraded away (v3.1.0 at block 23,871,214, v1.8.0 at 25,681,868; withdrawals now via PermissionedDisputeGame), so escrow secured = USD 0. Impact set to `none`, fix.layer to `none`; admin corrected (the bridge has a different ProxyAdmin `0x3a317fce…`, same owner Safe).
