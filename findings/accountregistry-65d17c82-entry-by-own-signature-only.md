---
id: accountregistry-65d17c82-entry-by-own-signature-only
title: "AccountRegistry: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x65d17c827b82e4d636131dc6dd08fdfc04db7854"
  family: "7c30cb82dffd7b173ffa236c02f49614"
  name: "AccountRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "account registering a public key (signs from an EOA/7702 key)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Pure registration; nothing held. LOW holds."
---

## Summary

Nava AccountRegistry: registerAccount stores a public key only if ecrecover over (account, pubkey) == account. Under EIP-8151 an account with non-7702 code cannot register a key; no funds.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: AccountRegistry registerAccount: the account named signs its own public key; one with code cannot / returns the recovered address or its id to a caller that decides. Rule: same text up to names.
- source/account.sol:9-13 registerAccount require(recoverSigner(...) == account); :15-19 removePublicKey by msg.sender, no signature
- 42-line contract with no payable or transfer; state slots zero, balance 0 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Register from an EOA or 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
