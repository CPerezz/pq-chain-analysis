---
id: atspaymaster-fc5ab245-rotate-signer-before-migrating
title: "ATSPaymaster: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfc5ab2451c28a2e92a2ea90e126e1f890c75df9e"
  family: "f5e34fbb0157adf7a90766f5cd1187d8"
  name: "ATSPaymaster"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4264
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xb42f…8e6d"
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
  note: "Setter exists and is callable by a live Safe owner."
---

## Summary

ATSPaymaster (ERC-4337 paymaster) accepts user ops only with a signature from a stored backendSigner. If that signer key account gets code, every sponsorship check fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setBackendSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompile: setBackendSigner(address) requires msg.sender == owner (OZ Ownable custom error 0x118cdaa7), writes signer slot, emits BackendSignerSet
- owner() at block 26438999 = 0xb42f545bF8AB1A1Ba968e21a32E553d25fdF8e6d, Safe 2-of-3 (probed)
- 4264 txs in 90d, last active 2026-11-17 (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4,264 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner Safe calls setBackendSigner(newEOA) before the current signer migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
