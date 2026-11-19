---
id: unidentified-3c93d68a-signer-upgrade-only
title: "StakingVault (1,131 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-3c93d68a
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb59527a6447ddb1cafa7966a6b45fc809835a890"
  name: "StakingVault (study family fe3599da), 1 of 1,131 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb59527a6447ddb1cafa7966a6b45fc809835a890"
  name: "StakingVault (study family fe3599da)"
  instances: 1131
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fe3599da"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1,131 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb59527a6447ddb1cafa7966a6b45fc809835a890` (StakingVault, family `fe3599da`, 1,131 addresses, $0): Solady ERC1271 account: SignatureCheckerLib on the account's signer / Solady ERC1271 nested EIP-712 (variant): SignatureCheckerLib on the account's signer / Solady ERC1271 RPC path (variant). Decided by: read (function text).
