---
id: tokenrewardv2-d4517dbe-rotate-signer-before-migrating
title: "TokenRewardV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd4517dbeef443cf3d1d760abdd4268f12940c6f8"
  family: "51b86c9903e4a7e86f2707c2533abe12"
  copies: 3
  name: "TokenRewardV2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4569
  last_active: 2026-11-10
fix:
  layer: onchain-config
  who_acts: "owner 0x5529c777…efAF4 (EOA)"
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
  note: "Owner setter (plus upgrade), live EOA."
---

## Summary

TokenRewardV2 claims/withdraws verified with ECDSA.recover == signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- TokenRewardV2: setSigner(address) onlyOwner (line 157); check at 648 ECDSA.recover(hash, sig) == signer
- owner() = 0x5529c777Be16e545E03d5b11b77B799f102efAF4, no code, nonce 4; UUPS impl 0xe6cb4bca… (also upgradeable)

## Impact and exposure

- Value held at block 26,438,999: $3,068 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 4,569 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

The owner calls setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
