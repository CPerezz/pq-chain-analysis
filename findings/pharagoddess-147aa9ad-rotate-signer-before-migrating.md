---
id: pharagoddess-147aa9ad-rotate-signer-before-migrating
title: "PharaGoddess: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x147aa9ada01b70c4c8c8b89b06afe767908aced7"
  family: "d1d8280de275670fce00b7ef8fa888a3"
  copies: 3
  name: "PharaGoddess"
  label: "PharaGoddess: PGS Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 27249
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18
  last_active: 2026-11-14
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xd474…3768"
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

PharaGoddess NFT: presale mint requires a signature recovered to the stored 'dummy' address.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be one stored signer of the contract (an affiliate, system, consensus, updater, admin or whitelist key). Read from source.
- changeDummy(address) is onlyOwner (PharaGoddess.sol:2058)
- owner() = 0xd474…3768, EOA nonce 13 at 26438999
- withdrawFund is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $27,249 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Owner calls changeDummy(newKey).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
