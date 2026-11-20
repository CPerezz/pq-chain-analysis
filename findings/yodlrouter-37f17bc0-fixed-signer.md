---
id: yodlrouter-37f17bc0-fixed-signer
title: "YodlRouter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x37f17bc0e317aaaf663908ddbbca296e2119eb2b"
  family: "bd4ebd69fe9555fef8d77b4e1beb6039"
  name: "YodlRouter"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Yodl (deploy a new router)"
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
  note: "A function of a router dies for good with nothing locked (sweep is public): MEDIUM."
---

## Summary

YodlRouter: verifyRateSignature compares the recovered address with the constant RATE_VERIFIER 0xc71f…3bB7. If that key took code, payments that use an EXTERNAL_FEED rate would revert. Chainlink-feed and plain payments would still work. The router holds no user funds, and sweep() is public.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: YodlRouter verifyRateSignature: RATE_VERIFIER, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source AbstractYodlRouter: RATE_VERIFIER is a constant; exchangeRate reverts 'Invalid signature for external price feed'
- RATE_VERIFIER has no code (cast code, latest, block ~26453066)
- state.json at block 26438999: balance 0, no proxy slots

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a router with a settable verifier.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
