---
id: drosera-bls-bn254
title: "Drosera (trap network) main contract: claims that a trap fired are accepted on a BN254 pairing check of operator signatures (BLS); with recovered operator keys a quantum attacker can submit false claims that invoke protected protocols' response functions"
project: drosera
status: candidate
severity: MEDIUM
patterns: [PQ-6]
primitives: [bn254]
trigger: committee-keys
impact: unknown
alternative: sole
role: core
contracts:
- address: "0x01c344b8406c3237a6b9dbd06ef2832142866d87"
  implementation: null
  name: "unverified selector-to-implementation router (Drosera main contract; emits ClaimSubmitted, OperatorOptedIntoTrap)"
  upgradeable: "yes"
  admin: "owner Safe 0xf5cd89a836860a6e634785a3244a745990248935 (2 of 7) sets the selector-to-implementation mapping"
  value_usd: 65
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-15
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Drosera: Safe 0xf5cd89a836860a6e634785a3244a745990248935 (2 of 7) points the claim selector at an implementation with post-quantum operator signatures"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/drosera-bls-bn254/classification.jsonl
  - evidence/drosera-bls-bn254/onchain.json
  - evidence/drosera-bls-bn254/activity.json
  - evidence/drosera-bls-bn254/source-excerpts.md
  - evidence/drosera-bls-bn254/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review15 (finding review)
  ref: findings/drosera-bls-bn254.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: []
---

## Summary

`0x01c344b8` is the main contract of Drosera, a network of operators that watch "traps" and, when a trap's condition
fires, submit a claim that calls the protected protocol's configured response function and pays the claiming
operators. The claim carries a G1 point and a G2 point and is checked with a two-pair BN254 pairing, the shape of an
aggregate BLS signature check (PQ-6), not a SNARK as drafted. A quantum attacker who recovers the opted-in operators'
BLS keys can submit false claims and trigger responses whenever it wants; what a response does is set per trap and was
not established. Rated MEDIUM (step 4: the 2-of-7 owner Safe can route the claim selector to a new implementation).

## Mechanism

The 839-byte router looks up the implementation for `msg.sig` and `DELEGATECALL`s it. In the claim transaction
`0xa7a26fca…` (selector `0x96051d56`, 2026-05-06) it delegates to `0xd569cb69…`, which reads the trap config
`0xa5d8daeb…` (a `BeaconProxy` created by `0x01c344b8`), calls it (`ClaimMade`, `ResponseFunctionInvoked(bool)`), pays
through `0x1975be6d…` ("Staked Drosera", sDRO) and the operator-registry contracts, and emits
`ClaimSubmitted(trapAddress, claimer, blockNumber)` from `0x01c344b8`. The calldata holds a G1 point (2 words) and a
G2 point (4 words) after the trap address, block number and two hashes. Implementations `0xd569cb69…` and
`0x1a9f207c…` each contain the BN254 field modulus and group order and one `STATICCALL` to precompile `0x08` with a
0x180-byte (two-pair) input. The pre-quantum check is therefore a BLS-style pairing over operator keys registered on
opt-in (`OperatorOptedIntoTrap`).

## Evidence

- CHECKED (Blockscout, block ~26,431,600, [`notes.md`](../evidence/drosera-bls-bn254/notes.md)):
  router unverified; created by EOA `0x4d1c87ec…` (an owner of the Safe), which also created `0x1975be6d…`
  (Blockscout name "Staked Drosera", `symbol()` = sDRO) and the implementations; the router created the trap configs
  (`BeaconProxy`, `UpgradeableBeacon` verified).
- CHECKED (transaction traces and logs of `0xa7a26fca…`, `0xf9850923…`, `0x9ff69a36…`): the calls and events above.
- CHECKED (bytecode of `0xd569cb69…` and `0x1a9f207c…`): BN254 constants and the pairing call with two pairs.
- CHECKED (precompile trace, `data/agg/ecpairing_sizes_y1.parquet`): 697 `ecpairing` calls from `0x01c344b8` in the
  last year, all with 2 pairs; last pre-quantum call at block 24,681,880.
- CHECKED (`onchain.json`, block 26,431,214): `owner()` = Safe `0xf5cd…8935`, threshold 2 of 7; ETH 0.036 (USD 65).
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16; last 2026-06-15
  ([`activity.json`](../evidence/drosera-bls-bn254/activity.json)).
- INFERRED: that the two-pair check verifies an aggregate BLS signature of the trap's operators (from the input shape
  and the opt-in flow; source unverified), and that operator public keys are on-chain from opt-in.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x01c344b8…` Drosera | yes (2-of-7 Safe) | USD 65 held; responses not measured | 2026-06-15 | 0 |

The router holds 0.036 ETH; the 40 trap configs created at router nonces 12–51 hold at most 0.002 ETH each. The real
stake is what each protected protocol's response function does when invoked (pausing, moving funds to a safe address,
or anything else), which is set per trap and not enumerated; `impact` is left `unknown`.

## Remediation

- Drosera routes the claim selector to an implementation that verifies operator attestations with a post-quantum
  scheme (hash-based signatures or a STARK over them); actor: Safe `0xf5cd…8935`. Operators re-register keys.
- Protected protocols can limit what an unconditional response call can do. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review15): MEDIUM kept (step 4: upgrade by the 2-of-7 Safe). Project identified as Drosera (deployer and "Staked Drosera" token, ClaimSubmitted/OperatorOptedIntoTrap events); mechanism PQ-7 SNARK -> PQ-6 BLS-style two-pair pairing (trigger trusted-setup -> committee-keys, impact funds-loss -> unknown); stays candidate (unverified source).
- 2026-11-17 integration: id renamed from `unidentified-01c344b8-snark-verifier` (project identified).
