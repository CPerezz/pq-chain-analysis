---
id: nefariousnarwhals-a578e04d-signer-upgrade-only
title: "NefariousNarwhals: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa578e04d4c0937a834ed790c0a23b8d9f7b2cc25"
  family: "69b88ee9bae0f594a1ed7d3084f7878e, 5bbc9e003feced11faa980b608a38fef"
  copies: 48
  name: "NefariousNarwhals"
  label: "deployed by Vision of Unity: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 106
  last_active: 2026-11-12
fix:
  layer: contract-upgrade
  who_acts: "0xcB62c87A… (caller) with signer 0x1BAAd9BF…"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live upgrade by the same parties fixes it; nothing is locked by this check"
---

## Summary

The NFT proxy's upgradeTo needs both the constant caller 0xcB62… and an ecrecover signature from the constant 0x1BAA…. Only upgrades are affected. Both keys are EOAs today and can upgrade now to an implementation that manages the slot itself.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: NFT proxy upgradeTo: the caller and the signer are two addresses written in the code. Read from source.
- upgradeTo: require(msg.sender==0xcB62c87A…) and ecrecover(...)==0x1BAAd9BF… (dossier source Saudibirds.sol)
- 0x1BAAd9BF… and 0xcB62c87A… are EOAs (latest block ~26452920)
- The implementation slot holds 0x7bbd504b… (node, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $3,970 (ETH and 49 priced tokens, over 48 addresses).
- Activity: 106 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

Upgrade once, before 0x1BAA… migrates, to an implementation with its own upgrade authority

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
