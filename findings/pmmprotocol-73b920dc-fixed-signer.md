---
id: pmmprotocol-73b920dc-fixed-signer
title: "PMMProtocol: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x73b920dc64ab6156f2d22b85ab9a9b06e597e154"
  family: "0376819b9a99999de15de513cf40bdc1"
  name: "PMMProtocol"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 15411
  last_active: 2026-11-17
  recoveries_14d: 3190
fix:
  layer: new-deployment
  who_acts: "operator"
evidence:
  level: executed
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
  note: "No update path. No funds are locked, so only the function dies."
---

## Summary

Every PMMProtocol fill needs a caller authorisation from the immutable AUTH_SIGNER 0x9a2d…e6. If that key gets code, all fills revert for good. Makers keep their funds in their own wallets and can cancel directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PMMProtocol RFQ fill: the maker named in the order is checked by ERC-1271 (flagged) or by ECDSA with ERC-1271 as fallback; the caller authorisation is CallerAuth / CallerAuth: the signer must be…. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CallerAuth.sol:10 immutable AUTH_SIGNER; cast call = 0x9a2D…e6, cast code = 0x
- maker signatures fall back to ERC-1271; cancelOrderRFQ is a direct call (reading.first.json)
- no proxy and no ETH held

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 15,411 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3,190 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new settlement contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
