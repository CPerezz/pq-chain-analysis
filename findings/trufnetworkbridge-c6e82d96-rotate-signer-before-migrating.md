---
id: trufnetworkbridge-c6e82d96-rotate-signer-before-migrating
title: "TrufNetworkBridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc6e82d96d2b0204e6467b67752817939ec6162e9"
  family: "810f9edc36464c369fe65d6f8f337b2f"
  copies: 4
  name: "TrufNetworkBridge"
  upgradeable: "yes"
  rating: LOW
  value_usd: 8842
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 55
  last_active: 2026-11-17
  recoveries_14d: 4
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
evidence:
  level: executed
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`TrufNetworkBridge` at `0xc6e82d96d2b0204e6467b67752817939ec6162e9`, with 3 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (attester, validator, signer, author), ordered or counted once; a threshold is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Reviewed through the root issue's mechanism: the checked signers are a committee or validator set that its own quorum replaces by a signed update, so while enough keys are still EOAs the set rotates before migrating: LOW, as for wallets their own signers can upgrade
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $8,842 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 55 transactions called it in the 90 days before that block; last on 2026-11-17.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
