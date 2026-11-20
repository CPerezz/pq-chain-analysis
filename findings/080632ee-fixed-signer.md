---
id: 080632ee-fixed-signer
title: "0x080632ee: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x080632eeb199b94e835fff3348d6bf58d1c0b2ea"
  family: "f0069459b3544d000fe118ef512de650"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 8
  last_active: 2026-10-13
fix:
  layer: onchain-config
  who_acts: "Owner: turn on the public sale with setPublicSaleState, or reserve tokens with reserveMoose."
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
  note: "The study note describes a presale with signed deposit and claim, but this code is an NFT mint with a single signed function, privateMint."
---

## Summary

The admin signer is a hard-coded constant with no setter, and it has no code today. If that key's account gets real code, only the signed private mint stops. Nothing is locked, because payment and mint happen in the same transaction.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private constant admin = 0x719deC08...` is the signer.
- privateMint: `require(signatory == admin)` after `ecrecover(digest,v,r,s)`.
- Row facts: constant 0x719dec08... has code_bytes 0 and is not delegated.
- No function changes admin; the only setter is transferOwnership, which changes the owner.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-10-13.

## Remediation

The owner turns on publicMint (setPublicSaleState) or mints to allowlisted users with reserveMoose. A new deployment is needed only if signed private minting must continue.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
