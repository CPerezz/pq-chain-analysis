---
id: depunk-ce7a61d1-rotate-signer-before-migrating
title: "DePunk: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xce7a61d155623f5eb867a322100a5a6e2c917311"
  family: "cdf2aab3fd2a52c5f4c9b13c8d1ba2b4"
  copies: 2
  name: "DePunk"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2497
  last_active: 2026-11-17
  recoveries_14d: 3
fix:
  layer: onchain-config
  who_acts: "owner 0xfe93D561A66C7F71862219bBd640Bddb9f7eB1Be"
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
  note: "A live owner can call the setter, so a config call fixes it: LOW."
---

## Summary

DePunk checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: recoverFromVRFTimeout: an admin function; no signature / the recovered address must be the stored signer, or be in a stored set or role of signers / returns the recovered address, or compares it with…. Read from source.
- setter setSignerAddress(address) onlyOwner in verified source (cdf2aab3fd2a52c5f4c9b13c8d1ba2b4/source)
- owner() at block 26438999 = 0xfe93D561A66C7F71862219bBd640Bddb9f7eB1Be 7702-EOA nonce=828
- txs_90d=2497, last_active=2026-11-17

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,497 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
