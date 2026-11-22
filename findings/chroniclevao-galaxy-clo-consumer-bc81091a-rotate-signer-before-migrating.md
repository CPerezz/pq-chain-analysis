---
id: chroniclevao-galaxy-clo-consumer-bc81091a-rotate-signer-before-migrating
title: "ChronicleVAO_Galaxy_CLO_Consumer_1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbc81091a00e98a7fcb969102d921e85bfb4bfcbd"
  family: "9aea754c0d270d7a9b7c238e704b2c10"
  copies: 28
  name: "ChronicleVAO_Galaxy_CLO_Consumer_1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3792
  last_active: 2026-11-18
  recoveries_14d: 361
fix:
  layer: onchain-config
  who_acts: "authed party 0x74258A92611e029b748F79c50024DD851339dB15"
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
  note: "LOW: a live EOA holds auth over the validator set. I didn't read the validator setter names myself."
---

## Summary

ChronicleVAO_Galaxy_CLO_Consumer_1: Chronicle VAO consumer: a quorum of ECDSA validators, or a Schnorr signature checked through ecrecover; the validator sets are managed by authorised callers (setters not read). Read by hand. Executed:

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Chronicle VAO consumer: a quorum of ECDSA validators, or a Schnorr signature checked through ecrecover; the validator sets are managed by authorised callers (setters not read). Read by hand. Executed: a real transaction reverts with code at the signer.
- authed() at block 26438999 (reth) = [0x74258A92611e029b748F79c50024DD851339dB15], the only authorised caller; the row note says the validator sets are managed by authorised callers
- 0x74258A92…dB15 has no code (latest, block ~26452926, publicnode): an EOA that can call the validator setters

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 28 addresses).
- Activity: 3,792 transactions called it in the 90 days before that block; last on 2026-11-18.
- 361 signature recoveries in the study's two-week trace window.

## Remediation

The authed EOA rotates any validator whose address will take code before it does.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
