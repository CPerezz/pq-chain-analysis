---
id: unidentified-a946e9d3-signer-upgrade-only
title: "ERC6551Account (2,145 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-a946e9d3
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf48bad65ed74b46d622e81e5694edf9c6074dd3b"
  name: "ERC6551Account (study family 7f645a14), 1 of 2,145 addresses running it"
  upgradeable: "yes"
families:
- code: "0xf48bad65ed74b46d622e81e5694edf9c6074dd3b"
  name: "ERC6551Account (study family 7f645a14)"
  instances: 2145
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7f645a14"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2,145 addresses, $180 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xf48bad65ed74b46d622e81e5694edf9c6074dd3b` (ERC6551Account, family `7f645a14`, 2,145 addresses, $180): Solady ERC1271 isValidSignature: SignatureCheckerLib on the account's signer. Decided by: read (function text).
