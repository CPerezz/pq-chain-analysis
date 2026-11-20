---
id: rexwearables-941ee0ff-rotate-signer-before-migrating
title: "RexWearables: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x941ee0ff51da1906459cb158a41f5cb644479fd5"
  family: "50c629440cb941287184322c71742b95"
  name: "RexWearables"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2412
  last_active: 2026-11-15
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x8e99…69cd"
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
  note: "Setter exists and the owner is a live EOA, so LOW holds."
---

## Summary

An ERC-1155 contract with signature-gated redeem: the recovered address must be in the redeem-signer set. A signer whose account holds code can no longer authorize redeems.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setAutomaticApprovalOfTransfersFromValidator, setMinter, setRedeemSigner, setTransferValidator). Whoever holds it must replace it…. Rule: stored-key.
- setRedeemSigner(address,bool) (0x5ff06127) and setMinter(address,bool) (0xcf456ae7) both require msg.sender == owner, 'Ownable: caller is not the owner' (decompile)
- owner() = 0x8e99F34849f60e1fCfBbfEE3F780199C0A5D69cd, an EOA with nonce 61, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,412 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

The owner calls setRedeemSigner(new, true) and then setRedeemSigner(old, false).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
