---
id: a99eaa07-fixed-signer
title: "0xa99eaa07: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa99eaa07147888c737554e91d412cc5a1dcf45f3"
  family: "d99e20137c260e11d23341afc20e4266"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "company (DEFAULT_ADMIN_ROLE holder, EOA)"
evidence:
  level: bytecode
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
  note: "No update path; the signed function dies, but an admin rescue path (reclaimToken/reclaimEther) exists."
---

## Summary

ERC20 token with a Uniswap V3 liquidity helper (deposit/mint/increaseLiquidity) whose signed path compares the recovered address with the constant 0x55d8cbfc…. If that key takes code, the signed path dies; role-gated reclaimToken/reclaimEther still move funds out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Same code idiom as template 496eb5b1, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Not EthBridge: selectors deposit, mint, increaseLiquidity, reclaimEther, reclaimToken, company, manager (=Uniswap V3 NPM), AccessControl; no EIP-1967 slot
- Bytecode: PUSH20 0x55d8cbfc09907914f271d472ea5597a19d792bd2 compared with the OZ recover result (pc 0x1162 in 0xa99e); constant, no setter; cast code 0x (EOA)
- reclaimToken/reclaimEther gated by role 0x879ce0d4…; company() holds DEFAULT_ADMIN_ROLE (hasRole true) and can grant it. Holds 0 ETH and 0 NPM positions at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin sweeps through reclaimToken/reclaimEther and redeploys with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
