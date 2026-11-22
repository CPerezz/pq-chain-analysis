---
id: c2a26188-rotate-signer-before-migrating
title: "0xc2a26188 (tagged deployed by Ripple: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc2a26188e4d7521960c2ddd31947afa9b2fdd8ac"
  family: "af3852b157f56e7887d2b5ececc8809c"
  copies: 5
  label: "deployed by Ripple: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 4999714
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9
  last_active: 2026-11-10
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "multisig signers (quorum)"
evidence:
  level: bytecode
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
  note: "The key holders can rotate first: LOW. Dead for good if weight drops below quorum after migration."
---

## Summary

Unverified Ripple-deployed weighted multisig, ECDSA only. Rotation goes through execute with a quorum calling setSigners (0x7460837f).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setSigners). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- reading af3852b1: quorum 2, 32 signers, 0 ETH at the read address; rotation via setSigners by quorum
- family af3852b1: 5 addresses, 0 ETH; an empty recovery result always reverts, no fall-through

## Impact and exposure

- Value held at block 26,438,999: $5.0M (ETH and 49 priced tokens, over 5 addresses).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-11-10.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

The quorum rotates before signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
