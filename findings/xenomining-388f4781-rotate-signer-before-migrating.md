---
id: xenomining-388f4781-rotate-signer-before-migrating
title: "XenoMining: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x388f478199f45a67db6765ffcbe07f0197623678"
  family: "f84243d83716ac530f07ceec95651cf5"
  copies: 2
  name: "XenoMining"
  label: "deployed by Xeno: Deployer 1"
  upgradeable: "yes"
  rating: LOW
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin owner 0x9CE83B55…83E7 (EOA)"
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
  note: "No signer setter, but a live upgrade path through an EOA-owned ProxyAdmin, so LOW."
---

## Summary

XenoMining voucher claims: ecrecover must equal the stored distributor. If the distributor takes code, claims fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- XenoMining.sol _isVerified: signer == distributor; distributor is set only in initialize, with no setter
- Transparent proxy: impl 0xf0143e8d…, EIP-1967 admin 0x8a8e23a9… (ProxyAdmin)
- ProxyAdmin.owner() = 0x9CE83B5525643BCc2e33FE61113eA5A1169a83E7, no code, nonce 52 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $9,925 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the implementation to add a distributor setter (or keep the distributor an EOA/7702 account).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
