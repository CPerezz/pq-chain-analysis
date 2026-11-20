---
id: moonthatcommunitylaunch-1ddba721-fixed-signer
title: "MoonThatCommunityLaunch: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1ddba7212127e4bea8bab4a0998ab984b9cf74af"
  family: "745c4ddc44eec92cdd70cc0a226747d8"
  copies: 17
  name: "MoonThatCommunityLaunch"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Code accepts ERC-1271 for the signer, so refuted per the scale."
---

## Summary

MoonThatCommunityLaunch clone (EIP-1167, 45 bytes, delegating to the fixed 0x7ec34205…): the oracle check uses OpenZeppelin SignatureChecker.isValidSignatureNow, which falls back to ERC-1271 isValidSignature on the oracle when ecrecover fails. A migrated oracle account that implements ERC-1271 keeps signing.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ImmutableOracleSigned _isValidSignature: SignatureChecker on the oracle signer fixed at deployment. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- proxy code 0x363d3d373d3d3d363d737ec342…5af43d82803e903d91602b57fd5bf3 (minimal clone, no upgrade)
- source ImmutableOracleSigned._isValidSignature -> SignatureChecker.isValidSignatureNow (ECDSA.tryRecover
- isValidERC1271SignatureNow)
- 0x7ec342… bytecode matches the dossier code except 2 immutable spots; it has a STATICCALL built with selector 0x0b135d3f<<1 = 0x1626ba7e (isValidSignature) next to the ecrecover STATICCALL
- oracle() = 0xDfe71f2e… (no code, nonce 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 17 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed: the oracle's new account must implement ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
