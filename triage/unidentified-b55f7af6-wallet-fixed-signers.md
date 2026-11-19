---
id: unidentified-b55f7af6-wallet-fixed-signers
title: "242 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-b55f7af6
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbf88e90783d1049acae742b181af3ebce0faef33"
  name: "unverified code (study family cde8a592), 1 of 242 addresses running it"
  upgradeable: "no"
families:
- code: "0xbf88e90783d1049acae742b181af3ebce0faef33"
  name: "unverified code (study family cde8a592)"
  instances: 242
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cde8a592"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 242 addresses, $1k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xbf88e90783d1049acae742b181af3ebce0faef33` (unverified, family `cde8a592`, 242 addresses, $1k): 242 multisig wallets with ordered owner signatures and no way to change owners. Decided by: bytecode and names (no source).
