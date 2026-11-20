---
id: booaeth-bc48fd45-rotate-signer-before-migrating
title: "BOOAEth: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbc48fd45aaaf6549293056606397d351a100b222"
  family: "7a77508b1b73c43b0591d08296b765ef"
  name: "BOOAEth"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1160
  last_active: 2026-11-17
  recoveries_14d: 14
fix:
  layer: onchain-config
  who_acts: "owner 0xbA7682862fBFBc9E5215462c00A48E486142A77E"
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

BOOAEth checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- setter setOperatorSigner(address) onlyOwner in verified source (7a77508b1b73c43b0591d08296b765ef/source)
- owner() at block 26438999 = 0xbA7682862fBFBc9E5215462c00A48E486142A77E EOA nonce=478
- txs_90d=1160, last_active=2026-11-17

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,160 transactions called it in the 90 days before that block; last on 2026-11-17.
- 14 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
