---
id: r1exchange-c7c9b856-signed-shortcut-lost
title: "R1Exchange: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xc7c9b856d33651cc2bcd9e0099efa85f59f78302"
  family: "00b13f213357dba25d1c2854acd09013"
  copies: 2
  name: "R1Exchange"
  label: "R1Exchange"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 274654
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-09-03
fix:
  layer: none
  who_acts: "the user"
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
  note: "Withdrawal stays open by direct call, but trading has no direct path: the function dies and nothing is locked, so MEDIUM (study said LOW). Reviewer: decide whether a signed-only trade counts as 'same act open'."
---

## Summary

R1Exchange: the admin relays trades signed by maker and taker, plus withdrawals signed by the user (adminWithdraw). A user whose address has code can no longer trade; it can still withdraw by itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: R1Exchange adminWithdraw: the admin submits, the user named must have signed / R1Exchange trade: the admin submits; maker and taker must each have signed. Read from source.
- R1Exchange.sol:412 trade is onlyAdmin and needs the user signatures; there is no on-chain order path
- R1Exchange.sol:233,254 applyWithdraw/withdraw use msg.sender (the user's own exit after applyWait); deposit/depositToken direct
- Code is not upgradeable (row)

## Impact and exposure

- Value held at block 26,438,999: $274,654 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-09-03.

## Remediation

The user exits with applyWithdraw then withdraw; it trades from an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
