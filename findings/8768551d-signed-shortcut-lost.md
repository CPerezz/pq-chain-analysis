---
id: 8768551d-signed-shortcut-lost
title: "0x8768551d: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x8768551d4dfc099577c6871e424b0d771c7b2328"
  family: "769a51e1981afcac22ed8c8954ea0f07"
  copies: 63
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 51430
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody (signer fixed after deployment)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Operator-key issue (rotate-signer shape), not a signed shortcut. The signer is set once, at creation; the factory has no later route to change it. Withdrawals are direct, so nothing is locked → MEDIUM. Factory code came from publicnode because the reth archive node timed out."
---

## Summary

One of 63 pool wallets that delegatecall a b26359b4-type library; an admin-run call and flagged deposits need an ECDSA signature from a stored operator key.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a version of the b26359b4 wallets (63 addresses, 28.5 ETH); same verdict by structure. Bytecode and names.
- Wrapper delegatecalls every entry to library 0x201c56d3c78ea3c4ffb9143870e4896ece6eeaa2; the library (family b26359b4 reading) checks an operator signer stored per pool for the admin-run call 0x148b9557 and signed deposits 0x14c937bb
- Withdrawals (withdraw(uint256) 0x2e1a7d4d, withdrawAll() 0x853828b6) route to library bodies that use msg.sender only, no signature (reading)
- The only caller allowed to replace the signer is the factory 0xd15a48f4105f68eeb116f07f8415039940a3399a. Its code (public RPC, latest block) has two entries 0x6b075547 and 0xdcc6825e, both CREATE a pool; 0x56e28135 and 0xe7f4cc8c appear once each (decompile stops after the create), so it has no route to a pool that already exists

## Impact and exposure

- Value held at block 26,438,999: $51,430 (ETH and 49 priced tokens, over 63 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the signed admin call and signed deposits; users withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
