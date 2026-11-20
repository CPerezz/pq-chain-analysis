---
id: depositor-2017ec9a-fixed-signer
title: "Depositor: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2017ec9ac39c949f3d372ff5202fbac4d99c6e4f"
  family: "fe86201c1d3695ff3eebdaaceb9d4def"
  name: "Depositor"
  upgradeable: "no"
  rating: LOW
  txs_90d: 8
  last_active: 2026-11-18
  recoveries_14d: 5
fix:
  layer: offchain
  who_acts: "depositors call the beacon deposit contract directly"
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
  rating: LOW
  note: "batchDeposit dies for good once the authority key has code, but it only forwards 32 ETH per validator to the beacon deposit contract, which depositors can call directly: the same act stays open, so LOW."
---

## Summary

Depositor.batchDeposit forwards 32 ETH per validator to the beacon deposit contract only if each deposit data root is signed by `immutable authority` 0xe8D7AbeD… (an EOA). If that key takes code, batchDeposit dies. The contract keeps no ETH (it forwards within the same call and reverts otherwise), so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Depositor batchDeposit: each deposit must be signed by `authority`, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Depositor.sol: authority immutable; no owner or setter; the only state-changing function is batchDeposit.
- authority()=0xe8D7AbeD…, no code; balance 0 (cast).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new Depositor with a new authority.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: re-rated LOW (was MEDIUM the same day), to match the second Depositor deployment (0xea82d32a): the deposit itself stays open by a direct call to the beacon deposit contract (D-025).
