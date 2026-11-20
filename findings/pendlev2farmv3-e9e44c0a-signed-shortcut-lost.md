---
id: pendlev2farmv3-e9e44c0a-signed-shortcut-lost
title: "PendleV2FarmV3: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xe9e44c0a68c49ade51cda5e027909c5996b5c71a"
  family: "8fc800a1d2989a60e940c7511ac539e0"
  name: "PendleV2FarmV3"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1281
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The farm itself never recovers a signature; CoW settlement checks are outside this address."
---

## Summary

PendleV2FarmV3 (infiniFi farm) places CoW orders by calling GPv2Settlement.setPreSignature; the recoverOrderFromTrade/ecrecover code the study matched belongs to the imported CoW library, not to this farm.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: CoW settlement swap: passes the trade to recoverOrderFromTrade / hands each trade to recoverOrderFromTrade; the signing schemes are checked there / CoW recoverOrderFromTrade: takes the owner from…. Read (function text).
- CoWSwapBase._signOrder calls settlement.setPreSignature(orderUid, true): a pre-signature, no ecrecover (src/integrations/CoWSwapBase.sol).
- Dossier scanner.json (complete: true) lists no STATICCALL to 0x01; bytecode has setPreSignature selector 0xec6cb13f but not settle 0x13d79a0b.
- txs.json: "no recovery by this code in the traced window".

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,281 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
