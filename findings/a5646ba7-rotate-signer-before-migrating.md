---
id: a5646ba7-rotate-signer-before-migrating
title: "0xa5646ba7 (tagged deployed by Artem: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa5646ba7f8fa7339f3de65d08d9667451abcb024"
  family: "84c7bf48c50b5f65d6834ef000b98bd7"
  copies: 2
  label: "deployed by Artem: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 20392
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "admin"
evidence:
  level: bytecode
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
  note: "There is a setter and a live EOA admin."
---

## Summary

Unverified proxy (impl 0x843e…f601): ecrecover is compared to a stored signOwner, and setSignOwner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSignOwner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompiled impl: setSignOwner requires msg.sender == admin ('Auth failed')
- admin 0xb230…04f6 is an EOA, nonce 269

## Impact and exposure

- Value held at block 26,438,999: $20,392 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin calls setSignOwner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
