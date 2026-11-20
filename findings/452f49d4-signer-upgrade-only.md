---
id: 452f49d4-signer-upgrade-only
title: "0x452f49d4: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x452f49d4331badb2d200f713a86c1d9683d1ef24"
  family: "02e523e9f746fd1a470ea034c38d3dca"
  copies: 160
  upgradeable: "yes"
  admin: "any existing user key (key holder itself)"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "any existing user key (key holder itself)"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "the claim 'no function replaces it' is wrong: the key set can be changed by addUser/removeUser, signed by the current key before it migrates. LOW holds (setter path, as for rotate-signer)"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xfab3a95daa1ba74e336e677f9e18a87bd82ab49a with changeMasterCopy(address), called through its own checks.
- masterCopy 0xfab3a95d… (heimdall + _selectors.json): addUser(address,uint256,bytes) and removeUser(address,uint256,bytes) add or remove keys on a signature from an existing user ('SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT')
- changeMasterCopy(address) exists as well; its auth wasn't resolved in the decompile, and the users at the block weren't read (RPC timed out)
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 160 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

a current user adds a new key with addUser (signed while the old key is still an EOA or 7702-delegated) and removes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
