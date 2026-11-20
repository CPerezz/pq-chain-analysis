---
id: cloneablewallet-77ba78c1-rotate-signer-before-migrating
title: "CloneableWallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x77ba78c10efb5100ce93e611f01e272f1b9ced84"
  family: "93fafd5825dfb8c934c0ab8145f1b7a7"
  copies: 10278
  name: "CloneableWallet"
  upgradeable: "no"
  rating: LOW
  value_usd: 374807
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-10
fix:
  layer: account-migration
  who_acts: "authorized pair or recoveryAddress"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Key holder and recovery path live."
---

## Summary

Older Dapper CloneableWallet (10,278 copies): signer/cosigner pairs authorise invokes.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Dapper wallet ERC-1271 (older): signer and cosigner must be a recorded pair / Dapper wallet invoke1CosignerSends (older) / Dapper wallet invoke1SignerSends (older) / Dapper wallet invoke2 (older). Read from source.
- setAuthorized/setRecoveryAddress via authorized invoke; emergencyRecovery by recoveryAddress msg.sender (reading.keys)

## Impact and exposure

- Value held at block 26,438,999: $374,807 (ETH and 49 priced tokens, over 10,278 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

Rotate pair or emergencyRecovery.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
