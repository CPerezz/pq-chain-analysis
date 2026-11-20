---
id: c249c0fc-rotate-signer-before-migrating
title: "0xc249c0fc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc249c0fc4f7283d4a58c57d8fb0cf5f126ae4ead"
  family: "e96b6feff619ca0d05e5e6dff1ccd1c7"
  copies: 9347
  upgradeable: "no"
  rating: LOW
  value_usd: 776322
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "controller itself or owner EOA"
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
  note: "Two live direct-call rotation paths."
---

## Summary

Relay wallet (9,347 copies) executing calls signed by the stored controller; a controller with code can no longer sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: 9,347 relay contracts: the signer named must be the stored controller, which setController replaces. Bytecode and names.
- owner sets controller via 0xa93b5b7b; controller replaces itself via 0x92eefe9b (direct calls, reading.keys)
- owner()=0x5d497982…8560 is an EOA, nonce 54 at block

## Impact and exposure

- Value held at block 26,438,999: $776,322 (ETH and 49 priced tokens, over 9,347 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Controller or owner sets a new controller EOA before the controller takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
