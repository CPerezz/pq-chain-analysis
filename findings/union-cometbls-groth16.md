---
id: union-cometbls-groth16
title: "Union: a quantum attacker with the CometBLS Groth16 setup trapdoor (and a relayer key) can forge a Union light-client header on Ethereum and release the $12k held by Union's ZKGM bridge app"
project: union
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x7700ea295f62989d2c98721389a521c96fe3c4c0"
  implementation: "0xf2b24b085080cef91f7bffdc6358fe054999e15f"
  name: ERC1967Proxy (UUPS) → CometblsClient
  upgradeable: "yes"
  admin: "AccessManager 0x40cdff51ae7487e0b4a4d6e5f86eb15fb7c1d9f4; upgradeToAndCall needs ADMIN_ROLE, held by Safe 0x6a742078f90c2e16d8c9f83e41749410c314edd4 (5 of 8), no execution delay; read at block 26,431,454"
  value_usd: 11870
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-29
  txs_30d: 84
families: []
fix:
  layer: contract-upgrade
  who_acts: "Union: Safe 0x6a742078f90c2e16d8c9f83e41749410c314edd4 (5 of 8, ADMIN_ROLE in AccessManager 0x40cdff51ae7487e0b4a4d6e5f86eb15fb7c1d9f4) upgrades CometblsClient"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/union-cometbls-groth16/classification.jsonl
  - evidence/union-cometbls-groth16/onchain.json
  - evidence/union-cometbls-groth16/activity.json
  - evidence/union-cometbls-groth16/source-excerpts.md
  - evidence/union-cometbls-groth16/notes.md
  - evidence/union-cometbls-groth16/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review11 (Claude), finding review
  ref: evidence/union-cometbls-groth16/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Union's IBC light client on Ethereum accepts a new Union header when a Groth16 proof on BN254 shows that the Union
validators signed it (PQ-7). With the setup trapdoor, a quantum attacker can prove a header with any state root and then
prove fake IBC packets against it, releasing what Union's UCS03 ZKGM app `0x5fbe74a2…` holds ($11.9k on 2026-11-17) or
minting its wrapped tokens; header updates must come from a permissioned relayer account, whose ECDSA key is also
recoverable. Rated LOW: MEDIUM by step 4 (the client is a UUPS proxy that Union's 5-of-8 admin Safe can upgrade),
lowered by step 5 (escrow under $50k).

## Mechanism

- `IBCHandler.updateClient` → `CometblsClient.updateClient` (line 400, `onlyIBC`) → `verifyHeader` (line 336) →
  `internalVerifyZKP` (line 608) → `CometblsZKVerifier.verifyProof` (line 190): Groth16 with a Pedersen commitment
  (`verifyProofCommitmentPOK`, line 158), pairing precompile `0x08`. The new consensus state's root then backs
  `verifyMembership` (line 477), which the IBCHandler uses to accept packets for apps such as ZKGM.
- The circuit attests CometBLS (BN254 BLS) validator signatures on the Union chain, so the Union validator set is a
  second pre-quantum dependency behind the same check.
- Upgrades: `_authorizeUpgrade` (line 648) is `restricted` by AccessManager `0x40cdff51…`; `upgradeToAndCall` maps to
  ADMIN_ROLE.

## Evidence

- CHECKED (verified source, Sourcify): the path above
  ([`source-excerpts.md`](../evidence/union-cometbls-groth16/source-excerpts.md),
  [`notes.md`](../evidence/union-cometbls-groth16/notes.md)).
- CHECKED (on-chain read, block 26,431,454): implementation slot, `IBC_HANDLER()`, `authority()`, upgrade function role 0,
  `hasRole(0, Safe 0x6a742078…)` = true with delay 0, Safe threshold 5 of 8; ZKGM `0x5fbe74a2…` uses the same handler and
  manager.
- CHECKED (Blockscout, 2026-11-17): ZKGM holds $11,870 in tokens and no ETH; IBCHandler holds nothing
  ([`escrow.json`](../evidence/union-cometbls-groth16/escrow.json)).
- CHECKED (Xatu, any function): 84 transactions reached the client 2026-10-16 to 2026-11-16; last 2026-10-29
  ([`activity.json`](../evidence/union-cometbls-groth16/activity.json)).
- INFERRED: that ZKGM is the only app on this IBCHandler with funds; other ports were not enumerated.

## Impact and exposure

| Contract | Upgradeable | Escrow secured | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7700ea29…` CometblsClient | yes (AccessManager admin Safe) | $11.9k in ZKGM `0x5fbe74a2…` | 2026-10-29 | 84 |

Escrow basis, 2026-11-17: ZKGM's token balances (uniBTC, U, LBTC, SolvBTC, WETH). Wrapped tokens ZKGM would mint on a
forged packet are not counted. Yearly pre-quantum count from the census: 8,096 transactions (`txs_y1`).

## Remediation

- Union replaces the Groth16/BN254 header proof with a hash-based proof (STARK/FRI or WHIR) over a post-quantum validator
  signature scheme and upgrades `0x7700ea29…` through AccessManager `0x40cdff51…` (ADMIN_ROLE Safe `0x6a742078…`, 5 of 8).
  The Union chain's CometBLS validator keys need a post-quantum replacement for the proof to mean anything.
- The admin can pause the client (`pause`, PAUSER role) in an emergency. No protocol change is needed. Users can bridge
  their assets out.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM -> LOW, step 5: escrow measured, UCS03 ZKGM 0x5fbe74a2… holds $11.9k (under $50k). Upgrade authority traced to ADMIN_ROLE Safe 0x6a742078… (5 of 8).
