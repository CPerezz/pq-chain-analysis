---
id: multisign-b60fa2ad-rotate-signer-before-migrating
title: "MultiSign: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb60fa2ad48959c016fb7545d045aeb60086aca2a"
  family: "7d5e2ccb86db47cfc8cdc144cceb7e60"
  copies: 34
  name: "MultiSign"
  label: "deployed by Ripple: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 8104279
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 839
  last_active: 2026-11-17
  recoveries_14d: 272
fix:
  layer: onchain-config
  who_acts: "multisig signers (quorum)"
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
  note: "The key holders can rotate first: LOW. If weight drops below quorum after migration it is dead for good (would be MEDIUM/HIGH). Signer set not read."
---

## Summary

Ripple-deployed weighted MultiSign, ECDSA only. setSigners is reachable only through execute with a quorum of the current signers. Not upgradeable.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (signer, validator, authority, relayer), distinct or ordered; a quorum or weight is needed. Read from source.
- reading 7d5e2ccb keys: rotation only via execute with a quorum calling setSigners
- no ERC-1271 or direct path

## Impact and exposure

- Value held at block 26,438,999: $8.1M (ETH and 49 priced tokens, over 34 addresses).
- Activity: 839 transactions called it in the 90 days before that block; last on 2026-11-17.
- 272 signature recoveries in the study's two-week trace window.

## Remediation

The quorum rotates through setSigners before signer keys take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
