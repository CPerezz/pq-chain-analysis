---
id: pendleptlooper-9835a4e1-rotate-signer-before-migrating
title: "PendlePTLooper: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x9835a4e15fd34f8d3217beffaa011fab9b8bea0b"
  family: "1518210329a706bb66515747c1b388ec"
  copies: 4
  name: "PendlePTLooper"
  label: "deployed by Pendle: Deployer 1"
  upgradeable: "no"
  rating: NONE
  txs_90d: 12891
  last_active: 2026-11-18
  recoveries_14d: 700
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "SignatureChecker falls back to ERC-1271, and a direct owner path exists."
---

## Summary

Pendle PTLooper. Owner and checker signatures go through OpenZeppelin SignatureChecker.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract) / the owner calls itself, or its signature is checked by SignatureChecker. Read from source. Executed: a real transaction reverts with code at the signer.
- PTLooperBase.sol:58 SignatureChecker.isValidSignatureNow(checker,…)
- PTLooperBase.sol:137: msg.sender==owner
- SignatureChecker.isValidSignatureNow(owner,…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 12,891 transactions called it in the 90 days before that block; last on 2026-11-18.
- 700 signature recoveries in the study's two-week trace window.

## Remediation

None needed. A signer with code that implements ERC-1271 keeps working, and the owner can call directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
