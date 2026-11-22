---
id: commitstore-d37a60e8-rotate-signer-before-migrating
title: "CommitStore: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd37a60e8c36e802d2e1a6321832ee85556beeb76"
  family: "4a59acacc998c6e94e0a94092af51056"
  copies: 13
  name: "CommitStore"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1668
  last_active: 2026-11-18
  recoveries_14d: 1386
fix:
  layer: onchain-config
  who_acts: "owner timelock (Chainlink RBACTimelock)"
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
  note: "Owner-only config setter exists; the owner is a working timelock."
---

## Summary

Chainlink CCIP CommitStore: an OCR2 report needs f+1 distinct signatures from configured signers; signers holding code would stop counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (approver, oracle, attester or author) and distinct; enough of them are needed. Read from source. Executed: a real transaction reverts with code at the signer.
- source CommitStore.sol: setOCR2Config(signers, transmitters, f, …) is onlyOwner and rewrites s_signers/s_oracles, which transmit() checks against ecrecover
- owner 0x44835bBBA9D40DEDa9b64858095EcFB2693c9449 is a timelock contract with 10800 s delay (probe)
- no ERC-1271 path: transmit uses raw ecrecover

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 13 addresses).
- Activity: 1,668 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,386 signature recoveries in the study's two-week trace window.

## Remediation

Owner timelock schedules setOCR2Config with plain-key signers (3 h delay) before signers take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
