---
id: accountimplementation-21f54036-signer-upgrade-only
title: "AccountImplementation: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x21f540367421aa58e98e8ec49a13a0ae77cd3df7"
  family: "2177489dcedd9d3dac731796e8fb4dae"
  copies: 480
  name: "AccountImplementation"
  upgradeable: "no"
  rating: NONE
  value_usd: 1531
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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

Solady ERC6551 account clone (AccountImplementation); its signer is owner() = the NFT holder, which changes on transfer, and execute is a direct owner call: the signer is checked with SignatureChecker or Solady SignatureCheckerLib, which falls back to that same signer's ERC-1271 once it has code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Solady ERC1271 account: SignatureCheckerLib on the account's signer / Solady ERC1271 nested EIP-712: SignatureCheckerLib on the account's signer / Solady ERC1271 RPC path: SignatureCheckerLib on the…. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address. 1 with an upgrade function whose caller was not read.
- The signature check goes through SignatureChecker(Lib).isValidSignatureNow(signer, …), with an ERC-1271 fallback on the signer (dossier source)

## Impact and exposure

- Value held at block 26,438,999: $1,531 (ETH and 49 priced tokens, over 480 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
