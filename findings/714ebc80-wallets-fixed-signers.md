---
id: 714ebc80-wallets-fixed-signers
title: "0x714ebc80: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x714ebc80a6f26955b79ca5f8f42b83bb7756c0e6"
  family: "ca201eb0bc8cc5709333dcb7fbf7d92e"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "current executors"
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
  note: "The key is settable through the contract's own signed path, so the fixed-signer claim is wrong."
---

## Summary

Not Ownbit: an executor multisig call(bytes[] sigs,uint256 nonce,address to,uint256 value,bytes data) with setExec(address,bool) and setExecN(uint256) guarded by msg.sender == address(this). The signer set can be replaced by a signed self-call.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompile and bytecode: setExec (0xc8f72281) and setExecN (0x3681d395) require 'not self' (caller == this); call() runs a full CALL with GAS and the supplied data (@0x567), so a signed call to itself can run them
- Signatures: 65-byte ECDSA with a malleability check, 'invalid signature' / 'not enough unique signatures' against execN
- Storage (latest, block ~26452900): execN slot 3 = 2, highestNonce slot 2 = 8, balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Current executors sign a self-call to setExec new keys (or remove keys that will gain code) before the old keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
