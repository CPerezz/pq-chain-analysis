---
id: luckyfish-38d8b04a-rotate-signer-before-migrating
title: "LuckyFish: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x38d8b04ab6b9392c8e14f4745eb25dc3f4a49bb0"
  family: "f6ad977085276b84b2665e811bda791e"
  name: "LuckyFish"
  label: "LuckyFish: LF Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 11549
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 53
  last_active: 2026-10-11
fix:
  layer: onchain-config
  who_acts: "owner 0x3817fdefe40b8b861e313ae0bfe97df269f18fd2"
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
  note: "The setter is callable by a live EOA owner: LOW."
---

## Summary

LuckyFish NFT mint requires ECDSA.recover == signerAddress. Signed mints die if that signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- LuckyFish.sol:55 setSignerAddress(address) onlyOwner; :35 signerAddress == ECDSA.recover
- owner()=0x3817…8fd2: EOA (no code), nonce 99 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $11,549 (ETH and 49 priced tokens).
- Activity: 53 transactions called it in the 90 days before that block; last on 2026-10-11.

## Remediation

The owner calls setSignerAddress with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
