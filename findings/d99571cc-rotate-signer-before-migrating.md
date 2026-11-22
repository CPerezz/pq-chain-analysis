---
id: d99571cc-rotate-signer-before-migrating
title: "0xd99571cc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd99571cc34bfc41bf469a8f346db4d32d7e957e1"
  family: "0f5943ea33595f90fba7ffd75c527dc0"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 2075
  last_active: 2026-11-17
  recoveries_14d: 71
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
  note: "Owner-only signer set management exists; the owner is a live EOA."
---

## Summary

ERC-4337 paymaster (EntryPoint v0.6) that checks a stored set of verifying signers; a signer with code would make sponsored ops fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addVerifyingSigner, addVerifyingSigners, removeVerifyingSigners). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall decompile: addVerifyingSigner 0x451263f4, addVerifyingSigners 0x43e3b518, removeVerifyingSigners 0xd88c13e0 all require msg.sender==owner ('Ownable: caller is not the owner')
- eth_call at block 26438999: addVerifyingSigner from owner succeeds, from 0xdead reverts with the Ownable message
- owner 0x3a150dA906A8f90d054d97187ee897A9eA32D0CD is an EOA, nonce 3 (probe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,075 transactions called it in the 90 days before that block; last on 2026-11-17.
- 71 signature recoveries in the study's two-week trace window.

## Remediation

Owner adds a plain-key signer and removes the affected one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
