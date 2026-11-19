---
id: unidentified-8e98aeea-wallet-fixed-signers
title: "69 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-8e98aeea
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd056f1d470ba5ddc9d2c1a14a4c2e7bb2bd5e45f"
  name: "unverified code (study family ec3d3092), 1 of 69 addresses running it"
  upgradeable: "no"
families:
- code: "0xd056f1d470ba5ddc9d2c1a14a4c2e7bb2bd5e45f"
  name: "unverified code (study family ec3d3092)"
  instances: 69
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ec3d3092"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 69 addresses, $180 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xd056f1d470ba5ddc9d2c1a14a4c2e7bb2bd5e45f` (unverified, family `ec3d3092`, 69 addresses, $180): TEE-assisted wallets (69; 80 recoveries): client and enclave keys sign; inferred from names: an heir takes over after inactivity (lastSpend); no key setter by name. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
