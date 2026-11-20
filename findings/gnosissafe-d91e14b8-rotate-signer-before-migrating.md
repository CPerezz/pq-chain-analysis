---
id: gnosissafe-d91e14b8-rotate-signer-before-migrating
title: "GnosisSafe: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd91e14b8124bcb8986d35048b41ebb7172d4f4fe"
  family: "59287f6753f4e22ed944d99bababc01c"
  copies: 512
  name: "GnosisSafe"
  label: "deployed by DutchX: Deployer"
  upgradeable: "yes"
  rating: NONE
  value_usd: 128665
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-11
  recoveries_14d: 1
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
  note: "owner with code signs via contract signature; handled"
---

## Summary

Old GnosisSafe checkSignatures supports contract signatures (v=0 → owner isValidSignature).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: old Safe SignatureDecoder.recoverKey: returns the recovered address / Safe checkSignatures: owners in ascending order, by ECDSA, by an approved hash or by a contract signature; owners are added and…. Read from source. Executed: a real transaction reverts with code at the signer.
- GnosisSafe.sol:685 ISignatureValidator(currentOwner).isValidSignature for v==0; also approved-hash path

## Impact and exposure

- Value held at block 26,438,999: $128,665 (ETH and 49 priced tokens, over 512 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-11.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

none needed; a signer with code must answer ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
