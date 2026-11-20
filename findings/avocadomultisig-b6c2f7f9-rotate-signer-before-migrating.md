---
id: avocadomultisig-b6c2f7f9-rotate-signer-before-migrating
title: "AvocadoMultisig: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb6c2f7f91b099b0c42ff6a1e2d91ed7998781fff"
  family: "d3212a1c71b51e6831d5041d34824de2"
  copies: 109
  name: "AvocadoMultisig"
  label: "deployed by Instadapp: Avocado Broadcaster 3"
  upgradeable: "yes"
  rating: NONE
  value_usd: 7549016
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25
  last_active: 2026-11-11
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "The code is checked first, so the claim fails."
---

## Summary

AvocadoMultisig variant. The signer's code size is read first; signers with code go to ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Avocado multisig: each signer must be in the allowed list; a signer with code is taken as a contract signer, otherwise ECDSA.recover must equal it. Read from source. Executed: a real transaction reverts with code at the signer.
- reading d3212a1c: verdict clear; EIP-8151 changes nothing beyond gas
- family d3212a1c: 109 addresses, 1.32 ETH; same _verifySig code-size-first check as the e87531 family

## Impact and exposure

- Value held at block 26,438,999: $7.5M (ETH and 49 priced tokens, over 109 addresses).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-11-11.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
