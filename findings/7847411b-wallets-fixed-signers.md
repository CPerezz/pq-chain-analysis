---
id: 7847411b-wallets-fixed-signers
title: "0x7847411b: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7847411b6ca87ff2d8a3f9037d01705da243168b"
  family: "be12233bf535009c350166f2996be8bc"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted: the signer set at this address is empty forever (no constructor, no setter), so every path to the check is closed; likely a logic contract meant for delegatecall/7702 use, whose users' own storage would decide. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Not a SimpleMultiSig: unverified refund/payout contract (errors NothingToRefund, AlreadyRefunded, SignersNotAscending, Refunded/RefundFailed events) whose signature check requires each recovered address to be flagged in mapping slot 4 (isSigner). Nothing ever writes that mapping at this address, so no signature can ever pass here, before or after EIP-8151.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Creation tx input (publicnode tx lookup, immutable data, latest, block ~26452927) is solc boilerplate + runtime only: 28-byte prefix 6080604052348015600e575f5ffd5b5061128a...; no constructor code, so no storage written at deploy
- Disassembly: signer check = keccak(addr,slot 4) SLOAD &0xff, else revert 0x148de27f; signers must be strictly ascending (0x590a84f7). No runtime SSTORE targets slot-4 mapping (SSTOREs only touch refund records / timestamps)
- Storage slots 0-5 all zero at block 26438999 (cast storage); balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for this address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
