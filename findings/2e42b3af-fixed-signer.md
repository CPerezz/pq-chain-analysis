---
id: 2e42b3af-fixed-signer
title: "0x2e42b3af: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2e42b3af52f6ffaff822e48411a7d7b7dbac38d3"
  family: "23d615a61d9bc2b183e943df2743e024"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 13878
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner withdraws and distributes another way"
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
  note: "claims stop; owner can withdraw"
---

## Summary

Contract `0x2e42b3af52f6ffaff822e48411a7d7b7dbac38d3`. Claims need the fixed defaultSigner's signature; a signer with code ends claims, but the owner can withdraw the 8 ETH directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a claim contract (8 ETH): claims need the fixed defaultSigner's signature; a signer with code ends claims. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: claim1 checks a stored defaultSigner with no setter.
- withdraw(uint256) is an owner call (owner 0xd59ceaa667cea4cd742dd634892283d09eac99be).
- Dormant.

## Impact and exposure

- Value held at block 26,438,999: $13,878 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
