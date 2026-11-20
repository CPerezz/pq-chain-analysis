---
id: 07012021-rotate-signer-before-migrating
title: "0x07012021: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0701202173ebf83eff0f735115497b5baa2afb8f"
  family: "d9e443dd40961578534de7a5724f6518"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 21474
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
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: The setter exists, but the admin has never transacted, so it cannot be shown live. Without it there is no rotation, and the rating would depend on whether funds are locked (not established)."
---

## Summary

Unverified contract: ecrecover is compared to a stored validator, and changeValidator replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a validator address with a setter (changeValidator). Bytecode and names.
- decompiled: changeValidator(address) requires msg.sender == admin (store); changeAdmin has the same gate
- admin 0xdad8…859 has no code and nonce 0 at 26438999, i.e. it never sent a transaction

## Impact and exposure

- Value held at block 26,438,999: $21,474 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin calls changeValidator, if that key is still held.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
