---
id: b7d07116-wallets-fixed-signers
title: "0xb7d07116: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb7d0711615c2965a7878cfbac8b60c3852658850"
  family: "6f9ff6f56a8d3566862a6216f63580eb"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Every path to the check is closed by state (empty signer set) → refuted."
---

## Summary

Not SimpleMultiSig: unverified 2-function contract (0x1e7ed7f9 returns 2; 0xd6b90419 signed settlement). Recovered signers must be flagged in mapping slot 4, which no code ever writes, so no signature can ever pass.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: recovered address → keccak(addr,4) SLOAD &0xff, else revert 0x148de27f; runtime SSTOREs only touch mapping slot 2 (timestamps) and slot 0x10 (counters)
- Creation tx 0xcfb4…5e88: initcode 4549 bytes vs runtime 4521 bytes (no constructor storage writes), no logs; slots 0–24 all zero at 26438999
- ETH 0; etherscan: 0 transactions
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
