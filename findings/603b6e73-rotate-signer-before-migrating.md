---
id: 603b6e73-rotate-signer-before-migrating
title: "0x603b6e73: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x603b6e737278eaa71a3a1630174f2452841a1c5c"
  family: "b7bf95e01566843d561af033e614cff4"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8295
  last_active: 2026-11-18
  recoveries_14d: 1358
fix:
  layer: onchain-config
  who_acts: "owner 0x31781b4E…0FC4 (EOA)"
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
  note: "Owner-only setter, live EOA."
---

## Summary

Unverified proxy (impl 0x891edf35…) accepting signatures from a set of trusted signers. A signer with code loses its effect.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setConfig, setTrustedSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction loses its effect with code at the signer.
- heimdall impl: setTrustedSigner(address,bool) (0xbacf9946) requires msg.sender == owner ('!owner'); setOwner same
- owner() = 0x31781b4E7FB61756BD0a0Ef7850d5e7bf6270FC4, no code, nonce 7323

## Impact and exposure

- Value held at block 26,438,999: $2,887 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 8,295 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,358 signature recoveries in the study's two-week trace window.

## Remediation

The owner adds a trusted signer without code and removes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
