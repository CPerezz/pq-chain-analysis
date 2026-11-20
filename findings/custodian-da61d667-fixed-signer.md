---
id: custodian-da61d667-fixed-signer
title: "Custodian: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xda61d66733aed3d203359fa76e30ecb1457c3af3"
  family: "0b2bd29f21ce8da3c58a55e64b7c56f5"
  copies: 10
  name: "Custodian"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no funds in this contract"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Same mechanism as the other Custodian copies -> MEDIUM."
---

## Summary

Gemini-style Custodian: completeUnlock requires 2-of-N distinct signatures from a fixed `signerSet` set only in the constructor (no setter). Gates an administrative callback, not token transfers, which remain open through the separate token proxy.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Gemini Custodian completeUnlock: a caller signer and two more of a fixed signer set approve changes; holders keep transfers, the change control stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Custodian.sol (this dossier): signerSet set only in constructor (same structure verified)
- completeUnlock requires 2 distinct ecrecover results both in signerSet, gates callbackAddress.call
- no setter for signerSet; this instance has 4 same-bytecode deployments per facts.json, this one is a direct deployment (not a proxy)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Primary deploys a new Custodian and the token proxy repoints to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
