---
id: 0c1f8536-fixed-signer
title: "0x0c1f8536: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0c1f853649bb66c14864d73f1e3b616ff0ef43d1"
  family: "8c0cc9d0176099ff4af67251028bafdb"
  upgradeable: "no"
  rating: LOW
  txs_90d: 11547
  last_active: 2026-11-18
  recoveries_14d: 1143
fix:
  layer: onchain-config
  who_acts: "maker wallet admin"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A setter on the dependant replaces the validator."
---

## Summary

The stateless validator answers for the constant 0x6904…6e24. However, the maker wallet that calls it, 0x724c…ffd4, stores the validator in slot 14, and its admin can replace it with setZeroExValidation.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: an ERC-1271 contract with two selectors that answers for a signer fixed in its code. Bytecode and names. Executed: a real transaction is unaffected by code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode PUSH20 0x690441f9…6e24 (reading.first.json); cast code of the signer = 0x
- trace 0x399b…47ac: 1inch -> maker 0x724c.isValidSignature -> 0x0c1f; maker slot14 = 0x0c1f…
- heimdall of the maker: setZeroExValidation writes slot 14 and requires msg.sender == admin (0xEAD3…e70f); the maker's funds leave through withdrawToken/withdrawEth

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 11,547 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,143 signature recoveries in the study's two-week trace window.

## Remediation

The maker admin points setZeroExValidation at a validator with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
