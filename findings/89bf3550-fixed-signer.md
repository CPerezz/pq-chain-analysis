---
id: 89bf3550-fixed-signer
title: "0x89bf3550: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x89bf355004f031e23bc31110a3f90ed7a485fe1c"
  family: "be6865c70ab71a11c983756d43e54fdb"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 23
  last_active: 2026-11-01
fix:
  layer: onchain-config
  who_acts: "Owner: switch to the public sale with toggleSale/setPrice in place of the signed presale"
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
  rating: MEDIUM
  note: "Only new mints are affected. Users have no deposits held by the contract."
---

## Summary

The presale mint only accepts signatures from the hardcoded signer 0x8f20…d358, which has no code today. Nothing can replace it. If that account gets code, presale minting stops. No funds get locked: the owner can still withdraw the ETH, and the public mint paths need no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x6464eb64: require(0x8f20d89bee77ea2abbaf46b5def3ef109ab9d358 == address(var_s))
- Signer is a hardcoded constant; no function writes it
- Row facts: the signer has code_bytes 0 and is not delegated
- withdraw() is owner-only and sends address(this).balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 23 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

The owner runs the sale through the public mint (toggleSale) instead of the signed presale. The signer key must not get non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
