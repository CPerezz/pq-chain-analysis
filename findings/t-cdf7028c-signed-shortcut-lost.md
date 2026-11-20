---
id: t-cdf7028c-signed-shortcut-lost
title: "T: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcdf7028ceab81fa0c6971208e83fa7872994bee5"
  family: "29dd25fb3c7f487fe108c57bed74e019"
  name: "T"
  label: "Threshold Network: T Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 52031
  last_active: 2026-11-18
  recoveries_14d: 4
fix:
  layer: none
  who_acts: "the affected holder, by calling approve/delegate itself"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: same act open by approve/delegate to the same party; only a signing convenience is lost."
---

## Summary

T: permit and delegateBySig require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Threshold T token permit: the owner named must have signed / Threshold T token delegateBySig: the signatory named must have signed. Read from source. Executed: a real transaction reverts with code at the signer.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- delegate(address) is the direct path for delegateBySig (0x5c19a95c present)
- row note: Threshold T token permit: the owner named must have signed / Threshold T token delegateBySig: the signatory named must have signed. Read from source. Executed: a real transaction reverts with code at the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 52,031 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve/delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
