---
id: 000000000004-rotate-signer-before-migrating
title: "0x00000000: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x000000000004598d17aad017bf0734a364c5588b"
  family: "084bc264d64e31c2e0e92511f24135b1"
  copies: 4
  upgradeable: "yes"
  admin: "owner 0x61e8ac0a758afeefbd556f713ecf0a8cbd00288f"
  rating: LOW
  txs_90d: 15736
  last_active: 2026-11-18
  recoveries_14d: 990
fix:
  layer: onchain-config
  who_acts: "owner 0x61e8…288f (EOA with 7702 delegation)"
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
  verdict: confirmed
  rating: LOW
  note: "setter callable by a live (7702-delegated) EOA."
---

## Summary

Upgradeable contract: atomic fills signed by a stored signer set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole, setAtomicFillSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- setAtomicFillSigner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts; grantRole/revokeRole also named
- owner() = 0x61e8ac0a… EOA with EIP-7702 delegation, nonce 3256; upgradeTo by owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 15,736 transactions called it in the 90 days before that block; last on 2026-11-18.
- 990 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key with the setter before the signer's account takes non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
