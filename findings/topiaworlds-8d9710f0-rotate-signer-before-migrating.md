---
id: topiaworlds-8d9710f0-rotate-signer-before-migrating
title: "TopiaWorlds: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8d9710f0e193d3f95c0723eaaf1a81030dc9116d"
  family: "06bff137abb306ff9830dc46524e592e"
  name: "TopiaWorlds"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1117
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner 0x156fb9dB (EOA, nonce 93)"
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
  note: "The setter is callable by a live EOA owner."
---

## Summary

TopiaWorlds ERC721. Its update path checks signatures from a stored update approver. Under EIP-8151 an approver with code is rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setUpdateApprover). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall: setUpdateApprover(address) requires owner == msg.sender ('Ownable: caller is not the owner')
- probed owner 0x156fb9dB EOA nonce 93 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,117 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls setUpdateApprover with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
