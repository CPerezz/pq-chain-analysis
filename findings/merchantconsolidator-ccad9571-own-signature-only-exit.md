---
id: merchantconsolidator-ccad9571-own-signature-only-exit
title: "MerchantConsolidator: funds released only by the party's own signature"
status: confirmed
severity: LOW
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xccad95719d3e26caf3b87dc73ea4a140a67c9510"
  family: "d54dd91dc42dc30c395222a07c676a7a"
  copies: 32
  name: "MerchantConsolidator"
  upgradeable: "yes"
  rating: LOW
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 112
  last_active: 2026-11-18
fix:
  layer: account-migration
  who_acts: "the holder of the account key 0xccad95719d3e26caf3b87dc73ea4a140a67c9510"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a 7702 re-delegation by a live key holder is a simple update."
---

## Summary

An EIP-7702-delegated account (the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it); EIP-8151 makes the signer check fail once the signer has code.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: 7702 account: re-delegates.
- cast code 0xccad95719d3e26caf3b87dc73ea4a140a67c9510 at block 26438999: 23 bytes starting 0xef0100 (delegation indicator), so this is an EOA running delegated code
- cast nonce 0xccad95719d3e26caf3b87dc73ea4a140a67c9510 at block 26438999 = 3: the key holder has sent transactions and can sign a new 7702 authorization

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 32 addresses).
- Activity: 112 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Account key holder re-delegates to code that checks a replaceable signer or accepts ERC-1271, or signs with an EOA signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
