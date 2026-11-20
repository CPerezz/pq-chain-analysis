---
id: yodlrouter-33a57dbf-fixed-signer
title: "YodlRouter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x33a57dbf2a0141073795114a8abd9acc263c069d"
  family: "f0fe5382a3d3bde72c7cc721885ad70b"
  name: "YodlRouter"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator"
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
  note: "No update path. The router holds no deposits, so only the external-rate function dies."
---

## Summary

YodlRouter checks EXTERNAL_FEED rate signatures against the constant RATE_VERIFIER 0xc71f…3bB7. If that key gets code, externally priced payments revert for good. Chainlink-feed and no-feed payments and sweep keep working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: YodlRouter: payments priced by a rate signed by RATE_VERIFIER, fixed in the code; the router holds no deposits, so only rate-signed payments stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AbstractYodlRouter.sol:18 `address public constant RATE_VERIFIER`; line 253 `ECDSA.recover(...) == RATE_VERIFIER`
- line 134: only the EXTERNAL_FEED branch calls verifyRateSignature
- sweep (line 198) sends router balances to yodlFeeTreasury with no signature; cast code 0xc71f… = 0x

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new router.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
