---
id: tokendistributor-260924d3-rotate-signer-before-migrating
title: "TokenDistributor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x260924d36380cadf882d1a1514fba2eae26bbb91"
  family: "ef167be567ecbb60d5b275ad49b31445"
  copies: 12
  name: "TokenDistributor"
  upgradeable: "no"
  rating: LOW
  value_usd: 108815
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7591
  last_active: 2026-11-16
  recoveries_14d: 10
fix:
  layer: onchain-config
  who_acts: "operator EOA"
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
  note: "live operator"
---

## Summary

TokenDistributor claims check ECDSA.recover == signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- setSigner onlyOperator; operator immutable 0x7a39c6…
- operator EOA nonce 110; signer currently 0x0 (claims already off) (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $108,815 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 7,591 transactions called it in the 90 days before that block; last on 2026-11-16.
- 10 signature recoveries in the study's two-week trace window.

## Remediation

operator sets new signer

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
