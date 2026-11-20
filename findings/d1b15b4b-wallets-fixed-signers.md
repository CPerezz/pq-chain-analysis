---
id: d1b15b4b-wallets-fixed-signers
title: "0xd1b15b4b: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd1b15b4bbd587b6b35afa964f88f416b63f1c3e4"
  family: "97f6532edd6cb3b8348bd9b5102800ec"
  copies: 10012
  upgradeable: "no"
  rating: NONE
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-08-20
fix:
  layer: none
  who_acts: "the NFT holder (owner)"
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
  note: "The key is not fixed (it follows the NFT holder) and funds move by a direct owner call; only ERC-1271 signing by an owner with code would stop."
---

## Summary

ERC-6551-style token-bound account: owner() is ownerOf(5286) on the Compas NFT 0xed346cef…. The owner executes directly, and ownership moves with the NFT. ecrecover only backs isValidSignature.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: wallets whose ERC-1271 accepts the owner's ECDSA signature; the owner also executes directly. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: owner(), execute(address,uint256,bytes,uint8) and isValidSignature all staticcall 0xed346cef…ownerOf(0x14a6) with a chainid==1 check; execute requires msg.sender == owner (no signature)
- ownerOf(5286) = 0xee5adad7… (EOA, latest), the same as row owner()
- value_usd 4, txs_90d 1, last_active 2026-08-20 (row)

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens, over 10,012 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-20.

## Remediation

None needed for funds; if the owner key gets code, the owner keeps executing directly (or transfers the NFT) and stops relying on 1271 signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
