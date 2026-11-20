---
id: creepzinvasionpass-f3ec2d63-fixed-signer
title: "CreepzInvasionPass: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf3ec2d6394fc899a5dc1823a205670ebb30939cc"
  family: "5cab1fff9ec4f52f0c270eae3e4e1a85"
  name: "CreepzInvasionPass"
  label: "Creepz Invasion Pass: IP Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 4466
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 216
  last_active: 2026-11-11
fix:
  layer: onchain-config
  who_acts: "owner 0x92577e28… (EOA)"
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
  rating: LOW
  note: "A setting removes the dependency on the fixed signer."
---

## Summary

Creepz Invasion Pass: purchase checks a signature from signerAddress (set in the constructor, no setter) only while whitelistOnly is true. The owner can turn whitelistOnly off, which removes the signature check.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Creepz pass: signed by signerAddress, set in the constructor. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CreepzInvasionPass.sol: purchase calls _validateSignature only if whitelistOnly && sender != owner; line 172 sets whitelistOnly from an owner function
- signerAddress() at 26438999 = 0x3F2C152B91D1CA6Ab86a94f113e778Aa2eE8DFFc (cast code 0x); whitelistOnly = true; saleIsActive = false
- withdraw() onlyOwner; owner 0x92577e2807e9b1642d8d21c9ec7db1465de839d2 (EOA)

## Impact and exposure

- Value held at block 26,438,999: $4,466 (ETH and 49 priced tokens).
- Activity: 216 transactions called it in the 90 days before that block; last on 2026-11-11.

## Remediation

The owner turns off whitelistOnly (or mints as owner) if the signer address ever takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
