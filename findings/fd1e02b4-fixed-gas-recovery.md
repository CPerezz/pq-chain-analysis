---
id: fd1e02b4-fixed-gas-recovery
title: "0xfd1e02b4: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xfd1e02b42694e845fbf28741e5ce9881507d9551"
  family: "4e0bed60b029b2cb243e9ccaed797d6d"
  copies: 17653
  upgradeable: "no"
  rating: HIGH
  value_usd: 4710
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 36
  last_active: 2026-11-17
  recoveries_14d: 14
fix:
  layer: none
  who_acts: "nobody can: owners' funds stay locked"
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
  rating: HIGH
  note: "HIGH: owners' own funds, every exit is signature-gated, no update path, no sweep function exists."
---

## Summary

A 1,041-byte 2-signature multisig wallet (17,653 copies). Every ETH or ERC20 transfer needs two ecrecovers through a STATICCALL with 3,072 gas, so after activation nothing can leave.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,072 gas. Executed. Executed by hand: see Evidence. Rated by hand: each wallet holds one owner group's own funds.
- 3,072-gas wallets (factory `0xcd097b8dd0505aed5ed3f6a02416b0fb9e19fc59`): bytecode pc 187–207 `PUSH2 0x0c00`, `STATICCALL` to `0x01`, `INVALID` on failure. Executed: transaction `0x0323ebe3274b24b64ec6193d93729c9a37fecb1371d921cfd6d7dc98628dbd0f` (block 26,432,607) succeeds today with 64,082 gas, as its receipt says; under EIP-8151 it hits `INVALID` and uses the whole 200,000.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610c00 fa, a STATICCALL to 0x01 with a constant 3,072 gas
- only exits are 0x9d55b53f (ETH) and 0xf063042d (ERC20), each gated by two ecrecover owner checks; addOwner/removeOwner/0x7fb372b0 require msg.sender == address(this) (decompiled)
- no proxy, no delegatecall, no other value-moving function; balance 1.29 ETH, value $4,710; 36 txs in 90 days, last active 2026-11-17

## Impact and exposure

- Value held at block 26,438,999: $4,710 (ETH and 49 priced tokens, over 17,653 addresses).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-17.
- 14 signature recoveries in the study's two-week trace window.

## Remediation

Owners must move funds out before activation; afterwards they are locked.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
