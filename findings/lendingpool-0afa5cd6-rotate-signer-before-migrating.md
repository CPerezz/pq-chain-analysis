---
id: lendingpool-0afa5cd6-rotate-signer-before-migrating
title: "LendingPool: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0afa5cd68d624aca5f8e588ea6295d89c2d14c14"
  family: "f8a41c6885804304896e285e58faee42"
  copies: 130
  name: "LendingPool"
  upgradeable: "no"
  rating: LOW
  value_usd: 16061
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xDA696767… (3 of 5)"
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
  note: "Setter with a live Safe owner; the funds are owner-withdrawable anyway."
---

## Summary

NFT LendingPool checkOracle requires the ecrecover result == oracle. Borrowing stops if the oracle key holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- LendingPool.sol:236-249: ecrecover(...) == oracle
- LendingPool.sol:212 setOracle(address) onlyOwner
- owner() 0xDA6967678522C04d2D0C362808220D69dBe2Ca31: Safe, threshold 3, 5 owners at block 26438999; oracle 0x4096b3F0…

## Impact and exposure

- Value held at block 26,438,999: $16,061 (ETH and 49 priced tokens, over 130 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner Safe calls setOracle with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
