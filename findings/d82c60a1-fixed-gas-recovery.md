---
id: d82c60a1-fixed-gas-recovery
title: "0xd82c60a1: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xd82c60a1a74f7568cc24059f3c90bf0591cacb65"
  family: "c701c51c80c7ed01c3e5783cbc4cdd78"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody at this address; the creator of voucher contracts deployed by it"
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
  verdict: refuted
  rating: NONE
  note: "the fixed-gas call is in creation code for children, so this address never calls 0x01"
---

## Summary

FsTK voucher factory: admin-gated transferEther/transferToken/setFsTKAuthority plus 0x20b7e245, which CREATEs a child voucher contract. The 3000-gas call to 0x01 sits in the child's embedded creation code, not in this address's own runtime.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: STATICCALL(gas=PUSH2 0x0bb8, addr=PUSH1 0x01) at offset 0x2742
- 0x20b7e245 copies this.code[0x1317:0x1317+0x1a2c] (offsets 0x1317-0x2d43) and passes it to CREATE; 0x2742 lies inside that blob
- the decompiled runtime functions (setFsTKAuthority, transferEther, transferToken, 0x9df042cc, 0x20b7e245) contain no ecrecover
- balance 0 at block 26438999; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address; rate the voucher children it deployed separately if they matter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
