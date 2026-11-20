---
id: vvvvctokendistributor-fae502ab-fixed-signer
title: "VVVVCTokenDistributor: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfae502ab8fa48189e6037b9b20b810a54d8cec76"
  family: "29d17b29983ada355a20838ac208fcbe"
  name: "VVVVCTokenDistributor"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 373
  last_active: 2026-11-17
  recoveries_14d: 14
fix:
  layer: new-deployment
  who_acts: "VVV operator"
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
  note: "Claim stock is the operator's and sits in its own wallets, so nothing is locked: MEDIUM."
---

## Summary

VVVVCTokenDistributor claims need a signature by `signer`, which only the constructor sets (no setter). Tokens are pulled from operator proxy wallets by transferFrom, so claims die but the tokens stay in operator EOAs.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: VVV token distributor: claims must be signed by `signer`, set in the constructor, with no setter. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: `signer = _signer` only in the constructor; only setClaimIsPaused is admin; _isSignatureValid compares to signer
- signer() = 0x3ac623f6…, which has no code
- trace 0x1aebd50b…: transferFrom from proxy wallet 0x8dd5e983… (an EOA, still holding 238958094686 NIL)
- distributor holds 0 ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 373 transactions called it in the 90 days before that block; last on 2026-11-17.
- 14 signature recoveries in the study's two-week trace window.

## Remediation

Operator deploys a new distributor with a fresh signer and re-approves it from the proxy wallets.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
