---
id: c2cb7bce-fixed-signer
title: "0xc2cb7bce: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc2cb7bce682af8ad9e1e1c1dec183a0902456482"
  family: "4cef3f5ee3d0a86902054dbbf07fbe54"
  copies: 6
  upgradeable: "no"
  rating: HIGH
  txs_90d: 28
  last_active: 2026-11-04
  recoveries_14d: 28
fix:
  layer: account-migration
  who_acts: "account owner"
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
  rating: HIGH
  note: "A wallet whose fixed owner key is the only way to move its funds; moving out before the key migrates is a migration step, not a way out: HIGH, as for the other fixed-owner wallets."
---

## Summary

Minimal ERC-4337 account: validateUserOp accepts only an ecrecover equal to the constant 0xb451d93e…, and execute (0xb61d27f6) accepts calls only from EntryPoint v0.8. If that key takes real code, nothing can move the account's assets, including its 0.0016 ETH EntryPoint deposit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: six accounts whose owner key is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompile: ecrecover(...) == 0xb451d93eb2d08c08cf75fc7add154d2e4347d78d is a code constant; execute requires msg.sender==0x4337084d…f108 ('nauth').
- Owner key 0xb451d93e… is an EOA with no code; the account has 0 ETH, but EntryPoint v0.8 balanceOf(account)=1.593e15 wei.
- No setter, proxy or upgrade; the account has 5 functions (heimdall). Family: 6 identical accounts.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 28 transactions called it in the 90 days before that block; last on 2026-11-04.
- 28 signature recoveries in the study's two-week trace window.

## Remediation

The owner moves everything out before the key's account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
