---
id: f393d008-signer-upgrade-only
title: "0xf393d008: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf393d008077c97f2632fa04a910969ac58f88e3c"
  family: "0f9d932325e2c9eff5242f734097077b"
  upgradeable: "yes"
  admin: "no EIP-1967 admin/owner; gated by largeOracle 0x3435359df1d8c126ea1b68bb51e958fdf43f8272's own ECDSA-checked verifyContractUpdate"
  rating: LOW
  value_usd: 241755
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 79
  last_active: 2026-11-15
  recoveries_14d: 12
fix:
  layer: contract-upgrade
  who_acts: "whoever can satisfy the Partisia large-oracle verifier 0x343535…, called through its own ECDSA check"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live, independent (if also ecrecover-gated) authority can rotate the signer or upgrade. LOW, but flagged: the large oracle's own key is itself an ecrecover signer under the same EIP-8151 change, so if that key ever gets code the same class of failure applies one layer up. I could not read the large oracle's own signer address to confirm it currently has no code; worth a second look."
---

## Summary

A Partisia ETH-PBC bridge vault (UUPS). Withdrawals need a majority of 3 stored small-oracle signatures; the oracle set and the implementation are both replaced through an external 'large oracle' verifier that runs its own, separate ECDSA check.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x6191d13860d792487bbd89e63e4c877dbb56d397 with upgradeTo(bytes,address), called through its own checks.
- upgradeTo(bytes,address) hashes (this, oldImpl, newImpl) and calls largeOracle.verifyContractUpdate(message, signature); oracle rotation calls largeOracle.verifyUpdate the same way (source: WithdrawAndDeposit.sol upgradeTo/update)
- largeOracle = 0x3435359d… (shared with the sibling vault 0x74c0a194…), its implementation 0x1f0f3a80… decompiles to selectors 0xa7c5b111/0x1d574bc6 that both revert with OpenZeppelin's 'ECDSA: invalid signature' strings, i.e. a different ecrecover-based signer, not the 3 small oracles
- all 3 current small oracles (0xe3be9de4…, 0xebb5ed12…, 0x4a5e3cd9…) hold no code at 26438999

## Impact and exposure

- Value held at block 26,438,999: $241,755 (ETH and 49 priced tokens).
- Activity: 79 transactions called it in the 90 days before that block; last on 2026-11-15.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the small-oracle set or upgrade the implementation through the large-oracle verifier.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
