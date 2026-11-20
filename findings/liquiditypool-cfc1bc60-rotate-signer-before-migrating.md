---
id: liquiditypool-cfc1bc60-rotate-signer-before-migrating
title: "LiquidityPool: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcfc1bc6013ed89d484c626dd9ee5eb7bc1a1d9da"
  family: "adb08b465cdeff594e3ffd81de34c9f2"
  copies: 2
  name: "LiquidityPool"
  upgradeable: "yes"
  rating: LOW
  value_usd: 318144
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 849
  last_active: 2026-11-18
  recoveries_14d: 139
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE Safe 0xFE53…19B4"
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
  note: "Live Safe admin."
---

## Summary

LiquidityPool (UUPS): swaps need stored maintainer signature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the user named must have signed the swap (ECDSA only); sent by a role holder / the user named must have signed the lock (ECDSA only); sent by a role holder / the recovered address must be the stored…. Read from source. Executed: a real transaction reverts with code at the signer.
- setMaintainer gated by DEFAULT_ADMIN_ROLE (reading.keys)
- getRoleMember(0x00,0)=0xFE530A48…19B4, a 2-of-3 Safe at block
- maintainer slot_1=0x6228ab40…8919

## Impact and exposure

- Value held at block 26,438,999: $318,144 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 849 transactions called it in the 90 days before that block; last on 2026-11-18.
- 139 signature recoveries in the study's two-week trace window.

## Remediation

Admin Safe calls setMaintainer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
