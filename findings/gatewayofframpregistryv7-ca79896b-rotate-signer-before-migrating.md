---
id: gatewayofframpregistryv7-ca79896b-rotate-signer-before-migrating
title: "GatewayOfframpRegistryV7: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xca79896bcec80aa7628d67c6fac85bdf6ae63b1c"
  family: "c80e90020abb64a6d00b53b649f90db8"
  copies: 4
  name: "GatewayOfframpRegistryV7"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3705
  last_active: 2026-11-18
  recoveries_14d: 734
fix:
  layer: onchain-config
  who_acts: "owner"
evidence:
  level: source-read
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
  note: "Setter callable by a live EOA owner."
---

## Summary

GatewayOfframpRegistryV7; orders need the stored orderSigner's signature. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- GatewayOfframpRegistryV7.sol: setOrderSigner(address) onlyOwner
- owner() = 0x1bf42Bbf…; owner is an EOA (no code, nonce 6906) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 3,705 transactions called it in the 90 days before that block; last on 2026-11-18.
- 734 signature recoveries in the study's two-week trace window.

## Remediation

Owner sets a new order signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
