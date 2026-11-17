---
id: zkpassport-honk-verifier
title: "ZKPassport OuterCount8 Honk verifier: a recovered BN254 setup trapdoor forges passport identity proofs; its only observed consumer, Aztec's sale-eligibility soulbound mint, releases no funds"
project: zkpassport
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0x8198cd503cb522987d977784837be2a59e61f4ef"
  implementation: null
  name: HonkVerifier (OuterCount8)
  upgradeable: "no"
  admin: "none on the verifier; ZKPassportSubVerifier 0xc1fb0d750a95fb95d5bcc585b17f8fab62681bf8 maps it (vkeyHash 0x17407da3…) and its admin Safe 0x2000ab040a899f914d6dfd2457c3dfbb22d4c762 (1 of 2) can remove it; read at block 26,431,581"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-12-06
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "ZKPassport admin Safe 0x2000ab040a899f914d6dfd2457c3dfbb22d4c762 (1 of 2): removeProofVerifiers on sub-verifier 0xc1fb0d75… or removeSubVerifier on root verifier 0x1d000001000efd9a6371f4d90bb8920d5431c0d8; consumers (Aztec soulbound owner Safe 0x81a62d77…) can also de-list the ZKPassport provider"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zkpassport-honk-verifier/classification.jsonl
  - evidence/zkpassport-honk-verifier/onchain.json
  - evidence/zkpassport-honk-verifier/activity.json
  - evidence/zkpassport-honk-verifier/source-excerpts.md
  - evidence/zkpassport-honk-verifier/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (verified registry source, event logs, consumer trace)
  ref: evidence/zkpassport-honk-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This UltraHonk verifier on BN254 checks ZKPassport's "outer" recursive passport proofs (PQ-7). With the KZG setup
trapdoor recovered from public parameters, a quantum attacker can produce a proof that a non-existent passport
satisfies any disclosed condition: nationality, age, sanctions screening, a unique identifier. The verifier is still
mapped in ZKPassport's registry, but its only observed consumer was the mint of Aztec's sale-eligibility soulbound
token for a sale that ended on 2025-12-01; that contract and the sale contract hold nothing (USD 0, escrow basis).
Rated LOW (step 4): a forged proof releases no funds through the known consumer, and one known admin can unmap the
verifier.

## Mechanism

- `HonkVerifier.verify(bytes proof, bytes32[] publicInputs)` (`src/ultra-honk-verifiers/OuterCount8.sol`, line 1288)
  runs the UltraHonk/Shplemini check, ending in a BN254 pairing against the Aztec SRS.
- `ZKPassportRootVerifier.verify` (`0x1d000001…`) selects a sub-verifier by `params.version`.
  `ZKPassportSubVerifier.verify` (`0xc1fb0d75…`) checks the certificate and circuit roots, date validity and scopes,
  then calls `IProofVerifier(proofVerifiers[vkeyHash]).verify(proof, publicInputs)` (line 237).
- Consumer seen: Aztec `IgnitionParticipantSoulbound.mint` (`0xbf3cf56c…`) calls the allow-listed
  `ZKPassportProvider` `0xe4f80f25…`. A valid proof lets the caller mint a soulbound token that marked eligibility for
  the `GenesisSequencerSale` `0xbe88a980…`.

Pattern PQ-7. Excerpts: [`source-excerpts.md`](../evidence/zkpassport-honk-verifier/source-excerpts.md).

## Evidence

- CHECKED (Blockscout verified source): `HonkVerifier` (OuterCount8), `ZKPassportSubVerifier` and
  `ZKPassportRootVerifier` with their `onlyAdmin` mapping functions.
- CHECKED (Blockscout creator and logs): the verifier was deployed by `0x9cf1e624…` together with ZKPassport's
  sub-verifier, registries and nine other Honk verifiers. `ProofVerifierAdded` maps it to vkeyHash `0x17407da3…`
  ([`notes.md`](../evidence/zkpassport-honk-verifier/notes.md)). This confirms the draft's inferred attribution.
- CHECKED (`cast`, block 26,431,581): `proofVerifiers(0x17407da3…)` still returns this verifier; sub-verifier and root
  admin is Safe `0x2000ab04…` (1 of 2); no guardian; the sub-verifier is not paused and is registered under three
  versions, while newer versions (up to `0x16`) use other sub-verifiers.
- CHECKED (precompile trace, `data/agg/y1_tx_caller.parquet`): 3,977 transactions in blocks 23,790,488-23,955,308. A
  random sample of six was all Aztec soulbound `mint` calls. INFERRED: the rest are the same consumer.
- CHECKED (`cast` and Blockscout, block 26,431,581): `isSaleActive()` is false and `saleEndTime` is 2025-12-01. The
  soulbound and sale contracts hold no ETH or priced tokens. The provider is still allow-listed.
- CHECKED (Xatu): no transaction in 2026-10-16 to 2026-11-16; last use 2025-12-06.

## Impact and exposure

| Contract | Upgradeable | Escrow (what a forged proof releases) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x8198cd50…` HonkVerifier (OuterCount8) | no (unmappable by admin) | $0: Aztec soulbound `0xbf3cf56c…` and sale `0xbe88a980…` hold nothing | 2025-12-06 | 0 |

A forged proof still mints an eligibility soulbound token, because the provider is allow-listed, but the sale is
closed. Any future consumer that accepts ZKPassport versions `0x0f0001`, `0x10` or `0x110001` with this circuit would
inherit the forgery. The other nine Honk verifiers from the same deployment, and the newer sub-verifiers, use the same
proof system; they are not in this finding.

## Remediation

- ZKPassport admin Safe `0x2000ab04…`: `removeProofVerifiers([0x17407da3…])` on `0xc1fb0d75…`, or retire the old
  versions on the root verifier. That disables the circuit; a post-quantum replacement needs a hash-based proving
  backend for the passport circuits and new verifiers registered the same way.
- Aztec (soulbound owner Safe `0x81a62d77…`, 3 of 5): `setIdentityProvider(0xe4f80f25…, false)` now that the sale is
  over.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 4: the only consumer seen (Aztec Ignition soulbound mint, sale ended 2025-12-01) releases no funds, escrow measured at USD 0, and one known admin (Safe 0x2000ab04…, 1 of 2) can unmap the verifier; impact set to none, admin and who_acts identified, attribution to ZKPassport confirmed from the deployer.
