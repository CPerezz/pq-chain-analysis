---
id: account-b5a650a6-rotate-signer-before-migrating
title: "Account: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5a650a68f8328090135ea96b4a1455debf72b0e"
  family: "076aeff3307ff9ed98702a2679274030"
  copies: 4360
  name: "Account"
  label: "created by Nuo Network: Account Factory v2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 131733
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "user + admin"
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
  note: "rotation by the key holder via live admin relay"
---

## Summary

Account (masterCopy proxy): transferByUser/addUser need a user's signature, relayed by a Config admin.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: returns the recovered signer / the signer must be a user of the account; an admin relays; users are added and removed by a user's signature / addUser: signed by a current user, relayed by an admin /…. Read from source.
- addUser/removeUser: user-signed, onlyAdmin relay (Account.sol:516-560)
- Config 0x431f…: admins live EOAs (nonce 678/64046/64597, isAdminValid true); user 0x77e9… nonce 0 (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $131,733 (ETH and 49 priced tokens, over 4,360 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

user signs addUser for a new key before migrating; admin relays

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
