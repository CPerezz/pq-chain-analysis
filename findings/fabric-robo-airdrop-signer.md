---
id: fabric-robo-airdrop-signer
title: "Fabric Protocol (ROBO) airdrop claim contract, emptied in August 2026: a quantum attacker who recovers the trusted signer key could co-sign claims, but nothing is left to claim"
project: fabric-protocol
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8"
  implementation: null
  name: unverified Merkle airdrop with trusted signer (ROBO)
  upgradeable: config-only
  admin: owner Safe 0x1e63183fb2123f0674582a5a2d251e72de0bd8bf (3 of 5; updateTrustedSigner)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-08-05
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: Fabric Protocol (owner Safe 0x1e63183fb2123f0674582a5a2d251e72de0bd8bf); nothing is needed while the contract is empty; a future airdrop should use the Merkle proof alone or a post-quantum signer
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/fabric-robo-airdrop-signer/classification.jsonl
  - evidence/fabric-robo-airdrop-signer/onchain.json
  - evidence/fabric-robo-airdrop-signer/activity.json
  - evidence/fabric-robo-airdrop-signer/source-excerpts.md
  - evidence/fabric-robo-airdrop-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/fabric-robo-airdrop-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This unverified contract distributed the ROBO token (Fabric Protocol): `claim` takes a Merkle proof and a signature
from one ECDSA `trustedSigner` key (PQ-4). A quantum attacker who recovers that key could co-sign claims. The contract
was emptied on 2026-08-05 (115.9M ROBO returned to the owner Safe) and holds nothing, with no approval to pull more.
Rated LOW (step 4): the path is dormant and holds nothing.

## Mechanism

From bytecode: `claim(bytes32,uint256,address,bytes32[],bytes)` (0x877634db) checks a Merkle proof against
`merkleRoot()` and an "\x19Ethereum Signed Message:\n32"-prefixed signature recovered with the `ecrecover` precompile
and compared with `trustedSigner()`, then transfers `token()` (ROBO) to the claimant. `updateTrustedSigner(address)`
lets the owner replace the signer. Pattern PQ-4. Reads: [`notes.md`](../evidence/fabric-robo-airdrop-signer/notes.md).

## Evidence

- CHECKED (bytecode, `cast code` at block 26,431,597): selectors above, the signed-message prefix and a `staticcall`
  to precompile 0x01.
- CHECKED (precompile trace to March 2026): 23,088 transactions with `ecrecover` in the last year; Blockscout shows
  them as `claim` calls in 2026-03.
- CHECKED (`cast` at blocks 26,431,597–26,431,715): `trustedSigner()` `0x10f0ccfd…cf19`; `owner()` Safe
  `0x1e63183f…d8bf` (3 of 5); `token()` ROBO `0x32b4d049…`; ROBO balance 0; ROBO allowance from the Safe and the
  deployer 0; ETH 0.
- CHECKED (Blockscout): the contract and the ROBO token were both created by EOA `0x53e25a01…6181`; the token is
  named "Fabric Protocol" (ROBO); on 2026-08-05 the remaining 115,904,535.80 ROBO were transferred to the owner Safe.
- INFERRED: the exact check order inside `claim` (whether both the Merkle proof and the signature are required) is
  not established without verified source.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb8a4deb1…` ROBO airdrop (unverified) | config-only (signer) | $0 | 2026-08-05 | 0 |

The contract holds no ROBO and has no allowance; a forged claim transfers nothing. It would matter again only if the
owner refunded it.

## Remediation

- Nothing is required while the contract stays empty. If Fabric Protocol reuses it, or runs another airdrop, the
  claim should rely on the Merkle proof alone or verify a post-quantum signer (ERC-1271 / ERC-7913).
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 4: emptied on 2026-08-05, holds nothing and has no allowance.
  Project identified as Fabric Protocol (ROBO token created by the same deployer); `project` set to
  `fabric-protocol`, id kept. Status confirmed on bytecode plus the `ecrecover` trace.
- 2026-11-17 integration: id renamed from `unidentified-b8a4deb1-signer-key` (project identified).
