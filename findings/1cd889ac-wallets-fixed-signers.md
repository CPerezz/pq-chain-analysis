---
id: 1cd889ac-wallets-fixed-signers
title: "0x1cd889ac: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1cd889acb44bb4514f7e0c89394152631820b7d0"
  family: "a8defa7394eeb12fc03832cc3bc406aa"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "wrong template match; the genuine mechanism is not fully characterized because the RPC was unavailable, but the specific SimpleMultiSig-wallet/HIGH claim is definitely wrong"
---

## Summary

Not a SimpleMultiSig copy -- a token-staking/bonding-curve registry (stake/unstake/register/withdrawReceipts/bondingCurve/token/registry/getStake/getOwnership). Uses one ecrecover call (inside the function at selector resembling report(...)) whose result is only checked non-zero, not matched against a fixed owner array; there is no owners()/execute()/threshold()/getOwners() anywhere in the 502-line decompile.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher: queryPrice/params/stake/unstake/register/withdrawReceipts/bondingCurve/token/registry/getStake/getOwnership/report(...) -- nothing matching template 8f5fee6f
- single ecrecover() call found (decompiled line ~281) whose recovered address is only required != 0, unrelated to a fixed owner/threshold comparison
- on-chain view calls (activeCount/token/bondingCurve/registry/etc.) could not be completed -- reth RPC timed out on every attempt, no values obtained

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
