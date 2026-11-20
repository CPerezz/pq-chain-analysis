---
id: 8b2b4fa5-fixed-signer
title: "0x8b2b4fa5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8b2b4fa53bf1e6b041ead123a994b08df5a5246a"
  family: "dca44f719bf1500b177d588e20587565"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-11-16
  recoveries_14d: 10
fix:
  layer: new-deployment
  who_acts: "owner"
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
  note: "No update path for the signed function. Only the operator's own money is involved, and it still exits by owner call."
---

## Summary

An MEV-bot style contract. Selector 0xebe43c8e (gated to block.coinbase 0xfb74…571b) recovers a signature and requires it to equal 0x47da…7147, a constant in the code that is also the owner in slot 0. The owner withdraws ETH and tokens by direct call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: `require(!(address(var_b) - 0x47da8dba…7147))` after ecrecover in 0xebe43c8e; the address appears in the bytecode as a constant
- withdrawETH and withdrawToken require msg.sender == store_a (slot0 = 0x47da…7147); setOperator writes slot 1, not the checked constant
- cast code 0x47da… = 0x; contract holds 0.000523 ETH

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-16.
- 10 signature recoveries in the study's two-week trace window.

## Remediation

The owner withdraws directly and deploys a new bot.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
