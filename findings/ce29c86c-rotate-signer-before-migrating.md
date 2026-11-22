---
id: ce29c86c-rotate-signer-before-migrating
title: "0xce29c86c: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xce29c86c9e559eaa10fb824a75566445095d417c"
  family: "3cb6d0db88b28894b761356541a91679"
  copies: 3
  upgradeable: "no"
  rating: LOW
  txs_90d: 1131
  last_active: 2026-11-08
  recoveries_14d: 4
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x0004…e000"
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
  note: "Setter exists and the owner is a live EOA, so LOW holds."
---

## Summary

A contract that checks signatures against a single stored signer. It fails once that signer's account holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- setSigner(address) (0x6c19e783) requires msg.sender == owner (OZ 0x118cdaa7) and a non-zero argument, and writes the signer slot (decompile)
- owner() = 0x000438801500c89E225E8D6CB69D9c14dD05e000, an EOA with nonce 242, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,131 transactions called it in the 90 days before that block; last on 2026-11-08.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setSigner with a new EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
