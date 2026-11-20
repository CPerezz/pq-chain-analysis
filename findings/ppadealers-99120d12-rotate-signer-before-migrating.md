---
id: ppadealers-99120d12-rotate-signer-before-migrating
title: "PPADealers: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x99120d128a5f7cb81c318a24fa1f60f66d9777d7"
  family: "d2b00a0197c1a417e295abbb038ef8a9"
  name: "PPADealers"
  label: "PPADealers: DLR Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 10647
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 22
  last_active: 2026-11-03
fix:
  layer: onchain-config
  who_acts: "owner 0x132266286f204d9eb2b48f16d25ed74ce5275636"
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

PPADealers NFT mint checks recover(sig) == signerAddress. Signed mints die if that signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- PPADealers.sol:169 setSignerAddress(address) onlyOwner; :111 recover
- owner()=0x1322…5636: EOA, nonce 569 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,647 (ETH and 49 priced tokens).
- Activity: 22 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

The owner calls setSignerAddress with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
