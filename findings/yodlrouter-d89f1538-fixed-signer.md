---
id: yodlrouter-d89f1538-fixed-signer
title: "YodlRouter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd89f15383385a492a86005af4accd9486312a3f3"
  family: "0facc70502532f2033cc3182728193c1"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Downgraded from the study's HIGH to match the identical mechanism's own MEDIUM reasoning at the aedaf330 copy: no deposits are held, only one payment-pricing path dies."
---

## Summary

AbstractYodlRouter.verifyRateSignature checks a constant RATE_VERIFIER, no setter. It only gates conversion for currency pairs priced by an EXTERNAL_FEED (one specific leg of a same-transaction swap+pay); it is never used to hold or release escrowed funds -- sweep/transferFee/withdraw exist independently for owner-collected fees. If RATE_VERIFIER gets code, only that external-feed payment path stops; other currency pairs (Chainlink-priced) keep working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: YodlRouter verifyRateSignature: RATE_VERIFIER, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AbstractYodlRouter.sol:18,245,253: RATE_VERIFIER constant 0xc71f6e1e4665d319610afA526BE529202cA13bB7, ECDSA.recover==RATE_VERIFIER, no setter (dossier source)
- AbstractYodlRouter.sol:125-140: verifyRateSignature used only inside one branch of inline price conversion during yodlWithUniswap/yodlWithCurve/yodlWithToken, not for escrow release
- identical mechanism and constant as the aedaf330... copy of this same router, which the study itself rated MEDIUM ('the router holds no deposits')

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a router with a fresh RATE_VERIFIER.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
