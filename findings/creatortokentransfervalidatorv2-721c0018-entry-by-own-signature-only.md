---
id: creatortokentransfervalidatorv2-721c0018-entry-by-own-signature-only
title: "CreatorTokenTransferValidatorV2: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x721c00182a990771244d7a71b9fa2ea789a3b433"
  family: "4cb2a5994f9b0aeef0f5fba7f700454f"
  name: "CreatorTokenTransferValidatorV2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2379
  last_active: 2026-11-14
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Entry only; behaviour matches the design intent. value_usd None, txs_90d 2379."
---

## Summary

Limit Break CreatorTokenTransferValidatorV2 / EOARegistry: a caller proves it is an EOA by signing. By design, an account with code must not register.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Limit Break EOARegistry verifySignature: the caller proves it is an EOA by signing; a caller with code cannot / Limit Break EOARegistry verifySignatureVRS: the caller proves it is an EOA by signing;…. Read (function text).
- note/function text: verifySignature and verifySignatureVRS record msg.sender as an EOA when the recovered signer equals msg.sender
- registration holds no assets; code accounts can't sign today either

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,379 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
