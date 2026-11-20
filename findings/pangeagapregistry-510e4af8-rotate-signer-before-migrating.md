---
id: pangeagapregistry-510e4af8-rotate-signer-before-migrating
title: "PangeaGapRegistry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x510e4af8136dcd18c794cdc4b7aba3af13c57c3a"
  family: "443d00afbdb47429a2c73f3d4da89057"
  name: "PangeaGapRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 12160
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x9362…8ab6"
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
  note: "setters callable by a live EOA."
---

## Summary

PangeaGapRegistry: co-signer and delivery keys stored; a key with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setBridgeFeeBps, setCoSigner, setDeliveryKey, setGapExecutor). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompile: setCoSigner(uint8,address) and setDeliveryKey(uint8,address) require msg.sender == owner; setCoSigner eth_call from owner succeeds, from 0x…dEaD reverts 0x30cd7471
- owner() = 0x93620a4a… EOA, nonce 6923

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 12,160 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Rotate the key with the setter before the signer's account takes non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
