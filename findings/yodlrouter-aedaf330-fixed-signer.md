---
id: yodlrouter-aedaf330-fixed-signer
title: "YodlRouter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaedaf330ae63926937588e728d9a6c80f033fc77"
  family: "9f17bdcacbb4bebfd9e3876a8c0699be"
  copies: 3
  name: "YodlRouter"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no deposits at risk"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No deposits held, only one payment-pricing path dies -> MEDIUM."
---

## Summary

AbstractYodlRouter.verifyRateSignature checks the constant RATE_VERIFIER, no setter. Gates only one leg of inline price conversion during a same-transaction swap+pay; sweep/transferFee/withdraw exist independently for owner-collected fees. No escrowed funds depend on this check.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: YodlRouter: payments priced by a rate signed by RATE_VERIFIER, fixed in the code; the router holds no deposits, so only rate-signed payments stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AbstractYodlRouter.sol:18,245,253: RATE_VERIFIER constant, ECDSA.recover==RATE_VERIFIER, no setter (dossier source)
- AbstractYodlRouter.sol: verifyRateSignature used only inside inline price conversion for EXTERNAL_FEED currency pairs, not escrow release
- identical mechanism and constant as the d89f1538 copy of this same router

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a router with a fresh RATE_VERIFIER.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
