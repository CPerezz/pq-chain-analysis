---
id: 23cb75ad-fixed-signer
title: "0x23cb75ad: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x23cb75adc58f2e9a7b3ebf4fb734e8e8d30b6846"
  family: "86a48c9496e5d0b3e0db9f5e72738a2b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner withdraws the stock and redeploys with a new signer, or distributes the tokens by hand"
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
  note: "The rating is MEDIUM rather than HIGH because the deposited stock belongs to the operator and the owner can get it back with withdraw(). Beneficiaries depend on the operator to redistribute it."
---

## Summary

The claim signer is an immutable address, 0x3cad...82c8, which has no code today. If that account gets real code, claims stop working. The owner can still withdraw the deposited tokens with withdraw(), so nothing is locked; only the claim function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable __signer;` is assigned only in the constructor
- claim() reverts with InvalidSignature if ECDSA.recover(...) != __signer
- There is no setter for __signer and no ERC-1271 or code check
- withdraw(uint256) is onlyOwner and calls token.safeTransfer(msg.sender, amount)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be updated or with ERC-1271 support. The owner withdraws the remaining tokens and moves them to the new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
