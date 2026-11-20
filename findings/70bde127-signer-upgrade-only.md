---
id: 70bde127-signer-upgrade-only
title: "0x70bde127: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x70bde127c9b8c34d6479b9b247f503ceb1bad262"
  family: "99eb5777e276134d2e797f353cd78ff6, 12e58688c6286073fdcfc1af56798030"
  copies: 16
  upgradeable: "yes"
  admin: "the signer set itself, through a signed execute self-call"
  rating: LOW
  value_usd: 92
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 323
  last_active: 2026-10-11
fix:
  layer: contract-upgrade
  who_acts: "the multisig's signers upgrade it before their keys take code"
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
  note: "The wallet's own signers (or owner) can upgrade it, or enable a module, with a signed call while their keys are still EOAs: a simple update by a live party, as with a key rotation, so LOW. Signers who take code without upgrading first would lock it."
---

## Summary

A multisig proxy whose signer set (abdb40…, 372024…) is fixed in proxy storage. It can be upgraded only by a call that those same signers sign. Once their keys take code, nothing moves the wallet's funds.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template 69a8fbf8, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x77313dc19ede0b63b7f21e206ba92526abef0987: no admin, no upgrade function in the implementation.
- Same proxy code: the signer set lives in a namespaced mapping (base 0x7205e0dd…-1) that only the constructor writes. upgradeTo/upgradeToAndCall require msg.sender == address(this), i.e. a self-call through execute(address,bytes,bytes) signed by the signer set (sorted ecrecover loop). The implementation never touches that slot. (heimdall decompile and disassembly of the proxy)
- Creation tx 0x34f4378d… (block 24857842) lists the signers 0xabdb40c0… and 0x372024987e…; both are EOAs (latest block ~26452920)
- The implementation in the slot is 0x821c29b2… (the note said 0x77313d…); slot 1 = 2, possibly the threshold; balance 0.0031 ETH (node, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $92 (ETH and 49 priced tokens, over 16 addresses).
- Activity: 323 transactions called it in the 90 days before that block; last on 2026-10-11.

## Remediation

Before migrating, the signers execute a signed upgrade to an implementation that can rotate the set

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
