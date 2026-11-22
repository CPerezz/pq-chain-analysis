---
id: 215e278c-rotate-signer-before-migrating
title: "0x215e278c: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x215e278c44787dffd33b58311a0e9bb0657c1d8d"
  family: "804b95e3b9f8855cac1af231544b59b1"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 104304
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3387
  last_active: 2026-11-18
  recoveries_14d: 267
fix:
  layer: onchain-config
  who_acts: "default admin"
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
  note: "live admin EOA"
---

## Summary

Unverified UUPS claim contract; signer role checked by recovery.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- AccessControlEnumerable grantRole/revokeRole (heimdall)
- DEFAULT_ADMIN member 0x7a4a50… EOA nonce 3 (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $104,304 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,387 transactions called it in the 90 days before that block; last on 2026-11-18.
- 267 signature recoveries in the study's two-week trace window.

## Remediation

admin grants role to new signer

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
