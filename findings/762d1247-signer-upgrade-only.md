---
id: 762d1247-signer-upgrade-only
title: "0x762d1247: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x762d1247aa6322e3acd1b57c976ae04c3f142c5d"
  family: "e6287d6c29643042f9f5f418fa2997e8"
  copies: 5
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "distributor owner 0x78e2CBb208DfBa45a48B4297A1Da6504bC729990"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path, but only airdrop stock the operator put there, recoverable by owner: MEDIUM. Reviewer: the claim window looks closed (end timestamp 2025) and the clone is empty, which could support refuted-by-time; timestamp meaning was inferred from getStorage layout, not decoded from source. Owner identity/liveness and the zero token balance were read only at latest (publicnode); the MEDIUM rating does not depend on them (operator stock either way)."
---

## Summary

EIP-1167 clone of a signed token-claim distributor ('0.4.x-FungibleTokenECDSADistributor', impl 0xa6ebd8deb40ecf2d3efcdc2c04ee18f68798c613); claims need a signature from the stored signer 0xe584f4c82e460c5f640b758186e14574a245f56d (keyless-looking EOA), with no setter and no working upgrade in a clone; the owner sweeps the claim stock with withdraw(bytes).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template ad8cefc3, not read on its own.
- Update path, read at block 26,438,999: delegates to a fixed address. 1 with an upgrade function whose caller was not read.
- code is a 45-byte EIP-1167 clone of 0xa6ebd8deb40ecf2d3efcdc2c04ee18f68798c613; the impl's upgradeToAndCall is onlyProxy (requires ERC-1967 slot == impl), which a clone cannot satisfy
- getStorage() (latest, block ~26452900; settable state, context only): owner 0x78e2CBb208DfBa45a48B4297A1Da6504bC729990, signer-like EOA 0xe584f4c82e460c5f640b758186e14574a245f56d (nonce 0, no code), token 0x28d38df637db75533bd3f71426f3410a82041544 (PROMPT), two timestamps (apparently claim start/end) both in 2025
- verify(address,bytes32,bytes): ecrecover only when signer has no code; no 0x1626ba7e in the impl bytecode (no ERC-1271 fallback)
- withdraw(bytes) is onlyOwner and sends the whole token balance (or ETH) to owner (code, impl decompile)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner deploys a new distributor with a fresh signer; leftover stock is already sweepable by withdraw(bytes).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
