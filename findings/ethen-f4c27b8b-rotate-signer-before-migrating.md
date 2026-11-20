---
id: ethen-f4c27b8b-rotate-signer-before-migrating
title: "Ethen: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d"
  family: "778c4d91dfa2cc561e516cbb975c743b"
  name: "Ethen"
  upgradeable: "no"
  rating: LOW
  value_usd: 78318
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9
  last_active: 2026-10-29
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x8a1f…4a9b"
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
  note: "Owner-gated setter, active owner EOA."
---

## Summary

Ethen exchange: setCoeff and trades need an ecrecover signature from the stored `signer`. If that signer takes code, signed trades and coefficient updates revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Ethen setCoeff: signed by `signer`, the platform's stored address / Ethen trade: signed by `signer` / Ethen order: the trader named must have signed. Read from source.
- Ethen.sol:270 setSigner(address) is onlyOwner (msg.sender == owner)
- owner 0x8a1ff1f8…4a9b is an EOA with nonce 58; signer 0xf2c24291…484e is an EOA with nonce 0
- withdrawEther/withdrawToken (Ethen.sol:365,379) use msg.sender balances only, so user funds stay withdrawable

## Impact and exposure

- Value held at block 26,438,999: $78,318 (ETH and 49 priced tokens).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

Owner calls setSigner with a fresh EOA key before the signer migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
