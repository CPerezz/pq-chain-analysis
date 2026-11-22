---
id: ecdsaownershipregistrymodule-c47e6767-rotate-signer-before-migrating
title: "EcdsaOwnershipRegistryModule: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc47e67676551bb74cabe6f1925172a8035955b82"
  family: "2635f88c10446d6505b4abf1ac550119"
  copies: 5
  name: "EcdsaOwnershipRegistryModule"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1693
  last_active: 2026-11-18
  recoveries_14d: 467
fix:
  layer: account-migration
  who_acts: "each Biconomy smart account (the account itself)"
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
  note: "LOW by the account's own call. A 7702-delegated owner EOA still recovers under EIP-8151."
---

## Summary

Biconomy EcdsaOwnershipRegistryModule: the recovered address must equal _smartAccountOwners[account]. Under EIP-8151 an owner key that later holds real code no longer validates.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner registered for the calling smart account; the account can transfer it. Read from source. Executed: a real transaction reverts with code at the signer.
- source EcdsaOwnershipRegistryModule.sol:56-60 transferOwnership(owner) writes _smartAccountOwners[msg.sender]: only the account itself can call it, and it rejects contract owners (extcodesize)
- _verifySignature (l.160-183) compares the ECDSA recover result with the stored owner, with no 1271 fallback
- Not upgradeable; no global admin

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 1,693 transactions called it in the 90 days before that block; last on 2026-11-18.
- 467 signature recoveries in the study's two-week trace window.

## Remediation

The account calls transferOwnership(newEOA) (or switches validation module) while the current owner key still works.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
