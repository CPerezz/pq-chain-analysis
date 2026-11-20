---
id: 0a34b25d-7702-own-key-only
title: "0x0a34b25d: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x0a34b25d1c07b2bddc8638f347f637aadfefc1c5"
  family: "26dc8ae815b5d5008a2f1c49e938b3bb"
  copies: 4
  upgradeable: "no"
  rating: LOW
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3104
  last_active: 2026-11-18
  recoveries_14d: 2075
fix:
  layer: account-migration
  who_acts: "the account holder"
evidence:
  level: bytecode
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
  note: "Own-key-only check confirmed; the fix is for the account to keep or re-delegate its 7702 delegation (LOW). value_usd 541, txs_90d 3104."
---

## Summary

KeeperDelegate 7702 delegate (no verified source): anyone submits a batch the account signed (EIP-712, nonce, deadline). Under EIP-8151 the self-signature fails only if the account holds real code; as a 7702 delegate it keeps working.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself; executed: with this…. Rule: self-only. Executed: a real transaction reverts once the account holds this logic as real code.
- dossier reading.first.json: selector 0xbe119a10 recovers the signer and requires the account itself
- 0x0a34... holds 0xef0100 indicator to 0x3ddc...bc8e (state.json)
- row note: executed, a real tx reverts once the account holds this logic as real code

## Impact and exposure

- Value held at block 26,438,999: $541 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 3,104 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,075 signature recoveries in the study's two-week trace window.

## Remediation

Under EIP-8151 a 7702-delegated account still passes; an account that installs real code must keep or re-delegate to a 7702 indicator (or move to logic that accepts ERC-1271) before relying on this signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
