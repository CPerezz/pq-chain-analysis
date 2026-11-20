---
id: fab3a95d-signer-upgrade-only
title: "0xfab3a95d: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xfab3a95daa1ba74e336e677f9e18a87bd82ab49a"
  family: "02e523e9f746fd1a470ea034c38d3dca"
  upgradeable: "yes"
  admin: "anyone (changeMasterCopy has no access check, per eth_call)"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "an existing user of each account"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted: the signer set is settable (actual issue: rotate-signer-before-migrating), and a system path moves the tokens. Main reviewer: changeMasterCopy appears callable by anyone (eth_call succeeded from 0xdead), which would let anyone take over the proxy; this is not an EIP-8151 issue."
---

## Summary

A custodial 'Account' master copy, not a fixed key: users are added and removed by addUser/removeUser, signed by an existing user, and transferBySystem lets the config's account handler move tokens without any user signature. In addition, changeMasterCopy has no access check.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: changeMasterCopy(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- heimdall decompile: addUser(address,uint256,bytes) / removeUser require the signature of an existing user (SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT); transferByUser checks the recovered address against the user map
- transferBySystem(address,address,uint256) is gated only by config.isAccountHandler(msg.sender)
- proxy 0xb8290fc8 (slot 0 = row, initialized, users(0) = EOA 0xd69D05a3 with nonce 0, config 0x478C1421): an eth_call to changeMasterCopy(0xdead) from 0xdead succeeded, and the trace shows a delegatecall into the row that ends in STOP

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate users through addUser/removeUser while the key is an EOA, or use the account handler's transferBySystem.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
