---
id: zklink-bdc4dd4d-fixed-signer
title: "ZklinkFastPool: signer fixed in code"
project: zklink
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbdc4dd4d467e55fa5276925b2f136e75df3f86f1"
  family: "fc2a6174f361ce4f000b2b12661aafdc"
  name: "ZklinkFastPool"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1423325
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 482
  last_active: 2026-11-18
  recoveries_14d: 110
fix:
  layer: new-deployment
  who_acts: "zkLink keeps the signing keys without code, or redeploys the pool"
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
  note: "operator's own liquidity; fast withdrawals stop if two signers take code"
---

## Summary

`ZklinkFastPool` at `0xbdc4dd4d467e55fa5276925b2f136e75df3f86f1`. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: zkLink fast pool withdrawETH: every signature must come from the signer it names, an allowed signer; two distinct ones are needed; no function changes the signers / zkLink fast pool withdrawErc20: as…. Read from source. Rated by hand: read: 2 of 3 fixed signers move the operator's own liquidity.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: withdrawETH, withdrawErc20, fastTransferETH and fastTransferErc20 need two distinct signatures from a fixed set of three signers; no function changes them.
- The pool's ETH and tokens are zkLink's own fast-withdrawal liquidity (claimFromZklink refills it).
- No proxy, no upgrade. 482 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens).
- Activity: 482 transactions called it in the 90 days before that block; last on 2026-11-18.
- 110 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
