---
id: ammovault-0e9d8e14-rotate-signer-before-migrating
title: "AmmoVault: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0e9d8e14293dd069690c1addbf51b61b4dca2f96"
  family: "f29fbdcdbc67d7ac93c9d72030b27a41"
  copies: 2
  name: "AmmoVault"
  label: "deployed by Highstack: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 28873
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xb75a…a29a"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live EOA owner can rotate itself; funds withdrawable by owner."
---

## Summary

AmmoVault (WarriorAlliance) proxy: whitelistRegister requires the signature to recover to owner(). If the owner key takes code, registration fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: whitelist registration signed by a stored key (the comparison is past the cut of my view; the deployed code compares with storage). Read from source.
- Signer is owner() (AmmoVault.sol:164); OZ Ownable transferOwnership is onlyOwner
- owner() = 0xb75a…a29a, EOA nonce 919 at 26438999
- Contract is upgradeable (row) and owner holds withdraw/withdrawERC20

## Impact and exposure

- Value held at block 26,438,999: $28,873 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner transfers ownership to a fresh EOA before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
