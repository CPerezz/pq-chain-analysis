---
id: proofofxp-47e69cbd-rotate-signer-before-migrating
title: "ProofOfXP: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x47e69cbd049c4aa1bbeb74123737b91de95b238b"
  family: "c4e4fd0568b1d469e58cc599f03d522e"
  name: "ProofOfXP"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4211
  last_active: 2026-11-15
  recoveries_14d: 19
fix:
  layer: onchain-config
  who_acts: "owner 0x4540Fd07C9c586577ddB52BFFA9227337E1B7de5"
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

ProofOfXP checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: mints must be signed by the stored authorizedSigner (line read); setSigner replaces it. Read by hand. Executed: a real transaction reverts with code at the signer.
- setter setSigner(address) onlyOwner in verified source (c4e4fd0568b1d469e58cc599f03d522e/source)
- owner() at block 26438999 = 0x4540Fd07C9c586577ddB52BFFA9227337E1B7de5 EOA nonce=1
- txs_90d=4211, last_active=2026-11-15

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4,211 transactions called it in the 90 days before that block; last on 2026-11-15.
- 19 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
