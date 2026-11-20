---
id: 0a9ffa0d-wallets-fixed-signers
title: "0x0a9ffa0d: wallet with signers fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0a9ffa0d25035e0dd5b210cad62aa9c63ff81671"
  family: "6e625a93323a22d4fc7701f160d8afb3"
  copies: 159
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "the wallet owner"
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
  rating: LOW
  note: "The same act (moving funds) stays open by a direct owner call: LOW. Only the signed shortcut (ERC-1271 for dapps) would be lost."
---

## Summary

A 45-byte clone of the "Account" wallet 0x6957ed39… (fixed impl). execute/executeBatch accept msg.sender == owner or the wallet itself; ecrecover only backs isValidSignature, so the owner keeps moving funds by direct calls.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 159 wallet clones: one stored key; nine selectors, none replaces it. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Impl bytecode: the execute (5c1c6dcd) and executeBatch (1a833ee3) guard is _msgSender()==owner()
- _msgSender()==address(this) ("Account: only owner can call"); owner is in slot 0xdd866b…0388, written only by initialize(address) c4d66de8; isValidSignature = OZ ECDSA.recover == owner, no 1271 forwarding
- Clone storage: initialized (slot0=1), owner 0xf628609d… = EIP-7702 delegated EOA (0xef0100…88cf071b), so it still recovers (latest, block ~26452917)
- value_usd None, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 159 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for funds; if the owner key gets real code, the owner keeps executing directly and only off-chain ERC-1271 signatures for the wallet stop.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
