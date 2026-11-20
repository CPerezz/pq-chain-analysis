---
id: 6e31c365-fixed-signer
title: "0x6e31c365: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6e31c365de962bfc7a5848511cd5212b67b05a96"
  family: "04fd5bc507f864d2e2adea1aa8b79f08"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "Owner (0x19e56fc7fe6d312f444a6a744094278d5dba84ce) uses withdrawEmergency/withdrawEmergencyNative to pay users back by hand"
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
  note: "The cSigner value is not in the row facts (it is immutable), so its current code was not checked. A key that can produce ECDSA signatures must be an EOA or an EIP-7702 delegated account; confirm by reading cSigner() and checking its code."
---

## Summary

The signer cSigner is immutable with no setter, and claim uses raw ecrecover with no code check or ERC-1271. If the signer account gets code, claims and refunds stop. The owner's emergency withdraw functions can still move all funds out, so the operator can return the money by hand.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner;` assigned only in constructor
- claim: require(ecrecover(digest, v, r, s) == cSigner, "LaunchPadPool: Invalid signer")
- No function writes cSigner; the only setter in the row facts is transferOwnership
- withdrawEmergency / withdrawEmergencyNative are onlyOwner and can move the full balance

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Off-chain: the owner refunds depositors and pays out allocations through withdrawEmergency/withdrawEmergencyNative. Keep the signer key free of non-delegation code. Future deployments should let the signer be rotated or accept ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
