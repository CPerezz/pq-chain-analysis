---
id: smartaccount-2da74aad-signer-upgrade-only
title: "SmartAccount: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2da74aad722b57a039d5e2df9497438e20886858"
  family: "c4d40d28600ff8774feaefb20bb255b9"
  copies: 680
  name: "SmartAccount"
  upgradeable: "yes"
  admin: "the owner, through a signed self-call"
  rating: LOW
  value_usd: 7834
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "each account's owner upgrades it (updateImplement) or enables a module before the owner key takes code"
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
  note: "The wallet's own signers (or owner) can upgrade it, or enable a module, with a signed call while their keys are still EOAs: a simple update by a live party, as with a key rotation, so LOW. Signers who take code without upgrading first would lock it."
---

## Summary

A SmartAccount proxy (one of 680 copies). The owner is set once in Initialize and has no setter. updateImplement and enableModule are self-only, so they too need an owner-signed userOp. After the owner key takes code, the wallet's funds cannot move.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: validateUserOp: the recovered address must be the owner / validateUserOpWithoutSig: the recovered address must be the owner / isValidSignature: the recovered address must be an owner. Read from source. Executed: a real transaction loses its effect with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x3dbeb76d9d9444d7db9dcf3799e17acd247f8fac: no admin, no upgrade function in the implementation.
- OwnerManager has no setter; Singleton.updateImplement is authorized (self); validateUserOp requires ECDSA.recover == owner; isValidSignature is ECDSA-only (dossier source)
- At block 26438999: slot 0 holds implementation 0x3dbeb76d…; slot 2 holds owner 0x83330e70…, an EOA (latest block ~26452920); balance 0.262 ETH
- The module path needs a module the wallet itself enabled (modules[msg.sender]) plus the EntryPoint whitelist

## Impact and exposure

- Value held at block 26,438,999: $7,834 (ETH and 49 priced tokens, over 680 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before migrating, the owner upgrades through a signed userOp to an implementation with an owner setter

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
