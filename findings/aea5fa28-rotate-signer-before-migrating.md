---
id: aea5fa28-rotate-signer-before-migrating
title: "0xaea5fa28 (tagged deployed by Multibit: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaea5fa28cf2b56dea9d1dea2ac8e76e799143a28"
  family: "0d407e2003a26a9a1f9747111842b2ec"
  label: "deployed by Multibit: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 14617
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "admin (EOA 0x05aec747…)"
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
  note: "Setter with a live EOA admin."
---

## Summary

No-source contract with a stored signer set: signatures must come from an authorized signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: signers added and removed by functions. Bytecode and names.
- heimdall decompile: addSigner/removeSigner/setPendingAdmin require msg.sender == admin ('unauthorized')
- admin() 0x05aec747…: EOA, nonce 100

## Impact and exposure

- Value held at block 26,438,999: $14,617 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin adds a fresh EOA signer and removes the migrating one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
