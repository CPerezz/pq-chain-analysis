---
id: unidentified-000000a7-wallet-fixed-signers
title: "7 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-000000a7
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb61695537801cdb6ada7390d44e887c9db7dd87d"
  name: "unverified code (study family 29604666), 1 of 7 addresses running it"
  upgradeable: "no"
families:
- code: "0xb61695537801cdb6ada7390d44e887c9db7dd87d"
  name: "unverified code (study family 29604666)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1804560
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 29604666"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 7 addresses, $1.8M held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xb61695537801cdb6ada7390d44e887c9db7dd87d` (unverified, family `29604666`, 7 addresses, $1.8M): BitGo pattern (isSigner, sendMultiSig), 1,000 ETH: no function name that changes signers. Decided by: bytecode and names (no source).
