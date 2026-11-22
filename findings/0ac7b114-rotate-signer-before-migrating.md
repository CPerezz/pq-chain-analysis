---
id: 0ac7b114-rotate-signer-before-migrating
title: "0x0ac7b114: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0ac7b11449e3ffc2137dccb8371ebcee275e3aaf"
  family: "09a76b0a8fefa43f487484c5530ec58c"
  copies: 3
  upgradeable: "no"
  rating: LOW
  value_usd: 9745
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0x9309Cd18…7DEF (EOA)"
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
  note: "Owner-only setter with a live EOA owner."
---

## Summary

Unverified wallet-like contract (has isValidSignature) whose manager signature is checked by ecrecover. A manager with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (assignManager, setAllowManagerSignature). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall: assignManager(address) and setAllowManagerSignature(bool) (0x887268de) both require msg.sender == owner (Ownable)
- owner() = 0x9309Cd182b375B60807477e73316f1798eE57DEF, no code, nonce 124 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $9,745 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner reassigns the manager to a key without code, or disables manager signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
