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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/fabric-robo-airdrop-signer
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
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/fabric-robo-airdrop-signer/notes.md
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
lets the owner replace the signer. Pattern PQ-4. Reads: [`notes.md`](#review-reads-fabric-robo-airdrop-signer-2026-11-17-review07).

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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 4: emptied on 2026-08-05, holds nothing and has no allowance.
  Project identified as Fabric Protocol (ROBO token created by the same deployer); `project` set to
  `fabric-protocol`, id kept. Status confirmed on bytecode plus the `ecrecover` trace.
- 2026-11-17 integration: id renamed from `unidentified-b8a4deb1-signer-key` (project identified).

# Source excerpts: fabric-robo-airdrop-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8`

No verified source on Sourcify or Blockscout.

# Review reads: fabric-robo-airdrop-signer (2026-11-17, Review07)

## Identity (Blockscout, 2026-11-17)

- `0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8`: unverified; created 2026-02-26 by EOA
  `0x53e25a0123da7c5ed4fb8874c891211da1186181` (tx `0xa3160e1e…ede5`).
- The same EOA created token `0x32b4d049fe4c888d2b92eecaf729f44df6b1f36e` (verified `ERC20Token`; Blockscout token
  name "Fabric Protocol", symbol ROBO, 10,000,000,000 supply, market cap $8.9M, 18,638 holders).
- All token transfers out of the contract are ROBO: `claim` transfers to claimants in 2026-03, and on 2026-08-05 a
  transfer of 115,904,535.80 ROBO to the owner Safe `0x1e63183fb2123f0674582a5a2d251e72de0bd8bf`.

## Bytecode (`cast code`, block 26,431,597; 4,378 bytes)

- Selectors present: `claim(bytes32,uint256,address,bytes32[],bytes)` 0x877634db, `trustedSigner()` 0xf74d5480,
  `updateTrustedSigner(address)` 0x7530625f, `merkleRoot()` 0x2eb4a7ab, `owner()` 0x8da5cb5b, `token()` 0xfc0c546a.
- The "\x19Ethereum Signed Message:\n32" prefix is embedded, and a `staticcall` to precompile 0x01 (`6001…5afa`).
- Precompile trace (`data/report/curated_contracts.csv`): 23,088 transactions with `ecrecover` in the last year.

## On-chain reads (`cast`, publicnode, blocks 26,431,597–26,431,715)

- `trustedSigner()` = `0x10f0ccfdcf78a4cbbe7580e0427c23b7c8abcf19`; `owner()` = Safe `0x1e63…d8bf`, threshold 3 of
  5 (owners `0x0afd6db4…184c`, `0x9965b24d…d3d9`, `0x4e08e84f…dc78`, `0xdcfc3dd6…76fc`, `0x8636f27d…87ff`);
  `token()` = ROBO; `merkleRoot()` = `0xf44be381…f30e`.
- ROBO `balanceOf(contract)` = 0; ROBO `allowance` to the contract from the Safe and from the deployer = 0; ETH 0.
