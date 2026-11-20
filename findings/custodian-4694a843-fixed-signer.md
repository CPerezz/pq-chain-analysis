---
id: custodian-4694a843-fixed-signer
title: "Custodian: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4694a84398f5eed776c03033703c5caaa2ac6428"
  family: "6aa4c42501fb4af8478c9e5193487c91"
  copies: 3
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

Gemini-style Custodian: completeUnlock requires 2-of-N distinct signatures from a fixed `signerSet` set only in the constructor (no setter). completeUnlock gates an administrative callback (e.g. changing the token proxy's implementation/controls), not token transfers: ERC20 holders keep transferring/approving through the separate token proxy regardless of whether this Custodian's unlock mechanism still works. Same structure confirmed in this instance's own dossier.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Gemini Custodian completeUnlock: a caller signer and two more of a fixed signer set approve changes; holders keep transfers, the change control stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Custodian.sol (this dossier): signerSet set only in constructor, 2-signer completeUnlock gate (verified same structure)
- no setter for signerSet
- completeUnlock gates callbackAddress.call, not a token balance in this contract

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Primary deploys a new Custodian and the token proxy repoints to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
