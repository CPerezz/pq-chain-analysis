---
id: e33da1d4-fixed-signer
title: "0xe33da1d4: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe33da1d4d71140f61189d28d4ce847dfc9b7f1f1"
  family: "1f752281408ef311b6f046e0a29e6717"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (liveness only)"
evidence:
  level: source-read
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
  note: "No fund-moving function visible beyond plain transfer/transferOwnership; impact is liveness of whatever gated function uses this signer, not a lock."
---

## Summary

A small contract exposing a `signer()` getter alongside `owner()`/`paused()`; whatever function gates on ecrecover(...) == signer stops once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts.getters: signer() = 0x7768b3500fa7f9174aa3579c5a3c35e2f4c3026a (distinct from owner() = 0x0a0af0f7f86fb9f8b5ad0a0a5f0c2723f2959213)
- `cast code` on the signer address today -> 0x (EOA)
- facts.exits for this address = transfer(address,uint256), transferOwnership(address) only -> no funds held/paid out by this contract's own exposed functions

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix; redeploy with a replaceable signer before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
