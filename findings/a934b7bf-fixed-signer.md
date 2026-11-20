---
id: a934b7bf-fixed-signer
title: "0xa934b7bf: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa934b7bf2657ac76af2449f9eea15d6ab40031c4"
  family: "ba8aaf7aed833ca1e57a9af7c902b5c4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner (0x7f7018d7e39168704bc427b43335e35fb2d62765) takes the stock out with withdraw() and redeploys with a new signer"
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
  verdict: confirmed
  rating: MEDIUM
  note: "The study_note calls this a presale with deposit and claim, but the source has only claim(). There is no deposit function and no user funds are held."
---

## Summary

The claim signer is immutable and cannot be replaced. Its address is an EOA today. If that key's account gets code, claims stop working. Nothing gets locked, because the owner can still take out the operator-funded tokens with withdraw() after the deadline.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cSigner is declared immutable as 0x06B417d938c3e8eD3e82c1f378A5578110097261
- claim() requires ecrecover(...) == cSigner
- No function writes to cSigner, and there is no proxy or upgrade path
- 0x06b417...7261 has no code at block 26438999 (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls withdraw() and redeploys with a signer that can be rotated, or one that supports ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
