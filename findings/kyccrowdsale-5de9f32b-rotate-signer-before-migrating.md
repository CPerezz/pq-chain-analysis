---
id: kyccrowdsale-5de9f32b-rotate-signer-before-migrating
title: "KYCCrowdsale: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5de9f32b2665bb2cdc23bfb51b03e2a2985ecc87"
  family: "bb977a33edf8e7099b6390429dab109c"
  copies: 2
  name: "KYCCrowdsale"
  upgradeable: "no"
  rating: LOW
  value_usd: 26888
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-12
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x6f5a…a46b"
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
  note: "Live EOA owner replaces the key."
---

## Summary

KYCCrowdsale: purchases require a server signature recovered to signerAddress (0x513A…E2E8, nonce 0).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setSignerAddress(address) is onlyOwner (KYCCrowdsale.sol:1272)
- owner() = 0x6f5a…a46b, EOA nonce 49 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $26,888 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-12.

## Remediation

Owner calls setSignerAddress(newKey).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
