---
id: b6260b8b-rotate-signer-before-migrating
title: "0xb6260b8b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb6260b8b0bcdcbb7a57f86b074a7e03a095106f0"
  family: "25d8a07a3e6339366673b36e14f41b79"
  copies: 6
  upgradeable: "no"
  rating: LOW
  value_usd: 64423
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "pool operations EOA 0x0bf0…b31d"
evidence:
  level: bytecode
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
  note: "Operations-gated setter verified by simulation; active EOA."
---

## Summary

Hashflow pool ('AAA Blue Chips Pool', minimal proxy onto 0x6f112a94…46a0): quotes must be signed by the pool's stored signer through ecrecover; a signer with code stops trades.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a signer with a setter (updateSigner). Bytecode and names.
- heimdall decompile of 0x6f112a94…46a0: updateSigner(address) requires msg.sender == operations ('HashflowPool: Account not authorized…')
- simulated updateSigner at block 26438999: succeeds only from slot-4 address 0x0bf0e31a…b31d (EOA, nonce 219); fails from the other stored addresses
- current signer (slot 3) 0xf18c4daa…fae0 is an EOA with nonce 0; the pool holds 31.43 ETH

## Impact and exposure

- Value held at block 26,438,999: $64,423 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operations calls updateSigner with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
