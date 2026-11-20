---
id: mintergateway-f7f9638c-signed-shortcut-lost
title: "MinterGateway: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
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
  who_acts: "validator (implement isValidSignature)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Signer with code is handled via ERC-1271 fallback; the permit named in the note is not exposed here."
---

## Summary

M^0 MinterGateway: validator signatures on updateCollateral are checked with SignatureChecker.isValidSignature (ECDSA, else ERC-1271).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: ECDSA first; if it fails the signer's ERC-1271 is asked / returns the recovered signer to its caller / permit: the owner named in the call must equal the recovered address; the holder can call…. Read from source. Executed: a real transaction reverts with code at the signer.
- MinterGateway.sol:1167 uses SignatureChecker.isValidSignature
- lib/common/src/libs/SignatureChecker.sol:44 returns isValidECDSASignature
- isValidERC1271Signature
- bytecode has no approve/transfer/permit selectors: no permit lives at this address

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 9,198 transactions called it in the 90 days before that block; last on 2026-11-18.
- 316 signature recoveries in the study's two-week trace window.

## Remediation

A validator with code answers via ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
