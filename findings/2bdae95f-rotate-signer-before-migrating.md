---
id: 2bdae95f-rotate-signer-before-migrating
title: "0x2bdae95f: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2bdae95f45424029e72b1d8fd3dfb7ca3cd36b35"
  family: "c5b508b2a743a7a33faad6b9c05ffb24"
  copies: 2
  upgradeable: "yes"
  rating: NONE
  txs_90d: 8910
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "Code-first check, the OZ SignatureChecker pattern: an owner with code is handled. The proxies using this code were not identified (no dossier), so this rests on the decompile."
---

## Summary

Unverified UUPS Ownable2Step contract (an implementation: owner zero, 1967 slot empty) whose isValidSignature checks the stored owner. If the owner has code it asks the owner through ERC-1271 and only falls back to ecrecover otherwise.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (acceptOwnership, renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- heimdall decompile (L013/hc_2bdae) of selector 0x1626ba7e: `if (store_b.code.length)` → ERC-1271 branch, else ECDSA; store_b is the owner slot (onlyOwner checks use msg.sender == store_b)
- owner() = 0x0 and EIP-1967 impl slot = 0 at block 26438999 (implementation contract)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 8,910 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
