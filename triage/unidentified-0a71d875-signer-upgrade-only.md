---
id: unidentified-0a71d875-signer-upgrade-only
title: "AccountImplementation (846 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-0a71d875
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x44ae91b2bea0c5a6c89ddf92c7406010a5df6987"
  name: "AccountImplementation (study family 2177489d), 1 of 846 addresses running it"
  upgradeable: "yes"
families:
- code: "0x44ae91b2bea0c5a6c89ddf92c7406010a5df6987"
  name: "AccountImplementation (study family 2177489d)"
  instances: 846
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7399
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2177489d"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 846 addresses, $7k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x44ae91b2bea0c5a6c89ddf92c7406010a5df6987` (AccountImplementation, family `2177489d`, 846 addresses, $7k): Solady ERC1271 account: SignatureCheckerLib on the account's signer / Solady ERC1271 nested EIP-712: SignatureCheckerLib on the account's signer / Solady ERC1271 RPC path: SignatureCheckerLib on the account's signer. Decided by: read (function text).
