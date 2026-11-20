---
id: c7013759-wallets-fixed-signers
title: "0xc7013759: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc701375986d192a2c8299716e09703a6a050c972"
  family: "ebcf43877957e77b6b49b3bb707fdeda"
  copies: 5
  upgradeable: "no"
  rating: HIGH
  value_usd: 523
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
  note: "Same check as template 8f5fee6f, fixed owners, no other exit: HIGH."
---

## Summary

A standard SimpleMultiSig v2 (EIP-712 execute with executor and gasLimit). It needs 2 ecrecover'd owner signatures, and the 3 owners are fixed with no setter. The 0.29 ETH is locked once owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- selectors: threshold, execute 0xa0ab9653 (8 args), ownersArr, nonce only; heimdall: execute checks isOwner[ecrecover(...)] map; no setter, no proxy slots
- at block 26438999: threshold=2, nonce=1, owners [0x3b66698c45b8f169e5b549a3298e1b9bc6ddfecf, 0x5055e2e771cad9006aab97a38d973ff36a722e29, 0x707b24953da39006c98c2e2e3be355d9d57e9f9b], balance 0.29 ETH
- cast code latest: all owners EOA (nonces 53/30/159)
- batch row: value_usd 523, txs_90d 0, last_active null, copies 5

## Impact and exposure

- Value held at block 26,438,999: $523 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds out with a final 2-of-3 execute before migrating keys to code, into a wallet that supports ERC-1271 or replaceable signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
