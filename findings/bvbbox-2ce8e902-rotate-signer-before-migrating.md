---
id: bvbbox-2ce8e902-rotate-signer-before-migrating
title: "BvbBox: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2ce8e90200c02ee7f82f99708dc0dfee9c292bd7"
  family: "d67919a48626b1cb4ff589cf536f8a7e"
  name: "BvbBox"
  label: "deployed by Borussia Dortmund: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 21113
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-10
fix:
  layer: onchain-config
  who_acts: "owner Safe"
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
  note: "There is a setter and a live Safe owner."
---

## Summary

BvbBox NFT mint checks a per-channel signer with OZ ECDSA.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- BvbBox.sol:2182 setSigners(uint8,address) onlyOwner; :2122 ECDSA.recover == signers[channel]
- owner 0x4451…19a4 is a Safe, threshold 2, 2 owners

## Impact and exposure

- Value held at block 26,438,999: $21,113 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-10.

## Remediation

Owner Safe calls setSigners.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
