---
id: broker-ba3ed686-signed-shortcut-lost
title: "Broker: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xba3ed686cc32ffa8664628b1e96d8022e40543de"
  family: "51aaaebcfe09c0c0e50b7826edb8c663"
  name: "Broker"
  label: "Switcheo Exchange"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "user with code (announceWithdraw then slowWithdraw)"
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
  verdict: confirmed
  rating: MEDIUM
  note: "Trading has no direct twin, so LOW does not hold; funds are not locked, so MEDIUM. The main reviewer should check that trading counts as the 'act'. Value $10106, txs_90d 0 (not rating inputs)."
---

## Summary

Switcheo-style Broker: the operator submits offers, fills and withdrawals that the user signed. A user with code can no longer trade; its balance still leaves by announceWithdraw plus slowWithdraw.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: an exchange broker: the operator submits offers, fills and withdrawals signed by the user (read); by its function names a user can announce a withdrawal and take it by its own call after a delay…. Read by hand.
- source Broker: makeOffer/fillOffer/withdraw carry the user's signature (operator-relayed); there is no direct offer path
- announceWithdraw (msg.sender) then slowWithdraw(_withdrawer,…) after withdrawAnnounceDelay; announceCancel/slowCancel exist for offers
- no upgrade path (row upgradeable=no)

## Impact and exposure

- Value held at block 26,438,999: $10,106 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Exit with announceWithdraw/slowWithdraw and announceCancel/slowCancel.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
