---
id: sunperpvault-9ac0c8ba-rotate-signer-before-migrating
title: "SunperpVault: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9ac0c8bade28dfe1f44ae4fd75465e3cce6f0152"
  family: "99bea6bbf4c8f172d689619bad72f958"
  copies: 2
  name: "SunperpVault"
  upgradeable: "yes"
  admin: "upgrader Safe 0x09D2Fa4c9536C58A672b469e017654E9d61b4923 (proxy 0x4d1be6c39fe3fb1362ff602a6c0cbb5b3bf64ec7)"
  rating: LOW
  value_usd: 220698
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 40
  last_active: 2026-11-15
  recoveries_14d: 6
fix:
  layer: onchain-config
  who_acts: "ADMIN_ROLE / upgrader Safe 0x09D2…4923"
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
  note: "Setter and live upgrader Safe."
---

## Summary

SunperpVault: withdrawals need every validator of a registered set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Sunperp vault: recovered signers matched against the validator list given in the call; here all of the power must sign. Read from source. Executed: a real transaction reverts with code at the signer.
- addValidator/removeValidator by ADMIN_ROLE
- live proxy 0x4d1be6c3…ec7: upgrader()=0x09D2Fa4c…4923, 2-of-3 Safe; this address is the implementation

## Impact and exposure

- Value held at block 26,438,999: $220,698 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 40 transactions called it in the 90 days before that block; last on 2026-11-15.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Admin registers a new validator set.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
