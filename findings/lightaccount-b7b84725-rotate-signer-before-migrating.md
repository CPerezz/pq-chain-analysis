---
id: lightaccount-b7b84725-rotate-signer-before-migrating
title: "LightAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb7b84725790b8a179bb310aa51548ed2e6872af7"
  family: "e6aa3f411cd2cd242d8912689ac15080"
  copies: 4
  name: "LightAccount"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2669
  last_active: 2026-11-18
  recoveries_14d: 406
fix:
  layer: account-migration
  who_acts: "the account's owner EOA 0x9694…e154"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Setter callable by the key holder itself; the 1271 branch also eases it."
---

## Summary

Alchemy LightAccount: user ops are validated against the stored owner by ECDSA (type EOA) or ERC-1271 (type CONTRACT). An owner that gets code fails the EOA path.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: LightAccount: ECDSA of the stored owner, or ERC-1271 when the owner is a contract; transferOwnership (read) by the owner or the account itself. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- source LightAccount.sol:82 transferOwnership onlyAuthorized (the owner or the account itself via execute/user op)
- _validateSignature/_isValidSignature also accept SignatureType.CONTRACT (ERC-1271 on the owner), so a migrated owner that implements 1271 still works
- owner at block 26438999 = 0x96942125…e154, EOA nonce 0 (it acts through EntryPoint user ops, so the key is live); also UUPS upgradeToAndCall by the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 2,669 transactions called it in the 90 days before that block; last on 2026-11-18.
- 406 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls transferOwnership to a fresh EOA, or switches to CONTRACT-type signatures, before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
