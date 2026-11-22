---
id: 00000000a892-signed-shortcut-lost
title: "0x00000000: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x00000000a892451ab99290edbf4179f0c90f078f"
  family: "3d715bf8d942b40fa0951c2d360a5ad5"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "members"
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
  rating: LOW
  note: "The vault's assets stay movable by direct member calls → LOW. Bytecode only."
---

## Summary

Unverified member-run vault: members act by direct calls; the vault's ERC-1271 isValidSignature accepts a member's ECDSA signature, which a member with code can no longer give.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a member-run vault (8 ETH): members act directly; ERC-1271 signatures by a member with code fail. Bytecode and names.
- Bytecode contains isValidSignature selector 0x1626ba7e (dossier code.hex)
- Decompile: transfer entries (transferTo, transferEthTo, wrap/unwrap) gated by storage_map_e[msg.sender] (members), no signature (heimdall, scratch L027)
- setCommonAdmin is the only setter (facts)

## Impact and exposure

- Value held at block 26,438,999: $14,436 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Members act by direct call; other EOA members can still sign for the vault.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
