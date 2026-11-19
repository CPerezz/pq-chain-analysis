---
id: walletsimple-d1560b39-custody-wallets-fixed-signers
title: "WalletSimple: custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd1560b3984b7481cd9a8f40435a53c860187174d"
  family: "f28126df7e445a37a0f093cceab111e3"
  name: "WalletSimple"
  label: "COSS.io: Old Warm Wallet"
  upgradeable: "no"
  rating: HIGH
  value_usd: 393
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the custodian moves funds to wallets it can change before its signers take code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-custody-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "signers read; all EOAs today; no setter, no upgrade path; dormant"
---

## Summary

`WalletSimple` at `0xd1560b3984b7481cd9a8f40435a53c860187174d` (Etherscan tag: COSS.io: Old Warm Wallet). A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: BitGo WalletSimple (2017) tagged 'COSS.io: Old Warm Wallet': the second signer must be one of the wallet's signers, fixed at creation; an exchange's wallet. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Verified BitGo WalletSimple (2017): sendMultiSig needs msg.sender to be a signer and an ECDSA signature by another signer; signers are fixed at creation; no proxy, no upgrade.
- State at block 26,438,999: 3 signers, all EOAs today; it locks once all three have code.
- Holds $393; no transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $393 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
