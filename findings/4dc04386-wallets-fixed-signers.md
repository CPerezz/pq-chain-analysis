---
id: 4dc04386-wallets-fixed-signers
title: "0x4dc04386: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4dc04386fc6461ff16894d8e694ad50ccef4a7e6"
  family: "f394df7ee84e8b4a972487e9bf4502c1"
  upgradeable: "no"
  rating: HIGH
  value_usd: 36
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (2 of 3 EOAs)"
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
  verdict: confirmed
  rating: HIGH
  note: "Fixed owners, no other exit: HIGH."
---

## Summary

A SimpleMultiSig v1 (execute 0xf12d394f, no executor gate). It needs exactly 2 ecrecover'd signatures from 3 fixed owners, with no setter, so the 0.02 ETH is locked once owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: only non-view function 0xf12d394f; 'number-of-v/r/s' == threshold, ecrecover owner check; the SELFDESTRUCT byte found by the disassembler is in the metadata tail, not reachable code; no setter, no proxy slots
- at block 26438999: threshold=2, nonce=0, owners [0xe70df3d93410c662014bda80706f48fe714b76b4, 0x0ae5c01e5ef595906416038089471066667fde2b, 0x4e94ea3e321a1191bcb3da144bfed9469a1fb852], balance 0.02 ETH
- cast code latest: all owners EOA (nonces 584/0/0)
- batch row: value_usd 36, txs_90d 0, last_active null, copies null

## Impact and exposure

- Value held at block 26,438,999: $36 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Final 2-of-3 execute moving the funds to a migratable wallet before key migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
