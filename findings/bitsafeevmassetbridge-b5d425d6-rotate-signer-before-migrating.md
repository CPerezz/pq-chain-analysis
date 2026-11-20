---
id: bitsafeevmassetbridge-b5d425d6-rotate-signer-before-migrating
title: "BitSafeEvmAssetBridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5d425d678b10949dd0f7bb0dd0427c47451d57e"
  family: "3a8dddb40d28144e29bb9451bcbb2250"
  copies: 2
  name: "BitSafeEvmAssetBridge"
  label: "deployed by DLC.Link: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 172335
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25
  last_active: 2026-11-17
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "admin Safe 0xb282…1d63"
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

BitSafe bridge: withdrawals need 2 attestor signatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: BitSafe bridge withdraw: at least `threshold` distinct signers holding the attestor role. Read from source. Executed: a real transaction reverts with code at the signer.
- grantRole/revokeRole ATTESTOR_ROLE by DEFAULT_ADMIN_ROLE; owner()=0xb28270e6…1d63, Safe threshold 3
- proxy admin 0x393aa3ca…41ad owned by timelock 0x518aDA72…f317

## Impact and exposure

- Value held at block 26,438,999: $172,335 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Admin Safe rotates attestors.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
