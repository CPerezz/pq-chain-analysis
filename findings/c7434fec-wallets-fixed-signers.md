---
id: c7434fec-wallets-fixed-signers
title: "0xc7434fec: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc7434feccf159c215935200a8c68cd870880e3d0"
  family: "fcaacba8a91bfb4a49dfea95b37cfd9e"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "the 2 owners (signed execute calling setOwners)"
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
  note: "The key is settable by the multisig itself → refuted as the fixed-signer claim. The real issue is rotate-signer-before-migrating."
---

## Summary

This is a SimpleMultiSig variant with setOwners(uint256,address[]) (0xf3182e85). It requires msg.sender == address(this) ('Can only be called by multisig'), so the owners can replace the owner set and threshold through a signed execute.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: affe39c1, nonce, setOwners 0xf3182e85, threshold, execute 0xa0ab9653, ownersArr; heimdall: setOwners requires address(this)==msg.sender, rewrites isOwner map/ownersArr/threshold
- At 26438999: threshold=2, ownersArr=[0x47912780986197066edf3b4fcd8bf1a66e0d5c97 (EOA, nonce 10), 0xbaf8f97ac3ba6c334be1cf926521481bc395c264 (EOA, nonce 40)], nonce 0; EIP-1967 slots zero
- ETH balance 0 at 26438999; created block 14045983 (2022-01-21)
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before either owner gives its key code, both sign execute(self, setOwners(...)) to move to keys that will remain EOAs.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
