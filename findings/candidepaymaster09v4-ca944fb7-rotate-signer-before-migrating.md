---
id: candidepaymaster09v4-ca944fb7-rotate-signer-before-migrating
title: "CandidePaymaster09V4: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xca944fb73fa5191969014ded9bb075381d59c7de"
  family: "736919c62816b852bd04810b124fc817"
  name: "CandidePaymaster09V4"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1823
  last_active: 2026-11-18
  recoveries_14d: 263
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x3cfD…7a89"
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
  note: "Signer = owner; owner is a very active EOA."
---

## Summary

Candide paymaster v0.9 (EntryPoint v0.8/0.9) checks the paymaster signature against owner(). If the owner gets code, sponsorship validation fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- source CandidePaymaster09V4.sol:123: owner() != _hash.recover(paymasterSignature) → reject
- the signer is owner(); OZ Ownable transferOwnership onlyOwner
- owner at block 26438999 = 0x3cfDc212…7a89, EOA nonce 55857

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,823 transactions called it in the 90 days before that block; last on 2026-11-18.
- 263 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls transferOwnership to a fresh EOA before giving its account code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
