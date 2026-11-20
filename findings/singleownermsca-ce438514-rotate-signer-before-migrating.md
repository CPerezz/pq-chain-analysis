---
id: singleownermsca-ce438514-rotate-signer-before-migrating
title: "SingleOwnerMSCA: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xce43851485f437005ef3c1821e250c4d3c53b946"
  family: "ee56db4b331991182d72f2d55ff8f62b"
  copies: 7712
  name: "SingleOwnerMSCA"
  label: "Binance 129"
  upgradeable: "yes"
  rating: NONE
  value_usd: 4177821670
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1023987
  last_active: 2026-11-18
  recoveries_14d: 3612
fix:
  layer: none
  who_acts: "account owner"
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
  verdict: refuted
  rating: NONE
  note: "Refuted under the scale's rule: a signer with code is handled through ERC-1271 on the same signature path. The study's executed revert comes from code without ERC-1271. If the reviewer reads SignatureChecker fall-through as LOW instead, the setter path holds anyway."
---

## Summary

Circle SingleOwnerMSCA (ERC-4337/6900 account, proxy to 0xd206ac7f). The owner is checked by OZ SignatureChecker; when ECDSA fails it falls through to ERC-1271 on the owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Circle single-owner modular account: the owner is checked with SignatureChecker, so an owner with code is asked through ERC-1271; the owner can also call the account itself and hand it over…. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- reading.first.json on_failure: tryRecover miss -> staticcall owner.isValidSignature (OZ SignatureChecker.sol L25-28)
- owner can call the account directly and transferNativeOwnership; UUPS upgrade is owner-authorised
- state.json: eip1967_implementation 0xd206ac7f..., admin 0

## Impact and exposure

- Value held at block 26,438,999: $4,177.8M (ETH and 49 priced tokens, over 7,712 addresses).
- Activity: 1,023,987 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,612 signature recoveries in the study's two-week trace window.

## Remediation

An owner moving to code should implement ERC-1271, or hand ownership to a new key first.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
