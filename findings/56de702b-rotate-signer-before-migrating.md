---
id: 56de702b-rotate-signer-before-migrating
title: "0x56de702b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x56de702beda3c03e26d13d5475bca5b365f89767"
  family: "1f513ad55876b1471011ff7601b15aef"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
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
  note: "Setter exists, owner is a live EOA."
---

## Summary

LayerZero-style DVN/executor: assignJob checks a signature from signer(); under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner(address) 0x6c19e783 (require msg.sender == hard-coded 0xb19f00e0…) is onlyOwner (heimdall decompile)
- owner() at 26438999 = 0xb19F00e095B1387061d73751C772bbA848D196b1, no code, nonce 108 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
