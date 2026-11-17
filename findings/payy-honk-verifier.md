---
id: payy-honk-verifier
title: "Payy RollupV1: BN254 Honk proofs (forgeable with the recovered setup trapdoor) are one of three pre-quantum gates on rollup state; the rollup escrow holds about $711 and the owner Safe can swap the verifier"
project: payy
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x14dacd534ddc676601b27f41eb541a7951524a2f"
  implementation: null
  name: HonkVerifier (current; enabled in RollupV1 0x367c1eaf14aa06b78ce76bd0243297de79d85270)
  upgradeable: "no"
  admin: none; RollupV1 owner Safe 0x230dfb03f078b0d5e705f4624fcc915f3126b40f (2 of 4) adds or removes verifiers (read at block 26431661)
  value_usd: 711
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-09-24
  txs_30d: null
- address: "0xb553c325959c8615d9018f00906aec3799b94200"
  implementation: null
  name: unverified Honk verifier (retired; not enabled in RollupV1 since 2026-05-15)
  upgradeable: "no"
  admin: none; RollupV1 owner Safe 0x230dfb03f078b0d5e705f4624fcc915f3126b40f (2 of 4)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-15
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Payy, through RollupV1 owner Safe 0x230dfb03f078b0d5e705f4624fcc915f3126b40f (2 of 4; also owner of ProxyAdmin 0xfe455bacaf1968f1ae6a322b8ffbe56840e2f590), via addZkVerifier/removeZkVerifier with a post-quantum verifier
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/payy-honk-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review22)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/payy-honk-verifier/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Payy's `RollupV1` (proxy `0x367c1eaf…`) accepts a new state root only when three checks pass: the caller is a
registered prover (ECDSA EOA), more than two thirds of the validator set sign the root (ECDSA), and a BN254
UltraHonk proof verifies. Burns in the root release USDC from the rollup. A quantum attacker who recovers the Honk
setup trapdoor and the prover and validator keys could post a false root and withdraw the escrow, which holds about
$711 of USDC. The flagged verifier `0xb553c325…` was replaced on 2026-05-15; the current one is HonkVerifier
`0x14dacd53…`. Rated LOW (step 4: MEDIUM, the owner Safe can point the rollup at a new verifier; step 5: $711 exposed).

## Mechanism

- `RollupV1.verifyRollup(height, verificationKeyHash, aggrProof, publicInputs, otherHashFromBlockHash, signatures)`
  (verified implementation `0x7d8837b5…`, lines 314-372) is `onlyProver` (lines 152-155). It requires
  `zkVerifiers[verificationKeyHash].enabled` (line 324), checks `verifyValidatorSignatures` (lines 725-765:
  `ECDSA.recover` per signature, at least `2n/3 + 1` validators), then
  `zkVerifiers[key].verifier.verify(aggrProof, publicInputs)` (line 357). After that it sets `rootHash`. Burn messages
  in the public inputs pay USDC out of the rollup via `executeBurn` → `token.transfer` (lines 442-534). PQ-7 for the
  proof; the prover and validator checks are PQ-4/PQ-5-style ECDSA gates on the same path.
- The verifiers are Barretenberg `HonkVerifier` contracts (`verify(bytes,bytes32[])`, KZG pairing check over BN254;
  `0x14dacd53…` is verified on Blockscout, solc 0.8.29, `N = 2^20`). `0xb553c325…` is unverified, has the same size
  (23,661 bytes) and contains the BN254 modulus.
- `addZkVerifier` and `removeZkVerifier` (lines 186-235) are `onlyOwner`; `setRoot` (line 264) lets the owner set any
  root.

## Evidence

- CHECKED (verified source on Blockscout: RollupV1 implementation `0x7d8837b5…`, HonkVerifier `0x14dacd53…`): the code
  path above.
- CHECKED (RPC at block 26,431,523; [`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/payy-honk-verifier/review-reads.json)): proxy
  implementation `0x7d8837b5…`, admin ProxyAdmin `0xfe455bac…`; `owner()` of both is Safe `0x230dfb03…` (threshold 2;
  owners `0x54e22ad9…`, `0x111e5fea…`, `0xca1df6ed…`, `0xaf657a8f…`, read at block 26,431,661); `version()` = 2;
  `zkVerifierKeys` holds a single key, `0x0701c58c…`, which points to `0x14dacd53…`, so `0xb553c325…` is not enabled;
  validator set [`0x41582701…`]; USDC balance 710.76, no other priced tokens, 0 ETH.
- CHECKED (Blockscout, Xatu): `0xb553c325…` was last called on 2026-05-15 (block 25,100,695, via `verifyRollup`
  selector `0xb8cdbd27`); HonkVerifier `0x14dacd53…` was created at block 25,101,626 the same day. The last
  `RollupVerified` event on the rollup was at block 26,046,439 (2026-09-24). There were 293 pre-quantum calls to
  `0xb553c325…` in the year to March 2026 (`curated_contracts.csv`).
- INFERRED: `0x14dacd53…`'s 30-day call count was not measured (it is not in the Xatu target set); no `RollupVerified`
  event since 2026-09-24 suggests none.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x14dacd53…` HonkVerifier (current) | no (consumer can repoint) | $711 (escrow: RollupV1 `0x367c1eaf…` USDC) | 2026-09-24 | not measured |
| `0xb553c325…` Honk verifier (retired) | no | — (not enabled) | 2026-05-15 | 0 |

The escrow is RollupV1 `0x367c1eaf…`, which holds 710.76 USDC. A forged root also requires recovering the prover EOA
and the validator key(s); the owner Safe can already set any root.

Grouping: `0x14dacd53…` was not in the census; it is added here as the verifier currently enabled in the same rollup.

## Remediation

- Payy's owner Safe `0x230dfb03…` deploys a post-quantum verifier (STARK/FRI or WHIR) for the rollup circuit, calls
  `addZkVerifier`, then `removeZkVerifier(0x0701c58c…)`. The prover and validator checks need post-quantum signatures
  too, which takes an implementation upgrade through ProxyAdmin `0xfe455bac…`. The Safe's owners should also move to
  post-quantum signers.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review22): MEDIUM -> LOW, step 5: escrow measured (RollupV1 `0x367c1eaf…` holds $711 USDC); step 4 alone would be MEDIUM (verifier swap by the 2-of-4 owner Safe). Status candidate -> confirmed (RollupV1 and the current HonkVerifier are verified; state read). Added the current verifier `0x14dacd53…`; `0xb553c325…` is retired. Attribution to Payy confirmed (`NETWORK = "Payy"` in RollupV1).

# Source excerpts: payy-honk-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb553c325959c8615d9018f00906aec3799b94200`

No verified source on Sourcify or Blockscout.
