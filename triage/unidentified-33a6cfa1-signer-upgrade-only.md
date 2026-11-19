---
id: unidentified-33a6cfa1-signer-upgrade-only
title: "BridgeCommittee (12 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-33a6cfa1
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc3ea459135ae06c3f0df2e0aab9937be28d0037f"
  name: "BridgeCommittee (study family aa89732c), 1 of 12 addresses running it"
  upgradeable: "yes"
families:
- code: "0xc3ea459135ae06c3f0df2e0aab9937be28d0037f"
  name: "BridgeCommittee (study family aa89732c)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families aa89732c"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 12 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xc3ea459135ae06c3f0df2e0aab9937be28d0037f` (BridgeCommittee, family `aa89732c`, 12 addresses, $0): committee members by stake, each once, not blocklisted; members are not replaced by a function, only blocklisted. Decided by: read (function text).
