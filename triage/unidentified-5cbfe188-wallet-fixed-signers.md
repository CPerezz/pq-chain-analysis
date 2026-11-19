---
id: unidentified-5cbfe188-wallet-fixed-signers
title: "11 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-5cbfe188
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0657bfbf55a72c3ec8f677ef83de443ac9eb097e"
  name: "unverified code (study family 57cab33f), 1 of 11 addresses running it"
  upgradeable: "no"
families:
- code: "0x0657bfbf55a72c3ec8f677ef83de443ac9eb097e"
  name: "unverified code (study family 57cab33f)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 23279
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 57cab33f"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 11 addresses, $23k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x0657bfbf55a72c3ec8f677ef83de443ac9eb097e` (unverified, family `57cab33f`, 11 addresses, $23k): multisig with ordered owner signatures; no function name that changes owners. Decided by: bytecode and names (no source).
