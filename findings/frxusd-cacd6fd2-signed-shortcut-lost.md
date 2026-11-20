---
id: frxusd-cacd6fd2-signed-shortcut-lost
title: "FrxUSD: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcacd6fd266af91b8aed52accc382b4e165586e29"
  family: "62ee07f85a5f1e7ffb0dbe2b64b7a36e"
  copies: 2
  name: "FrxUSD"
  label: "Frax Finance: frxUSD Token"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 74227
  last_active: 2026-11-18
  recoveries_14d: 100
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
  note: "the claimed lost path accepts ERC-1271 for a signer with code → refuted per the rubric (a signer whose code does not implement ERC-1271 still fails, but it keeps approve/transfer)."
---

## Summary

FrxUSD: the signed path named in the row checks ERC-1271 for a signer with code, so EIP-8151 does not take it away.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / SignatureChecker.isValidSignatureNow on the signer named: ECDSA, else its ERC-1271. Read from source. Executed: a real transaction reverts with code at the signer.
- permit(v,r,s) with an owner whose code returns the ERC-1271 magic value (state override, block 26438999) succeeds (returns 0x)
- FrxUSD3.permit → PermitModule → SignatureModule uses OZ 5.3 SignatureChecker.isValidSignatureNow: a signer with code is asked through ERC-1271 (dossier source).
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 74,227 transactions called it in the 90 days before that block; last on 2026-11-18.
- 100 signature recoveries in the study's two-week trace window.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
