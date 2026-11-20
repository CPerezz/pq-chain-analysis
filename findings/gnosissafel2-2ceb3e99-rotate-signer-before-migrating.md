---
id: gnosissafel2-2ceb3e99-rotate-signer-before-migrating
title: "GnosisSafeL2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2ceb3e994a516c6ba8658211bc94d4c280486cb7"
  family: "922d81504c51927118b2dda3d8ce64ee"
  copies: 8589
  name: "GnosisSafeL2"
  label: "created by Safe: Proxy Factory 1.3.0 Default"
  upgradeable: "yes"
  rating: LOW
  value_usd: 226208453
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 17784
  last_active: 2026-11-18
  recoveries_14d: 1630
fix:
  layer: onchain-config
  who_acts: "Safe owners"
evidence:
  level: executed
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
  note: "Owner rotation and other confirmation paths are open to the key holders: LOW. The Safe's v=0 path is ERC-1271 for the same owner but needs a different signature format, so I kept LOW rather than refuted."
---

## Summary

Safe 1.3.0 L2. An owner whose address takes code loses the ECDSA signature form.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Safe 1.3.0 checkNSignatures: the same four branches; read in full for the registry entry. Read from source. Executed: a real transaction reverts with code at the signer.
- reading 922d8150: an owner keeps approveHash, the msg.sender form and the v=0 contract-signature form
- swapOwner/addOwnerWithThreshold are callable by the Safe itself with threshold confirmations (standard Safe OwnerManager)

## Impact and exposure

- Value held at block 26,438,999: $226.2M (ETH and 49 priced tokens, over 8,589 addresses).
- Activity: 17,784 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,630 signature recoveries in the study's two-week trace window.

## Remediation

The owners swap the key before it takes code, or confirm through approveHash or v=0.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
