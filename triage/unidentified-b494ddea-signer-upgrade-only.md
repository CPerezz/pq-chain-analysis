---
id: unidentified-b494ddea-signer-upgrade-only
title: "BitcoinSafeOwner (2,177 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-b494ddea
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5aba37326c30303c5b03e0fe2d85e13964c6a10"
  name: "BitcoinSafeOwner (study family fc6b4d11), 1 of 2,177 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb5aba37326c30303c5b03e0fe2d85e13964c6a10"
  name: "BitcoinSafeOwner (study family fc6b4d11)"
  instances: 2177
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fc6b4d11"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2,177 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb5aba37326c30303c5b03e0fe2d85e13964c6a10` (BitcoinSafeOwner, family `fc6b4d11`, 2,177 addresses, $0): Bitcoin Safe owner (uncompressed P2PKH): the signature must recover to the Ethereum address of the Bitcoin public key that hashes to the stored Bitcoin address / Bitcoin Safe owner (compressed P2PKH): as above / Bitcoin… Decided by: read (function text).
