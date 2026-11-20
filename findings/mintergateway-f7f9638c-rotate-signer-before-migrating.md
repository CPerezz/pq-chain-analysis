---
id: mintergateway-f7f9638c-rotate-signer-before-migrating
title: "MinterGateway: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xf7f9638cb444d65e5a40bf5ff98ebe4ff319f04e"
  family: "1a178b24190d5ad4dbaec0297757021c"
  name: "MinterGateway"
  label: "deployed by M0: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 9198
  last_active: 2026-11-18
  recoveries_14d: 316
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
  note: "ERC-1271 fallback for the same signer, so the claim does not hold."
---

## Summary

M0 MinterGateway: collateral updates need validator signatures. The check is SignatureChecker.isValidSignature = ECDSA OR ERC-1271, so a validator with code can still sign through ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ECDSA first; if it fails the signer's ERC-1271 is asked / returns the recovered signer to its caller / permit: the owner named in the call must equal the recovered address; the holder can call…. Read from source. Executed: a real transaction reverts with code at the signer.
- MinterGateway.sol:1167 SignatureChecker.isValidSignature(validator_, digest, signature_)
- lib/common/src/libs/SignatureChecker.sol:44-45: isValidECDSASignature
- isValidERC1271Signature (staticcall to the signer)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 9,198 transactions called it in the 90 days before that block; last on 2026-11-18.
- 316 signature recoveries in the study's two-week trace window.

## Remediation

none needed; a validator that takes code implements ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
