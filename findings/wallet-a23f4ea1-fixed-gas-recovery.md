---
id: wallet-a23f4ea1-fixed-gas-recovery
title: "Wallet: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xa23f4ea14fdee13922c73a81152633f56af33eeb"
  family: "1afadacbc1b4cb21726b5efeb83e65a2"
  copies: 4
  name: "Wallet"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move to a new wallet)"
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
  note: "The 3,072-gas multi-owner wallet code: every transfer needs two recoveries and owner changes need the wallet itself, so owners' funds would lock with no way out. Value never lowers the rating (holds $0 today): HIGH."
---

## Summary

A 2-signature wallet (family 'Wallet', 4 addresses): 0x9d55b53f checks two ECDSA signatures before payable(arg1).transfer(arg2). With 3,072 gas both recoveries fail, so no transfer can ever be authorized again.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3072 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x1d4-0x1d9: PUSH1 0x01 PUSH2 0x0c00 STATICCALL (3,072 gas)
- decompile 0x9d55b53f: two ecrecovers checked against owner flags before the ETH transfer; owner changes (0x7065cb48/0x173825d9) need msg.sender == address(this), i.e. themselves signed
- balance 0 at 26438999; family value $0; nonce 1

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners stop using it; anything sent to it later would be locked.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
