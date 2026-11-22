---
id: 67cac8b7-fixed-signer
title: "0x67cac8b7: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x67cac8b75357e944d893d426d349f64013ddba76"
  family: "6ffdfcead3bc1a0c8da82f1c4a8fe8de"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 938
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1485
  last_active: 2026-11-17
  recoveries_14d: 230
fix:
  layer: account-migration
  who_acts: "the three owners"
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
  note: "No update path. The owners' own funds leave only through ECDSA signatures by fixed keys → HIGH."
---

## Summary

Weighted multisig: execute (0x84d2176c) must be called by an owner and needs ECDSA signatures from owners with weight ≥ threshold 3 (weights 2/1/1). There is no owner or threshold setter, so if the weight-2 owner, or both weight-1 owners, take code, funds lock.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: owners with a threshold; no function name that changes owners. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: require(isOwner[msg.sender]); signatures recovered and checked against isOwner/weights; 'cannot execute tx: weight not enough'
- getOwners = 0x924c…2b2d (w2), 0xce37…07a2 (w1), 0xd3c0…a78b (w1); threshold 3, totalWeight 4 at 26438999
- all three owners have code 0x today; no owner-changing selector in the ABI

## Impact and exposure

- Value held at block 26,438,999: $938 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,485 transactions called it in the 90 days before that block; last on 2026-11-17.
- 230 signature recoveries in the study's two-week trace window.

## Remediation

Owners move funds out before any owner key whose loss breaks the threshold takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
