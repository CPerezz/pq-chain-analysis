---
id: anylauncher-95e0da37-rotate-signer-before-migrating
title: "AnyLauncher: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x95e0da371711502eed78bcc3f17856b4415120ca"
  family: "78e4ef47a7380b7112573bc16d6f2c13"
  name: "AnyLauncher"
  upgradeable: "no"
  rating: LOW
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1408
  last_active: 2026-11-03
fix:
  layer: onchain-config
  who_acts: "controller 0x81EE…da5a"
evidence:
  level: bytecode
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
  note: "stored-key setter callable by a live controller EOA"
---

## Summary

AnyLauncher: prices signed by a stored priceSigner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setPriceSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setPriceSigner(address) requires msg.sender == platformController ("not controller") in decompile
- platformController() = 0x81EE2B6BcfcF9a614036578e5E4f2B02e507da5a at block 26438999; EOA with EIP-7702 delegation, nonce 19166

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens).
- Activity: 1,408 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

controller sets a fresh EOA price signer

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
