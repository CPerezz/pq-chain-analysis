---
id: voxelxminer-ba0de108-rotate-signer-before-migrating
title: "voxelXMiner: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xba0de1085f6ecbc037b6b5d24ab76d2cff9d0a24"
  family: "d8e0ddf3111432d21af91188a4b1bde5"
  copies: 12
  name: "voxelXMiner"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2363
  last_active: 2026-11-18
  recoveries_14d: 742
fix:
  layer: onchain-config
  who_acts: "owner 0x623CD15FAdB5Fa1D44f4d0C6906ff4D44C1568D1"
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
  note: "A live owner can call the setter, so a config call fixes it: LOW."
---

## Summary

voxelXMiner checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setter updateSigner(address) onlyOwner in verified source (d8e0ddf3111432d21af91188a4b1bde5/source)
- owner() at block 26438999 = 0x623CD15FAdB5Fa1D44f4d0C6906ff4D44C1568D1 EOA nonce=4
- txs_90d=2363, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 2,363 transactions called it in the 90 days before that block; last on 2026-11-18.
- 742 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
