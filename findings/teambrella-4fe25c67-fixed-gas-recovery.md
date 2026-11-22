---
id: teambrella-4fe25c67-fixed-gas-recovery
title: "TeambrellaWallet: fixed gas for ecrecover below EIP-8151's price"
project: teambrella
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x4fe25c676fe5e0324a5ec7f5446af9c0a633d7a2"
  family: "283a98576d905e97411165cc1068d256"
  copies: 182
  name: "TeambrellaWallet"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 23711
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "cosigners approve a disband by direct call and the owner sends the funds with disbandTo"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "signed operations die for good; disband and rescue only move the funds out, so MEDIUM"
---

## Summary

`TeambrellaWallet` (older) at `0x4fe25c676fe5e0324a5ec7f5446af9c0a633d7a2`, with 181 more wallets running its code. Signed operations fail from activation day (3,000 gas), but approveDisband/disbandTo and rescue move the funds without a signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: safer_ecrecover with 3,000 gas on every signed path.
- approveDisband() by cosigners and disbandTo(to) by the owner, no ECDSA; rescue(to) (onlyOwner) also sends the balance when Teambrella's rescuer contract allows the caller.
- No proxy, no upgrade.

## Impact and exposure

- Value held at block 26,438,999: $23,711 (ETH and 49 priced tokens, over 182 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Cosigners approve and the owner disbands, by direct calls.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
- 2026-11-20: re-rated MEDIUM (was LOW the same day): the signed transfers die for good and the disband only moves the funds out, which the scale rates MEDIUM; LOW is kept for a simple update or the same act staying open.
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-rotate-signer-before-migrating`; its rotation reading does not apply: every signature check of this wallet forwards a constant 3,000 gas, so signatures fail from activation whoever signs; the fixed-gas finding covers it.
