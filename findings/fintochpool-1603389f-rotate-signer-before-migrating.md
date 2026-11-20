---
id: fintochpool-1603389f-rotate-signer-before-migrating
title: "FintochPool: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1603389febe71629b5e51dc1b1f983c9b7bd37e1"
  family: "c53c105b473a63e99da0bb20b3ae528c"
  copies: 38
  name: "FintochPool"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 429
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "pool owners / users"
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
  rating: MEDIUM
  note: "Not a rotation: the owners are set in the constructor and nothing adds or replaces them, so the operators' spend path dies for good if their keys take code; token holders still redeem directly, so nothing is locked: MEDIUM."
---

## Summary

FintochPool: owner multisig (constructor-fixed owners[], required) authorises spend/spendERC20/setAllowInternalCall by ecrecover; if owners take code, the owner spend path dies.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: FintochPool _validMsgSignature: required distinct owners must sign. Read (function text).
- owners/required set only in the constructor; the only other writer is renounceOwnership (deletes owners); no add/replace owner (verified source lines 214-253)
- _validMsgSignature: ecrecover then _distinctOwners, no ERC-1271 (line 408-425)
- redemption(destination,value) lets token holders burn FTH and withdraw the source asset with no signature (line 350)

## Impact and exposure

- Value held at block 26,438,999: $429 (ETH and 49 priced tokens, over 38 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners must not move their keys to code-bearing accounts; else redeploy. Holders keep redemption.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
