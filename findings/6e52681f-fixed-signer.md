---
id: 6e52681f-fixed-signer
title: "0x6e52681f: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6e52681fe40fb0778b387e5d75646afcf0e9496c"
  family: "52094261af48b54d174bda991640178a"
  upgradeable: "no"
  rating: HIGH
  value_usd: 2485
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's signers move the funds out while enough keys are EOAs"
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
  rating: HIGH
  note: "BitGo-style wallet: the caller must be a signer and one other signer's ECDSA signature must recover; the three signers are fixed at init with no setter. Other keys cover the act while some remain EOAs, but the set can never be replaced, so the owners' funds lock once the keys migrate. Same rating as the other fixed-signer wallets: HIGH."
---

## Summary

A BitGo-style 2-of-3 multisig with three signers fixed at init: the caller must be a signer, plus one recovered signature from another signer. One key taking code still leaves a working pair.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BitGo pattern (isSigner, signers). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signers(0..2) at 26438999: 0xE6E4…27e1, 0xEe25…b67e, 0xaBCb…4AC4, all without code; isSigner(address) present; no signer setter in the selectors
- heimdall 305d405f/c2107370: 'Sender is not signer' checks on msg.sender and on the recovered address
- balance 0.4552 ETH; 9 historic recoveries, all from 1 signer

## Impact and exposure

- Value held at block 26,438,999: $2,485 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep two of the three keys without real code, or move the funds before migrating two keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
