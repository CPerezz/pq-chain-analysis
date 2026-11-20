---
id: 04a8d6ae-fixed-signer
title: "0x04a8d6ae: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x04a8d6aec65a336e9ba637122215f84c799e15e3"
  family: "97ced48cbd36e71c7bbd21ce5e16ccd9"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "bridge operator (ADMIN_ROLE holder)"
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
  note: "No update path; the pooled bridged tokens leave only on CANISTER-signed vouchers, so they are locked."
---

## Summary

EthBridge (ICP canister bridge): bridgeIn pays pooled bridged-out tokens only on a voucher signed by the immutable CANISTER. If that address takes code, no voucher recovers and the pooled tokens have no other way out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Same code idiom as template 496eb5b1, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors match EthBridge source (CANISTER, bridgeIn, bridgeOut, feeWithdraw, withdrawDiscountToken); no EIP-1967 slot
- bridgeIn: ECDSA.recover(messageHash) must equal immutable CANISTER (EthBridge.sol); no setter. CANISTER() at block 26438999 = 0x0CD939706E49D8efe297cAFC365f1D4a6D9622cA, cast code 0x (EOA)
- Exits without the voucher: feeWithdraw (ADMIN_ROLE) only moves bridgeBalance fees; withdrawDiscountToken returns a user's own discount-token stake. Pool tokens leave only through bridgeIn

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new bridge with a PQ-safe or ERC-1271 voucher check; the pooled tokens here cannot be moved.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
