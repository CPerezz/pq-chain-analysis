---
id: 765ca77c-signer-upgrade-only
title: "0x765ca77c: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x765ca77cb596ef919ab0494d283955ceb8ebc141"
  family: "2efa9dbd9adab437c4b9666bf0b563c4"
  copies: 4
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Rule: an uninitialized (or initializer-disabled) implementation is refuted. Not checked: which proxies point to it."
---

## Summary

src/SlickSwapV1.sol:SlickSwapV1: this address is a logic/implementation contract, never initialized: owner and the signer storage are empty, holding no ETH; it has no signer of its own, so nothing here depends on a stored key. SlickSwapV1 logic contract: every signed action (upgrade, withdraw, setNextOwner) also has an onlyBy(_owner) direct-call twin, and setNextOwner replaces the key.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgrade). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: upgrade((uint8,bytes32,bytes32,uint96)), but owner() is zero or absent. 4 with an upgrade function whose caller was not read.
- block 26438999 (read before the node saturated): owner()=NA, EIP-1967 admin slot=0, slot0=0x0000000000000000000000000000000000000000000000000000000000000000, OZv5 initializer slot low bytes=0000000000000000, ETH balance=0.000000000000000000
- Upgrade selectors present: upgrade((uint8,bytes32,bytes32,uint96)),upgrade(); the batch 'owner zero' is expected for an implementation
- Source/decompile: src/SlickSwapV1.sol:SlickSwapV1; txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. Any proxies running this code are separate rows; they are upgradeable by their own owner/admin (UUPS).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
