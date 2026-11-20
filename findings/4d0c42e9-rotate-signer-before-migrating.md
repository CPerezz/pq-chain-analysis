---
id: 4d0c42e9-rotate-signer-before-migrating
title: "0x4d0c42e9: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4d0c42e99b4be04d245de2380d14d41f69724c7d"
  family: "9b89d1b1f834782b7b4400f37d063157"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the COWS management key holders switch to a preset key"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "switchCowsManagementKey moves to one of the keys registered at deployment (9 left), so the key is rotated before it takes code; nothing is held: LOW."
---

## Summary

Not a Gemini custodian: this is COWSManagement (the registry for COWS custody containers). recognize/pauseCOWS/unpauseCOWS/switchCowsManagementKey accept signatures from the management key, CASTL keys and approver keys. The management key rotates among keys pre-registered at construction; the CASTL and approver keys come from each container. It holds no funds.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Same contract as the Sourcify-verified 0x4d0c42e9 COWSManagement (selectors recognize 0x67527e69, switchCowsManagementKey 0x28469e70, getRecognizeRecord 0xbdfa89b6 present): this is the verified source
- cmgtKeyLeft()=9, totalActiveContainers()=4, ETH balance 0 at block 26438999
- Source: recovered signers are checked against cowsManagementKeys[...]==Enabled, container.getCASTLKey(...) and container.isValidApprovalAddress(userId, key); switchCowsManagementKey expires the active key and enables an inactive one
- OZ ECDSA ecrecover; no 1271 fallback, no proxy

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before a management key holder gives its address code, switch to a pre-registered inactive management key via switchCowsManagementKey; CASTL and approver keys are read from each container.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
