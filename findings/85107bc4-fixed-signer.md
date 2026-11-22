---
id: 85107bc4-fixed-signer
title: "0x85107bc4: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x85107bc4d1895939a0d72b9fd557f5f88927003c"
  family: "7b5f4add9379cca655b92fa7aa1d6334"
  upgradeable: "no"
  rating: HIGH
  value_usd: 9
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "no one — bidders cannot recover escrowed ERC20/ETH"
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
  note: "Signer is a bytecode literal (no setter) and every value-moving function requires its signature; no other exit exists."
---

## Summary

ERC20-denominated bid escrow (feep/setFee/upBid/makeBid plus two unresolved selectors 0xb58d6997/0xf373bffc that are the cancel/claim analogs). All six money-moving selectors call the same internal verifySig subroutine, which ecrecovers and compares against a hardcoded PUSH20 SIGNER (0x3ab9e9c7...) with no setter. No owner rescue selector exists.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode at 0xf0b/0xec6: STATICCALL to address 1, return EQ'd against PUSH20 0x3ab9e9c755476e6b560330e732fd3457a295a04f.
- Static call-graph: the shared verifySig subroutine is jumped into from 6 distinct dispatch bodies (3074d407, 36c9e78d, upBid, makeBid, b58d6997, f373bffc) — i.e. every state-changing selector.
- Selector list has no withdraw/rescue entry; cast code on 0x3ab9e9c7... at the pinned block is empty (no code today).

## Impact and exposure

- Value held at block 26,438,999: $9 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy with a replaceable signer, or add an unsigned owner rescue path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
