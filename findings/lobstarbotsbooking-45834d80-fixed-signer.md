---
id: lobstarbotsbooking-45834d80-fixed-signer
title: "LobstarbotsBooking: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x45834d801dfdf136a17abce0e5738fc600ec6989"
  family: "ac346c2bf213c3ff299c6e555cb89862"
  name: "LobstarbotsBooking"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project owner"
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
  note: "A service function dies, nothing locked: MEDIUM."
---

## Summary

LobstarbotsBooking: bookSlot needs a signature from the constant _signerAddress 0x542e…6061. Booking dies if that key takes code. No funds are involved.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: constant _signerAddress; no setter
- signer has no code (latest, block ~26453066)
- state.json at block 26438999: balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new booking contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
