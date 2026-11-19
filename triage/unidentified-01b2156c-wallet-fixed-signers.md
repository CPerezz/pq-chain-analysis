---
id: unidentified-01b2156c-wallet-fixed-signers
title: "AccredifyMultiSigDocStore (93 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-01b2156c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb5923a755e33436297b968ec42f2db0578460c18"
  name: "AccredifyMultiSigDocStore (study family 90346906), 1 of 93 addresses running it"
  upgradeable: "no"
families:
- code: "0xb5923a755e33436297b968ec42f2db0578460c18"
  name: "AccredifyMultiSigDocStore (study family 90346906)"
  instances: 93
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 90346906"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 93 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xb5923a755e33436297b968ec42f2db0578460c18` (AccredifyMultiSigDocStore, family `90346906`, 93 addresses, $0): Accredify document store multisig: the custodian submits, and a signature must recover to signers[0] (issue, revoke) or signers[1] (change store); the three signers are set in the constructor with no setter. A signer… Decided by: read. Executed: a real transaction reverts when its signer has code.
