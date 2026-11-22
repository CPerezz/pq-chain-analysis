---
id: saclienterc20-b40078c3-own-signature-only-exit
title: "SAClientERC20: funds released only by the party's own signature"
status: confirmed
severity: LOW
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xb40078c3871dcf6757e92f5369019fa20bf2bc15"
  family: "777e08a9ce4ae5874141449c0abf0ade"
  name: "SAClientERC20"
  upgradeable: "yes"
  admin: "0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de (ProxyAdmin (Ownable)), owned by 0x3b84f56ccae06d51f0634e2f1550336caa47f251 (EOA, nonce 165)"
  rating: LOW
  value_usd: 258
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0x3b84f56ccae06d51f0634e2f1550336caa47f251"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a live party controls the proxy admin."
---

## Summary

SAClientERC20: tokens credited to a key address (saDest) move only by a relayed request signed by that key; no direct call; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: SAClientERC20: tokens credited to a key address (saDest) move only by a relayed request signed by that key; no direct call. Read.
- Update path, read at block 26,438,999: proxy to 0x3ea5eaaa2727a38f2a16151e8b85017f966e4656, admin 0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de.
- EIP-1967 admin slot = 0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de, implementation = 0x3ea5eaaa2727a38f2a16151e8b85017f966e4656 at block 26438999
- 0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de: ProxyAdmin (Ownable); owner() = 0x3b84f56ccae06d51f0634e2f1550336caa47f251
- 0x3b84f56ccae06d51f0634e2f1550336caa47f251: EOA, nonce 165 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $258 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
