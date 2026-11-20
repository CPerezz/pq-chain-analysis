---
id: mchdailyactionv4-d7bec4d6-rotate-signer-before-migrating
title: "MCHDailyActionV4: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd7bec4d6bf6fc371eb51611a50540f0b59b5f896"
  family: "7edbc0d091faebd6083f4b05afad6d9e"
  name: "MCHDailyActionV4"
  label: "deployed by MCH: Owner"
  upgradeable: "no"
  rating: LOW
  value_usd: 10466
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "operator 0xe7af11370c3bab51230d8307454350bdf6d68f4a"
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
  note: "The setter is callable by a live operator: LOW."
---

## Summary

MCHDailyActionV4 checks that the recovered signer equals validator. Daily actions die if the validator gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / returns the recovered address, or compares it with an address its caller passes in. Read from source.
- source:341 setValidater(address) onlyOperator; :359-360 signer == validator
- validator()=0x35c5…784d (EOA, nonce 410); isOperator(owner 0xe7af…8f4a)=true; 0xe7af is a 7702-delegated EOA (0xef0100…), nonce 771, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,466 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator calls setValidater with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
