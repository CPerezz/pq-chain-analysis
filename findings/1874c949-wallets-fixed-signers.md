---
id: 1874c949-wallets-fixed-signers
title: "0x1874c949: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1874c949e78174dd11e9881da35af86590cd7b32"
  family: "aeecb6b6e0d60668511a290a930edf06"
  copies: 50
  upgradeable: "no"
  rating: HIGH
  value_usd: 8370
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $8370, txs_90d 0; value does not lower the rating."
---

## Summary

A BitGo-style wallet variant (no source). Sends need msg.sender to be a signer plus one ecrecovered co-signer from the signers array, which is written only at construction.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 50 wallets in the BitGo pattern (isSigner, signers). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors (bytecode): signers(uint256), isSigner, activateSafeMode, createForwarder-like 0x20f5d560, two signed-send functions 0x812dfcaa/0xa071bdf4 ('signer permission only', 65-byte signature, s-malleability check, 'It's time over to be sent'); heimdall decompile in scratch 051-wallets-fixed-signers/0x1874…
- SSTORE scan of the runtime: slot 1 (safeMode), slot 2 (sequence counter), plus the embedded forwarder initcode/changeParent; nothing writes slot 0 (signers). No proxy slots, no DELEGATECALL
- signers() at 26438999: 0xe38e473a… EOA n0, 0xF13f011E… EOA n0, 0x10F30463… EOA n48 (cast code/nonce)
- The 0x14da59db… constant is an MSTORE operand in a revert path, not a privileged address

## Impact and exposure

- Value held at block 26,438,999: $8,370 (ETH and 49 priced tokens, over 50 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
