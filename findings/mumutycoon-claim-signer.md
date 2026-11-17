---
id: mumutycoon-claim-signer
title: "MUTY claim distributor (MUMUTYCOON, inferred): a quantum attacker who recovers the claim signer's ECDSA key can sign MUTY claims, but the distributor is empty"
project: mumutycoon
status: candidate
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0"
  implementation: null
  name: unverified claim distributor (claim(string,uint256,uint256,uint256,bytes), signer(), updateSigner(address))
  upgradeable: config-only
  admin: "owner EOA 0x7d7e03d8f6c3870752249cbea0f787690e29d462 (deployer) can call updateSigner; signer EOA 0x57f2969f27438bc1241837405fea7822d7851e76; no proxy"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-24
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer/owner 0x7d7e03d8f6c3870752249cbea0f787690e29d462: before refilling, replace the distributor with one that verifies post-quantum signatures or a Merkle root; updateSigner only rotates the ECDSA key"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mumutycoon-claim-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

An unverified contract pays out MUTY (MUMUTYCOON TOKEN) to callers of `claim(string,uint256,uint256,uint256,bytes)`
whose EIP-712 claim is signed by one backend ECDSA key, `signer()` (PQ-4). A quantum attacker who recovers that key
from a claim signature could sign claims for any amount, but the distributor holds no MUTY and no ETH now, and MUTY
has no market price. Rated LOW: step 4 gives MEDIUM (fix by a new deployment), step 5 lowers it (USD 0 held).

## Mechanism

- INFERRED from bytecode: `claim(string,uint256,uint256,uint256,bytes)` (selector `0x6b3a4851`) and an unnamed
  sibling (`0xbc1133de`) recover the signer of an EIP-712 message (`eip712Domain()` present) and compare it with
  `signer()`; `userNonces` and `SIGNATURE_VALIDITY_PERIOD` bound replay; the owner rotates the key with
  `updateSigner(address)`.
- What it releases: MUTY (`0xecdbe205…`) held by the distributor; Blockscout shows payouts from the distributor to
  claimants (for example 196 and 98 MUTY in February-March 2026).
- Pattern PQ-4. No verified source exists ([`source-excerpts.md`](#source-excerpts-mumutycoon-claim-signer)).

## Evidence

- CHECKED (bytecode, `cast code` 2026-11-17): selectors `0x6b3a4851` (claim), `0xbc1133de`, `0x238ac933`
  (`signer()`), `0xa7ecd37e` (`updateSigner`), `0x84b0196e` (`eip712Domain`) present; no upgrade selectors.
- CHECKED (`cast call`, latest block 2026-11-17): `signer()` = `0x57f2969f…` (EOA, nonce 0); `owner()` = `0x7d7e03d8…`
  (the creator, EOA, nonce 42); MUTY `balanceOf(distributor)` = 0
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mumutycoon-claim-signer/review-reads.json)).
- CHECKED (on-chain read at block 26,431,214): no ETH, no priced tokens
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mumutycoon-claim-signer/onchain.json)).
- CHECKED (precompile trace): 53,008 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu and Blockscout): no transactions in 2026-10-16 to 2026-11-16; last 2026-06-24
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mumutycoon-claim-signer/activity.json)).
- INFERRED: project attribution from the token paid out (MUMUTYCOON, verified token `0xecdbe205…`, created by
  `0xa8b26c6b…`, a different address from the distributor's deployer). Status stays candidate: the recover-and-compare
  check is inferred from selectors and the trace, not read in source.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x9f954ca5…` claim distributor (unverified) | config-only | $0 (0 MUTY, no ETH) | 2026-06-24 | 0 |

Forged claims can only pay out what the distributor holds, which is nothing; if the owner refills it, the refill is
exposed. MUTY has 1,134 holders and no Blockscout price.

## Remediation

- Post-quantum replacement: Merkle-root claims (hash-only) or post-quantum signature verification in a new
  distributor; `updateSigner` cannot change the scheme.
- Who acts: the owner `0x7d7e03d8…` (do not refill this contract). Protocol change: not needed. Claimants have no
  action to take.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review20): MEDIUM -> LOW, step 5: the distributor holds 0 MUTY and no ETH (measured, `held` $0);
  still active within 12 months (last 2026-06-24), so step 1 does not apply. Project set to `mumutycoon` from the token
  it pays out (inferred); signer and owner read on-chain; status stays candidate (bytecode only).
- 2026-11-17 integration: id renamed from `unidentified-9f954ca5-signer-key` (project identified).

# Source excerpts: mumutycoon-claim-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0`

No verified source on Sourcify or Blockscout.
