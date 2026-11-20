---
id: 3c1c6eb9-fixed-signer
title: "0x3c1c6eb9: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3c1c6eb9176ed338ae8e767305830b7da3fd7ee7"
  family: "c9e7c2e0e02b2f17edeace3a730624e5"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody (owner renounced)"
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
  rating: MEDIUM
  note: "MEDIUM: mint function dies, nothing held (balance 0; any ETH is already stuck by the renounced owner, not by EIP-8151)."
---

## Summary

Whitelist ERC721: mint(amount,id,sig) 0x08dc9f42 always requires a signature from constant 0xa2f2a3d5…76ce ("Whitelist check failed invalid"); if that key gets code, minting dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled.sol: 0x08dc9f42 checks recovered == 0xa2f2a3d534aaf5fddcd9f23af0f4a594cce376ce unconditionally; no setter
- signer 0xa2f2…76ce: cast code = 0x (EOA) at block 26438999
- owner() = 0x0 at block 26438999 (renounced): no owner mint, withdraw() unusable
- balance 0 at block 26438999; txs_90d=0, last_active=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain; redeploy if minting is still wanted.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
