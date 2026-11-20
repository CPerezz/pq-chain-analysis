---
id: thresholdcustody-3a9624f9-rotate-signer-before-migrating
title: "ThresholdCustody: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x3a9624f9bb2dc43e90c0699ddc4a9b6bec147cde"
  family: "75ed4c5c8aa07e0ccd0228b6626afce9"
  copies: 2
  name: "ThresholdCustody"
  upgradeable: "no"
  rating: NONE
  value_usd: 152846
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2322
  last_active: 2026-11-17
  recoveries_14d: 4
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "signer with code handled via ERC-1271"
---

## Summary

ThresholdCustody quorum ops use OZ MultiSignerERC7913 → SignatureChecker; withdrawals are approved by msg.sender.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: signers with a threshold, added and removed by functions. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- _verifyQuorumOp → _rawSignatureValidation → SignatureChecker.isValidSignatureNow (code.length check, ERC-1271 for contracts)
- startWithdraw/finalizeWithdraw onlySigner by msg.sender, no ecrecover

## Impact and exposure

- Value held at block 26,438,999: $152,846 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,322 transactions called it in the 90 days before that block; last on 2026-11-17.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

none needed; a signer with code must answer ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
