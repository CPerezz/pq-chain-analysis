---
id: transitstation-49aaa987-signed-shortcut-lost
title: "TransitStation: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28"
  family: "9dfa848db54fd7f30b6f1f1c5bffa865"
  name: "TransitStation"
  label: "deployed by Paxos Labs: Deployer 1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3690
  last_active: 2026-11-18
  recoveries_14d: 75
fix:
  layer: offchain
  who_acts: "the user (approves the offer token first); Safe owner for quoteSigner"
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
  rating: LOW
  note: "direct approve path exists and the stored signer is rotatable by a live Safe → LOW"
---

## Summary

Paxos Labs TransitStation: submitOrderWithPermit calls the offer token's permit (solmate) for msg.sender; quotes are signed by a stored quoteSigner.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / the recovered address must be the stored signer, or be in a stored set or…. Read from source. Executed: a real transaction reverts with code at the signer.
- TransitStation.sol: a failed permit falls back to an allowance check, so approve on the token then submitOrder/submitOrderWithPermit works for the same user
- quote check: ECDSA.recover == quoteSigner; setQuoteSigner(address) requiresAuth
- owner() at block = 0x0000000000417626Ef34D62C4DC189b021603f2F, a Safe 3-of-5 (nonce 1); quoteSigner 0xE4a40e9E04eb7F33368D998FD423073b778Ce420 has no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,690 transactions called it in the 90 days before that block; last on 2026-11-18.
- 75 signature recoveries in the study's two-week trace window.

## Remediation

user approves directly; owner Safe can rotate quoteSigner if it ever needs code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
