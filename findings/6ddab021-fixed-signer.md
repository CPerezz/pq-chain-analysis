---
id: 6ddab021-fixed-signer
title: "0x6ddab021: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6ddab021daedcfba8c4e12911b906a69da0e6795"
  family: "37213de00d0f2f259b4d6e577c935e95"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 9252349
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 108260
  last_active: 2026-11-18
  recoveries_14d: 61698
fix:
  layer: new-deployment
  who_acts: "the operator keeps the quote key without code, or redeploys"
evidence:
  level: executed
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
  note: "operator's own inventory; fills stop if the quote key takes code; owner can withdraw"
---

## Summary

Contract `0x6ddab021daedcfba8c4e12911b906a69da0e6795`. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RFQ pool (5,127 ETH): quotes are checked against a signer that is a constant in the code; the pool also has withdraw. Bytecode and names. Executed: a real transaction reverts with code at the signer. Rated by hand: decompiled: the owner withdraws and escapes without a signature; the operator's own inventory.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode (24,269 bytes, no source): quotes are checked against a signer constant in the code; no function replaces it.
- A way out for the money: withdraw and escape are callable by the owner (0x12467a66b68791f4a7ad4e360d37d16f491ce6af) without a signature (decompiled); guardian 0x79f40744c827b81664a52c38398b7bef3187d3c6. The 5,127 ETH is the operator's own inventory.
- Executed: a real fill reverts once the quote signer has code.
- Busiest row of the pool: 108,260 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $9.3M (ETH and 49 priced tokens).
- Activity: 108,260 transactions called it in the 90 days before that block; last on 2026-11-18.
- 61,698 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
