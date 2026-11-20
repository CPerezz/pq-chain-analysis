---
id: ecdsaproofsystem-1ac760d5-rotate-signer-before-migrating
title: "ECDSAProofSystem: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1ac760d5c985c635c18a3e5d9c5685f1ef2a721e"
  family: "f8e7017de188aea3ad8a139320c537b1"
  copies: 2
  name: "ECDSAProofSystem"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1424
  last_active: 2026-11-18
  recoveries_14d: 183
fix:
  layer: onchain-config
  who_acts: "owner 0xcEAF908C05B277E92e89b51B281Ec76305b9A141"
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

ECDSAProofSystem checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a proof is a signature of the stored signer (lines read); setSigner replaces it. Read by hand. Executed: a real transaction reverts with code at the signer.
- setter setSigner(address) onlyOwner in verified source (f8e7017de188aea3ad8a139320c537b1/source)
- owner() at block 26438999 = 0xcEAF908C05B277E92e89b51B281Ec76305b9A141 EOA nonce=54
- txs_90d=1424, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,424 transactions called it in the 90 days before that block; last on 2026-11-18.
- 183 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
