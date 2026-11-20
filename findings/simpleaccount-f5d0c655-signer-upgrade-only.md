---
id: simpleaccount-f5d0c655-signer-upgrade-only
title: "SimpleAccount: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf5d0c65516f0724242343c4eaa5d9de3ee4291fb"
  family: "4a7de92bd7a0be5dcffa67664003eeca"
  name: "SimpleAccount"
  upgradeable: "yes"
  admin: "each proxy's owner or the AAConfig controller; for 0xc973ab50 owner 0xB1077B7c62844eFBA104d767127a5DB6c0F5A0CC"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the account owner or the AAConfig controller"
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
  verdict: confirmed
  rating: LOW
  note: "A direct call stays open and a live owner can upgrade, so LOW."
---

## Summary

SimpleAccount variant: user operations need the owner's or the controller's ECDSA signature, but execute also accepts a direct call from the owner, and the owner or the controller can upgrade (UUPS).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount _validateSignature: the stored owner or the controller signs. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- source contracts/samples/SimpleAccount.sol: _requireFromEntryPointOrOwner accepts msg.sender == owner; _onlyOwner accepts getController(), owner, or self; _authorizeUpgrade -> _onlyOwner
- dossier proxy 0xc973ab50: implementation slot = row; owner() = 0xB1077B7c, a 7702-delegated EOA (nonce 30); 0.0001338 ETH
- the row is the implementation (slot 0 = 0xff, owner() = 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls execute directly or upgrades the account; the controller can also upgrade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
