---
id: d4001a2b-signed-shortcut-lost
title: "0xd4001a2b: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd4001a2bee20bcad4775d47499a3fc3516e93a08"
  family: "b97a87082eb1f85c6e54f7983136cb75"
  copies: 87
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 17504
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

One of 87 pool wallets (783e1802 build) that delegatecall library 0xb380e099…; same wrapper shape as the b26359b4 pools, with an operator-signed admin call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: another build of the 783e1802 wallets (87 addresses, 9.7 ETH); same verdict by name and structure. Bytecode and names.
- Wrapper delegatecalls entries to library 0xb380e09911e8694d193514cabfeae4074e41b308, including 0x148b9557 (admin call) and 0x14c937bb (signed deposit) (heimdall)
- Wrapper selector 0x5295dfe6 routes to 0x61d67ca5 (signer setter in the b26359b4 reading) gated by store_b == msg.sender
- The only caller allowed to replace the signer is the factory 0x23c4af28b3f1e519cc6b8e981f88a74d5959ca56. Its code (public RPC, latest block) has one entry 0x1bb1850e, which CREATEs a pool; 0x5295dfe6 appears once in its code (decompile stops after the create), so it has no route to a pool that already exists

## Impact and exposure

- Value held at block 26,438,999: $17,504 (ETH and 49 priced tokens, over 87 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the signed admin call and signed deposits; users withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
