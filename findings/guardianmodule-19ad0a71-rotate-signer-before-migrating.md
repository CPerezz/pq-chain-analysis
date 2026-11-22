---
id: guardianmodule-19ad0a71-rotate-signer-before-migrating
title: "GuardianModule: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x19ad0a7153e192fa10a75954e4c5e259cafc47bc"
  family: "f5434cc20eef3b117344c7ed16d22880"
  copies: 4
  name: "GuardianModule"
  label: "Puffer: Guardian Module"
  upgradeable: "no"
  rating: LOW
  value_usd: 283
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-10-30
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`GuardianModule` at `0x19ad0a7153e192fa10a75954e4c5e259cafc47bc` (Etherscan tag: Puffer: Guardian Module), with 3 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: GuardianModule _validateSignatures: a threshold of the guardians its caller lists. Read (function text).
- Reviewed through the root issue's mechanism: the checked signers are a committee or validator set that its own quorum replaces by a signed update, so while enough keys are still EOAs the set rotates before migrating: LOW, as for wallets their own signers can upgrade
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $283 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-30.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
