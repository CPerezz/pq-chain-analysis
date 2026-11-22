---
id: native20-42ecf9bd-rotate-signer-before-migrating
title: "Native20: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x42ecf9bde9078d659663da66b97c4823f762005e"
  family: "7fd26ba342c42d6d8f4d80cd3312f914"
  copies: 5
  name: "Native20"
  upgradeable: "yes"
  rating: LOW
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1021
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "admin Safe 0xdb3270f4…dfbf"
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
  note: "Admin setter plus a direct path, live Safe."
---

## Summary

Kiln Native20: staking rights applied with an authorizer's ECDSA signature (AccountList). A signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: staking rights applied with an authorisation of the stored authorizer: helper read, setAuthorizer by name. Read by hand.
- MultiPool.sol:194 setAuthorizer onlyAdmin; authorize/clearAuthorizations (199, 209) also let the admin grant rights directly
- admin() = 0xdb3270f4b69128bcb6f56b65bc675c39ff7befdf, a Safe, 2 of 3 owners
- authorizer() = 0x0 at block, so the signed path is currently unusable anyway

## Impact and exposure

- Value held at block 26,438,999: $3,790 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 1,021 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The admin sets a new authorizer, or authorizes directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
