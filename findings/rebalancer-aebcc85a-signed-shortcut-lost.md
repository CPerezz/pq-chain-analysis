---
id: rebalancer-aebcc85a-signed-shortcut-lost
title: "Rebalancer: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xaebcc85a5594e687f6b302405e6e92d616826e03"
  family: "0f773784e36186d4032698b7596b81df"
  name: "Rebalancer"
  label: "SmarDex: USDN Dip Accumulator"
  upgradeable: "no"
  rating: LOW
  value_usd: 17143
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25
  last_active: 2026-11-15
fix:
  layer: offchain
  who_acts: "the depositor"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $17143, txs_90d 25."
---

## Summary

SmarDex USDN Rebalancer: initiateClosePosition can be delegated by a deposit-owner signature; under EIP-8151 an owner with code cannot delegate.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: USDN rebalancer close delegation: the deposit owner signs for another caller; optional. Read from source.
- _verifyInitiateCloseDelegation: ECDSA.recover(digest, signature) must equal depositOwner (Rebalancer.sol:694-714)
- With empty delegationData the caller closes its own position (initiateClosePosition, Rebalancer.sol:492-511)
- Delegation is optional

## Impact and exposure

- Value held at block 26,438,999: $17,143 (ETH and 49 priced tokens).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

The deposit owner calls initiateClosePosition itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
