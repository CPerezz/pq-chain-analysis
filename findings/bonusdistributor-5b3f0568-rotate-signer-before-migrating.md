---
id: bonusdistributor-5b3f0568-rotate-signer-before-migrating
title: "BonusDistributor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5b3f0568b4499646d6992aa600ae0e8b86b4dbe9"
  family: "bbd9d1dd13d34c29c3cdf80e607664bd"
  copies: 2
  name: "BonusDistributor"
  upgradeable: "no"
  rating: LOW
  value_usd: 77777
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-04
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x66a2…c39e"
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
  note: "Owner-gated setter, active owner EOA."
---

## Summary

BonusDistributor: claims need an ecrecover signature from the stored signer; a signer with code makes claims revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- bonusDistributor.sol:37 updateSigner(address) onlyOwner
- owner() = 0x66a2d663…c39e, an EOA with nonce 10
- no ERC-1271 path (bonusDistributor.sol:98 raw ecrecover)

## Impact and exposure

- Value held at block 26,438,999: $77,777 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

Owner calls updateSigner with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
