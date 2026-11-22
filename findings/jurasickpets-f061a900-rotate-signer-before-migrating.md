---
id: jurasickpets-f061a900-rotate-signer-before-migrating
title: "JurasickPets: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf061a9001fa4957e7e0bc6143b332fd76759a471"
  family: "841a453d075257b9382140a16a9eb925"
  name: "JurasickPets"
  label: "deployed by JurasickPets: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 17685
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-30
fix:
  layer: none
  who_acts: "none (owner can still use other paths)"
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
  note: "No setter, so not LOW. Only the WL mint dies; the owner still withdraws the funds, so MEDIUM."
---

## Summary

JurasickPets NFT wlMint checks ecrecover == wlSigner. wlSigner is set only in the constructor, so a wlSigner with code kills whitelist minting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be one stored signer of the contract (an affiliate, system, consensus, updater, admin or whitelist key). Read from source.
- JurasickPets.sol:15,41,176: wlSigner is private, assigned only in the constructor; no setter exists among the functions
- public mint() and owner freeMint/withdrawMoney/emergencyWithdrawMoney (onlyOwner) stay open
- owner() 0x6f9aec78…: EOA, nonce 191

## Impact and exposure

- Value held at block 26,438,999: $17,685 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-30.

## Remediation

None on-chain for the WL path; keep the wlSigner key as an EOA, or use the public mint/freeMint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
