---
id: weightedecdsavalidator-ed892441-rotate-signer-before-migrating
title: "WeightedECDSAValidator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xed89244160cfe273800b58b1b534031699dfeeee"
  family: "cb2cbf36aea2370a461e2eeee7d205a3"
  name: "WeightedECDSAValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 7389
  last_active: 2026-11-18
  recoveries_14d: 1001
fix:
  layer: account-migration
  who_acts: "the kernel account (renew) or the guardian by direct call"
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
  note: "The per-account setter (the account itself) and a direct path exist."
---

## Summary

Kernel v3 WeightedECDSAValidator: guardians vote by ECDSA signature or by direct approve(). A guardian with code loses only the signature paths.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Kernel weighted validator approveWithSig: guardians of the account vote by signature; a guardian can also approve by its own call; the account replaces guardians with renew / Kernel weighted…. Read from source. Executed: a real transaction reverts with code at the signer.
- dossier reading: renew(_guardians,_weights,_threshold,_delay) is callable by the kernel (state keyed by msg.sender); no module admin
- approve() counts msg.sender's guardian weight, so a guardian with code can vote by its own call; WeightedECDSAValidator.sol:162,215,232,248,293 are plain ECDSA.recover

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,389 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,001 signature recoveries in the study's two-week trace window.

## Remediation

The kernel replaces the guardian via renew, or the guardian approves by direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
