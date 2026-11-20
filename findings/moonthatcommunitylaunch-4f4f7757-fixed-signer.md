---
id: moonthatcommunitylaunch-4f4f7757-fixed-signer
title: "MoonThatCommunityLaunch: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x4f4f77572b5437bd00f8abda28274e4a1171ae0f"
  family: "dac33087418f9feb228d032ec88f0c58"
  copies: 3
  name: "MoonThatCommunityLaunch"
  upgradeable: "no"
  rating: NONE
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
  note: "The code accepts ERC-1271 for that signer."
---

## Summary

MoonThatCommunityLaunch checks the oracle signature with OpenZeppelin SignatureChecker.isValidSignatureNow. If the oracle address has code, the check falls back to ERC-1271 on it.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ImmutableOracleSigned _isValidSignature: SignatureChecker on the oracle signer fixed at deployment. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- source lib/ImmutableOracleSigned.sol line 77: SignatureChecker.isValidSignatureNow(_ORACLE, …)
- _ORACLE is immutable

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
