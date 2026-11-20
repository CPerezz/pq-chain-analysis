---
id: controller-0f4d59fd-rotate-signer-before-migrating
title: "Controller: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0f4d59fd4c0235200cc111604b92db325df6b75d"
  family: "cbdc63588e47f98a2771cff09f9ccc90"
  name: "Controller"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
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
  note: "Setter exists, owner is a live EOA."
---

## Summary

StarRail Controller: reward claims need a signature from approver; under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setApprover). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setApprover(address) is onlyOwner (Sourcify verified source (line 1671))
- owner() at 26438999 = 0xDDE75F5Fa5B1337D30B46610Ea84A98e8Bc43258, no code, nonce 14 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
