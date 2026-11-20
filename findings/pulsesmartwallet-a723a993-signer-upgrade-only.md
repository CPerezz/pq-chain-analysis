---
id: pulsesmartwallet-a723a993-signer-upgrade-only
title: "PulseSmartWallet: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa723a9932d29907f7bc24edc2ed71f6dbeb65712"
  family: "c868b42b3fec1d77370942fc8f02e322"
  name: "PulseSmartWallet"
  upgradeable: "no"
  rating: NONE
  txs_90d: 2
  last_active: 2026-08-20
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
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "accepts ERC-1271 for the expected signer"
---

## Summary

PulseSmartWallet (Coinbase-style) implementation; its constructor fills the owners with address(0): the signer is checked with SignatureChecker or Solady SignatureCheckerLib, which falls back to that same signer's ERC-1271 once it has code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Coinbase Smart Wallet: the owner at the given index is an address checked with Solady SignatureCheckerLib (ecrecover, then the owner's ERC-1271), or a passkey. Read (function text).
- Update path, read at block 26,438,999: upgradeToAndCall(address,bytes), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- The signature check goes through SignatureChecker(Lib).isValidSignatureNow(signer, …), with an ERC-1271 fallback on the signer (dossier source)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-08-20.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
