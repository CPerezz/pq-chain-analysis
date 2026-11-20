---
id: 79fc41a5-rotate-signer-before-migrating
title: "0x79fc41a5: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x79fc41a5a0fe5ab087425ec0c5961cff6ce71a29"
  family: "06ebf83b082b1ee1d40023e0bf44883c"
  upgradeable: "no"
  rating: LOW
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0xb0c71e33690601d85f581b64b4f2e66854cc0937"
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
  note: "The setter is callable by a live EOA owner: LOW. txs_90d 0."
---

## Summary

Unverified contract whose withdrawETH checks a signature against a stored signer. Signed withdrawals die if the signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: setSigner 0x6c19e783 stores the new signer only if msg.sender == owner, else reverts
- owner()=0xb0c7…0937 (slots 0 and 1): EOA, nonce 55 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,106 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setSigner with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
