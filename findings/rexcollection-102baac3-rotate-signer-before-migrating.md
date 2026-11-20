---
id: rexcollection-102baac3-rotate-signer-before-migrating
title: "RexCollection: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x102baac34a7f672717c5dde6539aef33690e10ba"
  family: "e701758e6f15e2d7037dc4668397da79"
  name: "RexCollection"
  upgradeable: "no"
  rating: LOW
  value_usd: 1047
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2761
  last_active: 2026-11-15
fix:
  layer: onchain-config
  who_acts: "owner"
evidence:
  level: bytecode
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
  note: "Setter callable by a live EOA owner."
---

## Summary

RexCollection NFT mints need a signature from an allowed mint signer. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setAutomaticApprovalOfTransfersFromValidator, setEquipmentManager, setMintSigner, setTokenAccountConfig). Whoever holds it must…. Rule: stored-key.
- RexCollection.sol:358 setMintSigner(address,bool) calls _requireCallerIsContractOwner() (OwnableBasic)
- owner() = 0x8e99F348…; owner is an EOA (no code, nonce 61) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $1,047 (ETH and 49 priced tokens).
- Activity: 2,761 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

Owner allows a new mint signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
