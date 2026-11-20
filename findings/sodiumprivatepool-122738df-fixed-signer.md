---
id: sodiumprivatepool-122738df-fixed-signer
title: "SodiumPrivatePool: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x122738dff257e2934cd2e15bdf6acad9928fdf86"
  family: "e7ce5ed1b1e532e11600a23f0a23638e"
  copies: 6
  name: "SodiumPrivatePool"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "pool owner 0x5df5…334c"
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
  rating: LOW
  note: "A live owner's setting (setFixedValue) reopens borrowing without the oracle, and the funds are the owner's own liquidity, so LOW. If the reviewer reads a fixed price as a different act, it is MEDIUM."
---

## Summary

The oracle is set in initialize with no setter. Once it has code, oracle-priced borrow fails, but the owner (a live EOA) can setFixedValue per collection, which _getPriceAndVerify uses before any signature. The pool's WETH is the owner's liquidity and withdrawWETH needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SodiumPrivatePool borrow: the oracle (set at initialisation, no setter) signs floor prices; the pool owner withdraws WETH and sets fixed values without it, so only oracle-priced borrowing stops…. Read.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Clone (EIP-1167) of 0x3890…60eb; SodiumPrivatePool.sol: `oracle` is written only in initialize; _verifyMessage ends `return ecrecover(...) == oracle` with no code check.
- _getPriceAndVerify returns fixedFloorPrice[collection] first when it is non-zero; setFixedValue is onlyOwner.
- Owner slot 5 = 0x5df5…334c: no code, nonce 51. Oracle 0xAeB1…75AF has no code. Pool holds 0.1 WETH and 0 ETH.

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner sets fixed collection values with setFixedValue, or withdraws the WETH.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
