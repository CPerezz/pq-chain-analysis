---
id: bridgevault-6c70c6a2-rotate-signer-before-migrating
title: "BridgeVault: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6c70c6a2b6b2b0d40e826bfde89fe2e081ca408b"
  family: "5ac31e7217d4e1673aba6e48aecbf520"
  name: "BridgeVault"
  upgradeable: "no"
  rating: LOW
  value_usd: 103762
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 79
  last_active: 2026-11-16
  recoveries_14d: 39
fix:
  layer: onchain-config
  who_acts: "owner timelock"
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
  note: "live timelock via Safe"
---

## Summary

BridgeVault redeem loops ECDSA.recover over stored signers.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set, each counted once; a threshold is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- addSigner/removeSigner onlyOwner (BridgeVault.sol:199-219)
- owner 0x99d3cf… TimelockController 48h; proposer 0xdb1a35… Safe 1/1, owner EOA nonce 9 (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $103,762 (ETH and 49 priced tokens).
- Activity: 79 transactions called it in the 90 days before that block; last on 2026-11-16.
- 39 signature recoveries in the study's two-week trace window.

## Remediation

timelock schedules signer swap

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
