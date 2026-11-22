---
id: identity-9d4bcc06-rotate-signer-before-migrating
title: "Identity: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9d4bcc065788787515f9baac673bf44cfb9d389c"
  family: "7afdaae8c65efc8ea4b6ca93035d7251"
  copies: 2065
  name: "Identity"
  label: "deployed by Ambire Wallet: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 27971
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-07
fix:
  layer: account-migration
  who_acts: "privileged key holder (account user)"
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
  note: "Same act stays open by direct call and keys are replaceable by the holder."
---

## Summary

AdEx Identity (proxy to 0x96e3…9d3a): execute() accepts signatures from keys whose privilege is Transactions or higher. A privileged key with code cannot sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: AdEx Identity SignatureValidator: true when the recovered address equals the signer its caller names / the recovered address must hold the transactions privilege in the identity; privileges are set…. Read from source.
- executeBySender lets a privileged key call directly with msg.sender, no signature (Identity.sol ~482)
- setAddrPrivilege is callable only by the identity itself, i.e. via execute or executeBySender, so a privileged key rotates keys by direct call
- No admin; the user's own keys are the live party

## Impact and exposure

- Value held at block 26,438,999: $27,971 (ETH and 49 priced tokens, over 2,065 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-07.

## Remediation

The privileged key holder adds a new key with setAddrPrivilege via executeBySender, or keeps using executeBySender directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
