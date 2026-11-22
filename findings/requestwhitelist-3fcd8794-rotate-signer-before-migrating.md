---
id: requestwhitelist-3fcd8794-rotate-signer-before-migrating
title: "RequestWhitelist: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3fcd87948cbf46605d6ded0ed56d3daccd9daf9e"
  family: "71e2b3997620f1e1c0a034d1c2933d8c"
  copies: 2
  name: "RequestWhitelist"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 91
  last_active: 2026-11-17
  recoveries_14d: 10
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`RequestWhitelist` at `0x3fcd87948cbf46605d6ded0ed56d3daccd9daf9e`, with 1 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: QuorumSigLib: each signature from a validator of the set, checked with Solady SignatureCheckerLib; validators are added and removed by calls or by signed quorum. Read from source.
- Reviewed through the root issue's mechanism: the checked signers are a committee or validator set that its own quorum replaces by a signed update, so while enough keys are still EOAs the set rotates before migrating: LOW, as for wallets their own signers can upgrade
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 91 transactions called it in the 90 days before that block; last on 2026-11-17.
- 10 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
