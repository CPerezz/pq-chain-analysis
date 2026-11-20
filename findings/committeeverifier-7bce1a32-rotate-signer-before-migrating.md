---
id: committeeverifier-7bce1a32-rotate-signer-before-migrating
title: "CommitteeVerifier: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7bce1a3297604cafa601f05799b6ed98e8c01b7f"
  family: "1e15fd25d1529c503d4b28a595cf5d15"
  name: "CommitteeVerifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 33914
  last_active: 2026-11-18
  recoveries_14d: 36486
fix:
  layer: onchain-config
  who_acts: "owner timelock 0x4483…9449 (proposer ManyChainMultiSig 0xe532…012f)"
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
  note: "setter held by a working timelock."
---

## Summary

Chainlink CCIP CommitteeVerifier: messages need a quorum of distinct committee signers; a signer with code loses its vote.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (oracle, committee member, validator) and distinct; a quorum is needed. Read from source. Executed: a real transaction loses its effect with code at the signer.
- SignatureQuorumValidator.sol:131 applySignatureConfigs(...) onlyOwner replaces signer sets
- owner() = 0x44835bbb…, RBAC timelock (getMinDelay 10800, self-admin); PROPOSER member 0xe53289f3… (39.8 kB multisig contract)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 33,914 transactions called it in the 90 days before that block; last on 2026-11-18.
- 36,486 signature recoveries in the study's two-week trace window.

## Remediation

Governance queues applySignatureConfigs with new keys (3h delay).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
