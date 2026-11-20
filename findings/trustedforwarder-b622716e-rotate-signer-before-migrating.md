---
id: trustedforwarder-b622716e-rotate-signer-before-migrating
title: "TrustedForwarder: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb622716ed56fb618f8b9c414644255b0de3c8097"
  family: "c2e6f3b3455ed8dadbfbf21578107d5c"
  copies: 256
  name: "TrustedForwarder"
  label: "deployed by Jiri123: White Hat"
  upgradeable: "no"
  rating: LOW
  txs_90d: 24247
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x1cac…166c"
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
  note: "setter callable by a live EOA."
---

## Summary

TrustedForwarder: forwarded calls signed by a stored app signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: forwarded calls signed by a stored app signer: helper read, updateSigner by name. Read by hand.
- TrustedForwarder.sol:168 updateSigner(address) onlyOwner; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x1cac5af9… EOA, nonce 119

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 256 addresses).
- Activity: 24,247 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner calls updateSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
