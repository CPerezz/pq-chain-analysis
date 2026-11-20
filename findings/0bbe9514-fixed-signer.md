---
id: 0bbe9514-fixed-signer
title: "0x0bbe9514: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0bbe9514679f6ee01b3fc620e7390a1f69ae9e78"
  family: "d3b0b6bbde1c5ff703e93c25c6e406b5"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "future depositors blocked; owner retains full control of whatever is already deposited"
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
  note: "deposit()'s SIGNER has no setter so new deposits permanently stop, but claim() is owner-only and unaffected by EIP-8151, so existing funds are never locked — matches the MEDIUM 'function dies for good but an owner/rescue path still moves the money' case, not the HIGH 'buyers can only claim with the signature' scenario this row's template suggested."
---

## Summary

Presale-style contract. deposit(address,uint256,uint256,uint256,bytes) requires a signature matching a hardcoded SIGNER (0x3f053c55...) with no setter — new deposits die for good once that key has code. claim(address,address,uint256), despite its selector-matched name, is NOT signature- or buyer-gated: its real body (hidden by heimdall, which stubbed it to a no-op) is onlyOwner, sweeping ETH (or an ERC20 by arg0) to an arbitrary recipient. So the owner can always move out whatever sits in the contract; nothing becomes locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode at 0x435 (deposit body, entered at dispatch 0x162->0x330): error string 'Presale::deposit: invalid signature', recovered address masked and EQ'd against PUSH20 0x3f053c55a999bf7e62291f104fc87410c88e256e, matching the row's own constants field (0 bytes, not delegated).
- Bytecode at 0x60d (claim's real body, entered at dispatch 0x142->0x1a9): CALLER == SLOAD(slot 0) i.e. plain onlyOwner, not a signature check at all; branches into a CALLER/SELFBALANCE ETH send when arg0==0.
- cast code on 0x3f053c55... at the pinned block is empty (no code today).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy with a replaceable deposit-signer; in the meantime the owner already has an unsigned sweep path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
