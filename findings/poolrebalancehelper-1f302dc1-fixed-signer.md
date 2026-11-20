---
id: poolrebalancehelper-1f302dc1-fixed-signer
title: "PoolRebalanceHelper: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1f302dc12a721f6a1d5b624079c2c4a607b4120f"
  family: "2e61a0b68fb95bbc9a5fdb5764912d8d"
  copies: 3
  name: "PoolRebalanceHelper"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "ApeX operator"
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
  note: "Operator's own pool liquidity; the USDC exit stays open: MEDIUM."
---

## Summary

ApeX PoolRebalanceHelper (the row's 'zkLink' label is wrong): withdrawETH and withdrawErc20 need 2 of 3 constructor-fixed signers, and no setter exists. USDC still leaves through the public deposit() to the operator's own L2 pool account. Only the operator's rebalance liquidity is at stake.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: zkLink fast pool withdrawETH: every signature must come from the signer it names, an allowed signer; two distinct ones are needed; no function changes the signers / zkLink fast pool withdrawErc20: as…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: signers set only in the constructor; isAllowedSigner loops over them
- signers(0..2) = 0x2A2A…1964, 0x2f10…3bD5, 0x18FC…0eF4, all with no code (latest, block ~26453066; storage with no setter)
- deposit() is public and forwards the whole USDC balance to StarkEx L2POOL_STARK_KEY
- USDC balance 0 (latest, block ~26453066)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new helper.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
