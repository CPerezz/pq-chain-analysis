---
id: universalexecutor-f9a8679c-7702-own-key-only
title: "UniversalExecutor: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xf9a8679c655516c56014f65810c19969b3e411a1"
  family: "5e353419068213d95725890f716fee21"
  copies: 1023
  name: "UniversalExecutor"
  upgradeable: "no"
  rating: LOW
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1117
  last_active: 2026-11-17
  recoveries_14d: 16
fix:
  layer: account-migration
  who_acts: "the account holder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd 361, txs_90d 1117."
---

## Summary

UniversalExecutor 7702 delegate: executeBatch with the account owner signature, or direct self-call. Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: UniversalExecutor executeBatch: the signature must recover to the account itself / UniversalExecutor.recoverSigner: returns the signer / UniversalExecutor.verifySignature: a view comparing with an…. Read from source.
- Universal.sol:37-43 executeBatch: require(signer == address(this))
- Universal.sol:53/107 direct paths require msg.sender == address(this) (no ecrecover)

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 1,023 addresses).
- Activity: 1,117 transactions called it in the 90 days before that block; last on 2026-11-17.
- 16 signature recoveries in the study's two-week trace window.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
