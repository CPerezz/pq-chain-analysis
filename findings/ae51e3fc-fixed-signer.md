---
id: ae51e3fc-fixed-signer
title: "0xae51e3fc: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xae51e3fca50d28b0a78d0ca479e45c7be052c657"
  family: "dba4f390c13c58a9a7a93a8f38187406"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new hook with a new signer and points the relay gate at it."
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
  note: "The study note describes a presale with deposit and claim, but the verified source is CyberIDPermissionedRelayHook. The facts also list exit names that do not match the source. I based this analysis on the verified source."
---

## Summary

The signer is an immutable EOA (0x2a2e…1b82) with no setter and no ERC-1271 or code check. If that key's account gets real code, signed CyberID registrations through this hook stop working. Payment happens atomically in the same call, so no funds are left locked, and the owner can sweep anything with rescueToken. Only the function stops, so the rating is MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` is set only in the constructor, and no function writes it.
- _requiresExpectedSigner checks `ecrecover(digest, v, r, s) == expectedSigner`, with no isValidSignature or code check.
- Bytecode facts: 0x2a2ea826102c067ece82bc6e2b7cf38d7ebb1b82 is an EOA (no code), and the signer() getter returns the same address.
- _chargeAndRefundOverPayment sends the cost to the recipient and the overpayment back to the buyer within the same call, so nothing stays in the contract.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new hook whose signer can be rotated or that accepts ERC-1271, then switch the relay gate's hook configuration to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
