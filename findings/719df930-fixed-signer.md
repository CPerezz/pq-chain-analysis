---
id: 719df930-fixed-signer
title: "0x719df930: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x719df930aec4fe1202e1356720c74f3a830c726b"
  family: "e031608b35f7be3af2b1756dfd13de87"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Clipper (deploys a new pool); LPs exit themselves"
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
  note: "No update path; the signed functions die, but LP funds leave through burnToWithdraw."
---

## Summary

Clipper Caravel pool: swaps, deposits and withdrawSingleAsset need a signature from the immutable DESIGNATED_SIGNER. If it takes code, trading and deposits stop; LPs still exit pro rata through burnToWithdraw.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call / Clipper: every swap and deposit must carry a signature of DESIGNATED_SIGNER, fixed in the code;…. Same code idiom as template 5ed8caae, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors match ClipperCommonExchange (DESIGNATED_SIGNER, swap, deposit, burnToWithdraw, unlockDeposit, permit); no EIP-1967 slot
- DESIGNATED_SIGNER is immutable (ClipperCommonExchange.sol:36, ecrecover == DESIGNATED_SIGNER at :351-353), value in code 0x282d5b17c1c81ab734e9691e2926deab8c002dc0, cast code 0x (EOA)
- burnToWithdraw(amount) (no signature) pays the LP's pro-rata share of every asset; unlockDeposit releases vested pool tokens without a signature

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Clipper deploys a new pool with a rotatable signer; LPs exit through burnToWithdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
