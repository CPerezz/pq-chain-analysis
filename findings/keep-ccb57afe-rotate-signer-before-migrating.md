---
id: keep-ccb57afe-rotate-signer-before-migrating
title: "Keep: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xccb57afedecc8d975ca4ae06f850a175142499de"
  family: "d7ed1420c6549a7f3dc68e23d46b01ac"
  copies: 21
  name: "Keep"
  upgradeable: "no"
  rating: NONE
  value_usd: 26527
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-10
  recoveries_14d: 1
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
  note: "Signer with code is handled via the ERC-1271 fallback."
---

## Summary

Kali/Keep multisig clone: signatures are checked by an assembly ECDSA then, on mismatch, ERC-1271 isValidSignature on the named signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: assembly: ECDSA against the signer named, else the signer's ERC-1271 (text cut; by its shape) / the account named must sign: ECDSA, else its ERC-1271 (SignatureChecker) / a quorum of holders of the…. Read from source.
- Keep.sol ~155-215: ecrecover result compared with signer; if no match, falls back to staticcall isValidSignature(bytes32,bytes) on signer
- Only one recovery site in Keep.sol (line 180)

## Impact and exposure

- Value held at block 26,438,999: $26,527 (ETH and 49 priced tokens, over 21 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-10.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

None needed for signers whose code answers ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
