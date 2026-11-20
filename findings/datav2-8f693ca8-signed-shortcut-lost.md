---
id: datav2-8f693ca8-signed-shortcut-lost
title: "DATAv2: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x8f693ca8d21b157107184d29d398a8d082b38b76"
  family: "cf3e103bcc501424379878d72de46971"
  name: "DATAv2"
  label: "Streamr: DATA Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2233
  last_active: 2026-11-17
  recoveries_14d: 1
fix:
  layer: offchain
  who_acts: "the holder (calls approve/delegate/transfer directly)"
evidence:
  level: executed
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
  verdict: confirmed
  rating: LOW
  note: "signed shortcut only; the same act stays open to the same party by direct call → LOW"
---

## Summary

DATAv2 is an ERC-20 with permit; under EIP-8151 a holder whose address has non-delegation code can no longer use the signed path.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source. Executed: a real transaction reverts with code at the signer.
- signed path(s) in code: permit
- direct calls in code: approve, transfer (msg.sender-based ERC-20/votes, callable by the holder itself)
- no ERC-1271 isValidSignature selector (0x1626ba7e) in code: signer with code not handled on the signed path
- txs_90d 2233, last_active 2026-11-17; value not material to rating

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,233 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder uses approve/delegate/transfer from its own address instead of the signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
