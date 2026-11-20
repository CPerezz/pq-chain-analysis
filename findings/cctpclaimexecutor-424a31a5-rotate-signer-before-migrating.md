---
id: cctpclaimexecutor-424a31a5-rotate-signer-before-migrating
title: "CctpClaimExecutor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x424a31a57f7c63918ecaa2fac38016a8af5a6ec2"
  family: "46b9bf64958a11a4d6fd17668bd014d8"
  name: "CctpClaimExecutor"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2165
  last_active: 2026-11-18
  recoveries_14d: 247
fix:
  layer: onchain-config
  who_acts: "owner 0x0E1B5AB67aF1c99F8c7Ebc71f41f75D4D6211e53"
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

CctpClaimExecutor checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: claims authenticated by a solver signer: helper read, comparison with storage by the scanner, setSolverSigner by name. Read by hand.
- setter setSolverSigner(address) onlyOwner in verified source (46b9bf64958a11a4d6fd17668bd014d8/source)
- owner() at block 26438999 = 0x0E1B5AB67aF1c99F8c7Ebc71f41f75D4D6211e53 EOA nonce=2715
- txs_90d=2165, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,165 transactions called it in the 90 days before that block; last on 2026-11-18.
- 247 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
