---
id: shrincswallet-ab41cfa5-rotate-signer-before-migrating
title: "ShrincsWallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xab41cfa52dab44ccb3c12e208816fe24a0d39a32"
  family: "b5e7b5d9de5d4ae7100551b8ae374920"
  copies: 6282
  name: "ShrincsWallet"
  upgradeable: "yes"
  rating: LOW
  value_usd: 363438
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4911
  last_active: 2026-11-17
  recoveries_14d: 3
fix:
  layer: account-migration
  who_acts: "SHRINCS key holder"
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
  note: "Key holder can rotate."
---

## Summary

Hybrid PQ wallet (6,282 proxies): ECDSA by owner() is a second gate on EntryPoint and ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a hybrid wallet: besides its hash-based signature, every user operation must carry an ECDSA signature that recovers to owner() / the account named must sign: ECDSA, else its ERC-1271 / Solady account…. Read from source. Executed: a real transaction reverts with code at the signer.
- transferOwnership(...) gated by SHRINCS keys with incoming owner acceptance (reading.keys)
- owner()=0xf9e4aaca…b277 is a 7702-delegated EOA (0xef0100…), nonce 603
- UUPS upgrade SHRINCS-gated

## Impact and exposure

- Value held at block 26,438,999: $363,438 (ETH and 49 priced tokens, over 6,282 addresses).
- Activity: 4,911 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

SHRINCS key holder moves owner to a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
