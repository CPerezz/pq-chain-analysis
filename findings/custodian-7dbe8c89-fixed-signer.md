---
id: custodian-7dbe8c89-fixed-signer
title: "Custodian: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7dbe8c89255ef2cb0d5573ce93fa11de52f73547"
  family: "08aee99a6fc90c1a9d8aa410f9272d00"
  copies: 6
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

Gemini-style Custodian: completeUnlock requires 2-of-N distinct signatures from a fixed `signerSet` set only in the constructor (no setter). completeUnlock gates an administrative callback, not token transfers, which remain open through the separate token proxy regardless of this contract's state.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Gemini Custodian completeUnlock: a caller signer and two more of a fixed signer set approve changes; holders keep transfers, the change control stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Custodian.sol (this dossier): signerSet set only in constructor, require(_signers.length>=2) (same structure verified)
- completeUnlock requires 2 distinct ecrecover results both in signerSet, gates callbackAddress.call
- no setter for signerSet

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Primary deploys a new Custodian and the token proxy repoints to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
