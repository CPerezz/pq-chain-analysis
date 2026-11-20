---
id: ff37b5eb-signer-upgrade-only
title: "0xff37b5eb: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xff37b5ebb5013c3af51a9d89e511c8874cbe4a52"
  family: "14cc55dc8bcd4e7d78c68baf59696f48"
  copies: 3
  upgradeable: "yes"
  admin: "owner 0xD33aAEc801EC5550f6a6227881ED27b36bBA87b4"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner EOA 0xD33aAEc8 (by a signed execTransaction)"
evidence:
  level: bytecode
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
  note: "LOW on the reading that an owner-signed delegatecall acts as an upgrade by a live owner, the same treatment as owner-upgradeable smart accounts. If the reviewer does not accept a delegatecall rewrite as an upgrade path, this is HIGH (a wallet whose fixed owner's signature is the only way to move its funds). The DELEGATECALL operation was taken from the scanner and the Safe ABI, not executed."
---

## Summary

A minimal delegatecall proxy (slot 0 = implementation 0x0254d8f7) for a single-owner Safe-style wallet: execTransaction needs the owner's ECDSA signature (owner in slot 1, set once by setup). The wallet can execute a DELEGATECALL operation, so the owner can rewrite slot 0, an upgrade, while the key is still an EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x0254d8f70c9131fdf72bcba0e020815a5847634c: no admin, no upgrade function in the implementation.
- the row's 107-byte code delegatecalls to sload(0) = 0x0254d8f7; slot 1 = owner 0xD33aAEc8 (EOA, nonce 207); getOwners() = [0xD33a]; nonce() = 0; balance 0
- eth_call execTransaction from the owner with an empty signature or a Safe v=1 'approved by caller' signature reverts InvalidSignature() (0x8baa579f): no direct-call path
- setup(address) reverts 0x0dc149f0 (already set up); implementation ABI: setup, isOwner, getOwners, nonce, domainSeparator, execTransaction; no owner setter
- scanner on the implementation: one DELEGATECALL to a calldata target (pc 938) besides the CALL; both ecrecovers compare to storage (eq_storage); no ERC-1271 call

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner signs an execTransaction with operation=delegatecall that rewrites slot 0 to a new implementation (or moves the funds), before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
