---
id: unidentified-9406cc61-signer-upgrade-only
title: "SimpleAccount (613 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-9406cc61
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe9a02ce2319bbc263baab66f8f6b74305cf42777"
  name: "SimpleAccount (study family c43fd5ca), 1 of 613 addresses running it"
  upgradeable: "yes"
families:
- code: "0xe9a02ce2319bbc263baab66f8f6b74305cf42777"
  name: "SimpleAccount (study family c43fd5ca)"
  instances: 613
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7940
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c43fd5ca"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 613 addresses, $8k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xe9a02ce2319bbc263baab66f8f6b74305cf42777` (SimpleAccount, family `c43fd5ca`, 613 addresses, $8k): SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Decided by: read (same function texts). Executed: a real transaction reverts when its signer has code.
