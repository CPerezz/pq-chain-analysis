---
id: virtualpaymentmanager-07bfa78d-rotate-signer-before-migrating
title: "VirtualPaymentManager: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x07bfa78d66d104fe9936201427400b0d78a2284c"
  family: "95f1dddb95873d0cbc38dca1ac4aba49"
  name: "VirtualPaymentManager"
  upgradeable: "no"
  rating: LOW
  value_usd: 13895
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the paying account's and the guardian account's owner devices"
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
  note: "LOW: device keys are rotatable on the account, and deposits leave by a direct call. Liveness of the guardian's devices was not enumerated."
---

## Summary

Archanova VirtualPaymentManager: withdrawPayment/depositPayment need a sender signature and a guardian signature, each recovered and checked against the account's device list. A device key that takes code stops signing.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Archanova verifyOwnerSignature: the signer must be an owner device of the account / Archanova virtual payment: the payment must be signed by a device of the paying account; the recipient withdraws…. Read from source.
- VirtualPaymentManager.sol AddressLibrary.verifySignature: when the address is a contract it recovers and checks devices(recovered) on that account; otherwise it requires recovered == address
- guardian 0x99819fed… is a 1563-byte Archanova account; its code contains the addDevice(address,bool) selector 0x811d54dc, so devices are replaceable
- withdrawDeposit (owner = msg.sender, after the lock period) moves deposits with no signature

## Impact and exposure

- Value held at block 26,438,999: $13,895 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The account owner adds a new device key (addDevice) and removes the one that will take code. Depositors can also withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
