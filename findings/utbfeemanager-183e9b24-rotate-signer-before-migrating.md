---
id: utbfeemanager-183e9b24-rotate-signer-before-migrating
title: "UTBFeeManager: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x183e9b247521fe2149516c98ce2dd0e2367bb6fa"
  family: "a905692ed5a154bab376f6e74d877334"
  copies: 2
  name: "UTBFeeManager"
  upgradeable: "no"
  rating: LOW
  txs_90d: 95882
  last_active: 2026-11-18
  recoveries_14d: 16756
fix:
  layer: onchain-config
  who_acts: "admin/owner EOA 0x690f…6f4c"
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
  note: "setter callable by a live EOA."
---

## Summary

UTB fee manager: fee quotes must be signed by the stored signer; a signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- UTBFeeManager.sol:16 setSigner(address) onlyAdmin; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x690f4e2f… EOA, nonce 1067

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 95,882 transactions called it in the 90 days before that block; last on 2026-11-18.
- 16,756 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key with the setter before the signer's account takes non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
