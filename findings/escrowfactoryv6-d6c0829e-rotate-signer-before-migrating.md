---
id: escrowfactoryv6-d6c0829e-rotate-signer-before-migrating
title: "EscrowFactoryV6: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd6c0829e2cdb458f755d9d3ab44e934729750f58"
  family: "ebbb93979f2ede99251a0f1b3b7b04c8"
  name: "EscrowFactoryV6"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4241
  last_active: 2026-10-23
fix:
  layer: onchain-config
  who_acts: "owner EOA"
evidence:
  level: bytecode
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
  note: "Owner-only setter exists and the owner is a live EOA."
---

## Summary

EscrowFactoryV6 keeps an owner-set approver set (with a threshold) for signed approvals; approvers holding code would no longer be recovered.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setApprovers, setOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: setApprovers(address[],uint256) and setOperator(address) require msg.sender==owner (error 0x30cd7471)
- eth_call at block 26438999: setApprovers([x],1) from owner 0x7815…65D7 succeeds, from 0xdead reverts 0x30cd7471
- owner 0x781551402FBa10Bb3dF20A3391DA5AA43d5E65D7 is an EOA, nonce 11 (probe); approvers()=[0x7aB0c85770c8901015E36749B6cF0D375A6F2fcA]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4,241 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

Owner replaces the approver set with plain keys before any approver takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
