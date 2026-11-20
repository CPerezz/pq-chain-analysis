---
id: everpay-38741a69-rotate-signer-before-migrating
title: "EverPay: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x38741a69785e84399fcf7c5ad61d572f7ecb1dab"
  family: "244e6e23dc9f13c0229c85dd2b913416"
  copies: 3
  name: "EverPay"
  upgradeable: "no"
  rating: LOW
  value_usd: 192547
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 107
  last_active: 2026-11-16
  recoveries_14d: 12
fix:
  layer: onchain-config
  who_acts: "owners (2 of 3)"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Quorum-signed rotation while 2 owners stay EOA."
---

## Summary

EverPay multisig vault: proposals need 2 of 3 owner signatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: EverPay: owners are added, removed and replaced by functions of the contract; the operator has a setter (the function that compares the recovered address was not read). Read by hand. Executed: a real transaction loses its effect with code at the signer.
- addOwner/removeOwner/replaceOwner onlyWallet = 2 owners signing (reading.keys)
- getOwners 3, required 2 (state.json)

## Impact and exposure

- Value held at block 26,438,999: $192,547 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 107 transactions called it in the 90 days before that block; last on 2026-11-16.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Remaining EOA owners replace an owner with code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
