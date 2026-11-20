---
id: 94e816f5-fixed-signer
title: "0x94e816f5: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x94e816f5acd7a3754fa5515bcc5aacc6a2a71d28"
  family: "52c417b74aebdfb714b9f22851c3e418"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6
  last_active: 2026-11-02
fix:
  layer: onchain-config
  who_acts: "contract owner 0x330da6bcbda450818484ed6314a5927e4d1896b4"
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
  note: "LOW: minting stays open via public sale/devMint; nothing locked."
---

## Summary

Circles generative NFT: pre-sale mint 0x207da3a3 accepts only signatures from constant 0xaab57ded…6156; if that key gets code the pre-sale mint stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled.sol: 0x207da3a3 ecrecover(...)==0xaab57dedc05a3677dac050b402f5ca52ea176156 ("Invalid signature"); setters = transferOwnership only
- signer 0xaab5…6156: cast code = 0x (EOA) at block 26438999
- same act open: public mint 0x31c864e8 (owner unpauses sale) and onlyOwner devMint 0x375a069a; withdrawAll() by owner
- balance 0 at block 26438999; txs_90d=6, last_active=2026-11-02

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

Owner opens the public sale or devMints to pre-sale buyers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
