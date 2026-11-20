---
id: yodlrouter-1f7c4f45-fixed-signer
title: "YodlRouter: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1f7c4f45c8a398381616c74269f9fb8060e3ddc9"
  family: "f2fa03bc01defeded04ae77f20c2f67d"
  name: "YodlRouter"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 83
  value_basis: held
  value_as_of: 2026-11-18
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The signed-rate conversion has no substitute, but nothing is locked, so MEDIUM. One could argue LOW, since payment itself stays open without a feed."
---

## Summary

RATE_VERIFIER is a constant, and verifyRateSignature compares ECDSA.recover to it. Once it has code, payments priced by an EXTERNAL_FEED rate revert. Chainlink-feed and no-feed payments continue, and the router holds only fees, which anyone can sweep to the treasury.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: YodlRouter: payments priced by a rate signed by RATE_VERIFIER, fixed in the code; the router holds no deposits, so only rate-signed payments stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AbstractYodlRouter.sol: `address public constant RATE_VERIFIER = 0xc71f…3bB7`, which has no code; it is checked only in exchangeRate when feedType == EXTERNAL_FEED.
- sweep(token) has no access control and sends the router's balance to yodlFeeTreasury.
- No proxy and no setter for RATE_VERIFIER.

## Impact and exposure

- Value held at block 26,438,999: $83 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new router with a new verifier; meanwhile pay through Chainlink or without a feed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
