---
id: vault-f45e0fd6-signer-upgrade-only
title: "Vault: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf45e0fd68b440eb8574504379bff3db67e53db37"
  family: "5cf12370be5316bf9cfd6b21ea225cd7"
  name: "Vault"
  upgradeable: "yes"
  admin: "each proxy's owner (UUPS _onlyOwner); for 0xa521ba3b: 0x4664560508435c4b00248abDBf2e2682985B26FD"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the account owner"
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
  note: "The same act stays open by the owner's direct call, and a live owner can upgrade, so LOW."
---

## Summary

Vault (a SimpleAccount variant): user operations need the owner's ECDSA signature, but execute/executeBatch also accept a direct call from the owner, and the owner can upgrade the code (UUPS).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- source contracts/Vault.sol: _requireFromEntryPointOrOwner accepts msg.sender == owner; _validateSignature requires owner == hash.recover(sig); _authorizeUpgrade -> _onlyOwner (owner or self)
- dossier proxy 0xa521ba3b: implementation slot = row; owner() = 0x46645605, a 7702-delegated EOA (nonce 379), so the owner is live; 0.1 ETH held
- the row itself is the implementation (slot 0 = 0xff, initializers disabled; owner() = 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls execute directly or upgrades the account before its key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
