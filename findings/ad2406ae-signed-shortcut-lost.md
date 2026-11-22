---
id: ad2406ae-signed-shortcut-lost
title: "0xad2406ae: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xad2406ae4eadca4176c8d72a5bc6c70351b741a2"
  family: "ca4939cf9b90ecbd76ec15b49a77ae81"
  copies: 123
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 48543
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

One of 123 pool wallets that delegatecall a b26359b4-type library; an admin-run call and flagged deposits need an ECDSA signature from a stored operator key.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a version of the b26359b4 wallets (123 addresses, 26.9 ETH); same verdict by structure. Bytecode and names.
- Wrapper delegatecalls every entry to library 0x18d13dc217928e416044aca1ee3d2d89c969349b; the library (family b26359b4 reading) checks an operator signer stored per pool for the admin-run call 0x148b9557 and signed deposits 0x14c937bb
- Withdrawals (withdraw(uint256) 0x2e1a7d4d, withdrawAll() 0x853828b6) route to library bodies that use msg.sender only, no signature (reading)
- The only caller allowed to replace the signer is the factory 0x8ad364b5754b0b691a8cee22f4df91ee16ee1c28. Its code (public RPC, latest block) has one entry 0xe891c0cd: CREATEs a new pool, then calls 0x5295dfe6 on that new pool with its stored signer (decompile shows the full body), so it has no route to a pool that already exists

## Impact and exposure

- Value held at block 26,438,999: $48,543 (ETH and 49 priced tokens, over 123 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the signed admin call and signed deposits; users withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
