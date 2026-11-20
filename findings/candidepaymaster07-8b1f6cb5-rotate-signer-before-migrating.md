---
id: candidepaymaster07-8b1f6cb5-rotate-signer-before-migrating
title: "CandidePaymaster07: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8b1f6cb5d062aa2ce8d581942bbb960420d875ba"
  family: "348afe82857f062fbae84048482c9b0e"
  name: "CandidePaymaster07"
  label: "Candide: Paymaster"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 12982
  last_active: 2026-11-18
  recoveries_14d: 2452
fix:
  layer: onchain-config
  who_acts: "owner"
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
  note: "Key holder is a live EOA and can hand over ownership."
---

## Summary

CandidePaymaster07; paymaster data must be signed by owner(). Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner of the contract. Read from source. Executed: a real transaction reverts with code at the signer.
- CandidePaymaster07.sol:275 owner() != recover(sig) fails; Ownable transferOwnership
- owner() = 0x3cfDc212…; owner is an EOA (no code, nonce 55857) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens).
- Activity: 12,982 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,452 signature recoveries in the study's two-week trace window.

## Remediation

Owner transfers ownership to a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
