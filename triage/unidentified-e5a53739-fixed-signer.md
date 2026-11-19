---
id: unidentified-e5a53739-fixed-signer
title: "BridgeMinter (9 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-e5a53739
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xce6e33945a931465f3778483688ec9a6db536330"
  name: "BridgeMinter (study family 1736fa20), 1 of 9 addresses running it"
  upgradeable: "no"
families:
- code: "0xce6e33945a931465f3778483688ec9a6db536330"
  name: "BridgeMinter (study family 1736fa20)"
  instances: 9
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1736fa20"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 9 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xce6e33945a931465f3778483688ec9a6db536330` (BridgeMinter, family `1736fa20`, 9 addresses, $0): BridgeMinter: bridge() needs the signatures of `approver` and of `notary`, two addresses in storage that no function of the contract can change / BridgeMinter.recoverSigner: returns the signer / BridgeMinter.tryRecover:… Decided by: read (function text).
