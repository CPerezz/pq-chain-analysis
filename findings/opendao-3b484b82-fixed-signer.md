---
id: opendao-3b484b82-fixed-signer
title: "OpenDAO: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3b484b82567a09e2588a13d54d032153f0c0aee0"
  family: "f2c77622070d29288d2906cf60bbcc0f"
  name: "OpenDAO"
  label: "The OpenDAO: SOS Token"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 25447
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5343
  last_active: 2026-11-18
fix:
  layer: new-deployment
  who_acts: "OpenDAO keeps cSigner without code, or distributes the remaining claims another way"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "claims stop; nothing held for others is locked"
---

## Summary

`OpenDAO` (SOS token) at `0x3b484b82567a09e2588a13d54d032153f0c0aee0`. Claims need a signature of cSigner, fixed in the code; a cSigner with code ends claims. Token transfers are unaffected.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: OpenDAO claim: signed by cSigner, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: claim checks cSigner, a constant; no setter.
- Only the claim of the not-yet-claimed airdrop stops; balances and transfers do not use ECDSA.
- 5,343 transactions in the 90 days (mostly token transfers).

## Impact and exposure

- Value held at block 26,438,999: $25,447 (ETH and 49 priced tokens).
- Activity: 5,343 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Keep cSigner without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
