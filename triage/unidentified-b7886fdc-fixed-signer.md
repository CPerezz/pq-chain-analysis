---
id: unidentified-b7886fdc-fixed-signer
title: "BridgeMinterTimeLock (6 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b7886fdc
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x46b0ef8603fda297f16dc80742af4796dd747fa5"
  name: "BridgeMinterTimeLock (study family 4e1d6ba2), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0x46b0ef8603fda297f16dc80742af4796dd747fa5"
  name: "BridgeMinterTimeLock (study family 4e1d6ba2)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4e1d6ba2"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x46b0ef8603fda297f16dc80742af4796dd747fa5` (BridgeMinterTimeLock, family `4e1d6ba2`, 6 addresses, $0): BridgeMinter: bridge() needs the signatures of `approver` and of `notary`, two addresses in storage that no function of the contract can change / BridgeMinter.recoverSigner: returns the signer / BridgeMinter.tryRecover:… Decided by: read (function text).
