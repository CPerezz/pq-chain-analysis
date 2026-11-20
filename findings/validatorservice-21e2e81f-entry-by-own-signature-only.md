---
id: validatorservice-21e2e81f-entry-by-own-signature-only
title: "ValidatorService: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x21e2e81fcfc25ca91fec5ec2466476d167336418"
  family: "1cda35ce04df1e1476f4c48101f51ac0"
  copies: 2
  name: "ValidatorService"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the validator (link an EOA node address)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Entry only; nothing held is behind the signature."
---

## Summary

SKALE ValidatorService: linkNodeAddress requires the named node address to sign the validatorId. A node address with code cannot be linked.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: SKALE ValidatorService linkNodeAddress: the node address named must sign to be linked. Read (function text).
- ValidatorService.sol L258-269: the signature only gates linking a new node address to the caller's validator
- unlinkNodeAddress (L276) needs no signature; ValidatorService holds no funds (delegations are held elsewhere)
- state.json: 0 ETH at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed; validators link an EOA node key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
