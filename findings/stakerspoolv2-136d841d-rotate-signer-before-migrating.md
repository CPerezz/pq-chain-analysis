---
id: stakerspoolv2-136d841d-rotate-signer-before-migrating
title: "StakersPoolV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x136d841d4bece3fc0e4debb94356d8b6b4b93209"
  family: "c9d97a3cbc3068e5c53a65ac254c8131"
  copies: 2
  name: "StakersPoolV2"
  label: "InsurAce Protocol: Stakers Pool V2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 29956
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x345c…2488"
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
  note: "Live EOA owner controls the signer set; no ERC-1271."
---

## Summary

Insur StakersPoolV2 (proxy): _checkSignature needs two distinct signers from signerFlagMap (recovered via ecrecover) to set reward info.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (signer, validator, authority, relayer), distinct or ordered; a quorum or weight is needed. Read from source.
- setStakersPoolSigner(address,bool) is onlyOwner (StakersPoolV2.sol:336)
- owner() = 0x345c…2488, EOA nonce 1820 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $29,956 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner enables new signers and disables migrated ones via setStakersPoolSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
