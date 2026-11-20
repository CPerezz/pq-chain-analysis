---
id: remilia-d3d9ddd0-rotate-signer-before-migrating
title: "Remilia: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd3d9ddd0cf0a5f0bfb8f7fceae075df687eaebab"
  family: "4b419c629b647d6cf8a70cf08f57b98d"
  name: "Remilia"
  label: "Remilio: TEST Token"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2870
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the key holder or owner rotates the key"
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
  rating: MEDIUM
  note: "No setter or upgrade path: the affiliate feature dies but nothing is locked (mint stays open without an affiliate), so MEDIUM rather than LOW."
---

## Summary

Remilia NFT mint: an affiliate referral needs an ECDSA signature from config.affiliateSigner, which is hardcoded in the constructor.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be one stored signer of the contract (an affiliate, system, consensus, updater, admin or whitelist key). Read from source.
- Remilia.sol:1866 config.affiliateSigner = 0x1f285dD5…; the only config writes afterwards are unrevealedUri/baseUri (2010, 2018), so there is no signer setter
- mint (1882-1894) validates the affiliate only when affiliate != 0; minting without an affiliate stays open
- Not upgradeable; owner 0x54F8E4E9… (EOA, nonce 4) has no setter for the signer

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens).
- Activity: 2,870 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None on-chain. Keep the affiliate signer a plain key; affiliates otherwise lose referrals.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
