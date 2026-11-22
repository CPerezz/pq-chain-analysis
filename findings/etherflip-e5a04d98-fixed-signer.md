---
id: etherflip-e5a04d98-fixed-signer
title: "EtherFlip: signer fixed in code"
project: etherflip
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe5a04d98538231b0fab9aba60cd73ce4ff3039df"
  family: "0fa7b998d3ca2517f15886d2653dd1ef"
  name: "EtherFlip"
  label: "EtherFlip"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1359029
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner refunds open bets and moves the bankroll"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "as the fixed-gas row of the same contract"
---

## Summary

`EtherFlip` at `0xe5a04d98538231b0fab9aba60cd73ce4ff3039df`. Its Oraclize proof check accepts only the proof chain's fixed key; a stopped check stops the game, while the owner can still move the money without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to…. Read from source. Rated by hand: read: the owner moves the bankroll with refundTransfer, no signature needed; read: the owner moves the bankroll without a signature.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: verifySig recovers the address of the public key carried in the proof, chained to a fixed key.
- refundTransfer moves the bankroll on the owner's call alone.
- No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner refunds and withdraws.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
