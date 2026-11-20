---
id: 3bc0714b-fixed-signer
title: "0x3bc0714b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3bc0714b334d21ad089127e700051f5b98a176a5"
  family: "2f5e5cff5565b7a3b702c292bf4f6a0a"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner deploys a new bridge with a new signer and moves the held funds out with withdrawEmergency."
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
  note: "Opcode sequence 99.6% identical to verified BXHBridge copy 0xea044166 (same reading applied); cSigner candidate 0x6132485f… is an EOA at 26438999. The row note says presale, but the source is a bridge. The code does not show which of the two EOA addresses is cSigner, so both are listed; both have no code today, so the verdict holds either way."
---

## Summary

The only signature check is the immutable cSigner in lock(), and no function can replace it. If the signer's account gets code, only new deposits stop. Funds already held can still be moved by the owner and governors through pay and withdrawEmergency without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner;` is set only in the constructor
- lock(): `require(ecrecover(digest, v, r, s) == cSigner, "BXHBridge: Invalid signer")`. No code-size check and no ERC-1271 path.
- withdrawEmergency and withdrawEmergencyNative are onlyOwner and need no signature
- pay() is onlyGovernor and needs no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new bridge with a signer that can be rotated, or accept ERC-1271 signatures. Move the held funds out through withdrawEmergency.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
