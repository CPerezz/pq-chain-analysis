---
id: 43ef8e0a-wallets-fixed-signers
title: "0x43ef8e0a: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x43ef8e0a13b45b948405239ceb1e08a80b57f205"
  family: "fa75bb86750f9a202be0cf847f985d75"
  copies: 6
  upgradeable: "no"
  rating: HIGH
  value_usd: 501
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (3 of 7 EOAs)"
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
  note: "Fixed owners and execute is the only exit: HIGH. The runtime has 5 SSTORE opcodes, but execute is the only entry point that writes state, so owners cannot change."
---

## Summary

An EIP-712 SimpleMultiSig variant with getOwners/isOwner and the errors 'WRONG EXECUTOR' and 'THRESHOLD/SIGNERS MISMATCH'. Its only non-view function is execute 0xa0ab9653, which needs 3 owner signatures, and the 7 owners are fixed. 0.24 ETH is locked once fewer than 3 owner keys can recover.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall ABI: the only non-view/pure function is 0xa0ab9653 execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256); all other selectors are constant hash getters or getOwners/isOwner/threshold/nonce; no setter, no proxy slots
- at block 26438999: threshold=3, nonce=2, getOwners = 7 addresses (0x155c34f9…, 0x1d303579…, 0x2b13be71…, 0x56a6894a…, 0xb77bb158…, 0xcce99ccf…, 0xe13af7bc…), balance 0.2418 ETH
- cast code latest: all 7 owners EOA, nonce 0
- batch row: value_usd 501, txs_90d 0, last_active null, copies 6

## Impact and exposure

- Value held at block 26,438,999: $501 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

3 owners sign a final execute that moves the funds to a migratable wallet before their keys take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
