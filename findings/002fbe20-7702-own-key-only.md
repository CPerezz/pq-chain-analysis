---
id: 002fbe20-7702-own-key-only
title: "0x002fbe20: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x002fbe208a0078001c3800005f00c28367638b9f"
  family: "99c356c69473eb19ab919329c68fe37b"
  copies: 5
  upgradeable: "no"
  rating: LOW
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1062
  last_active: 2026-11-17
fix:
  layer: account-migration
  who_acts: "account holder (re-delegate or keep the 7702 delegation)"
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
  note: "Own-key-only check confirmed. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $4,692 (held), txs_90d 1062"
---

## Summary

unnamed 7702 delegate: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- heimdall decompile of the delegate target 0xec529fcb30334bbfe24e8cc723c64475937b2c37: isValidSignature: `ecrecover(arg0)`; `if (var_a == address(this)) return 0x1626ba7e`
- cast code at 26438999: 0xef0100ec529fcb30334bbfe24e8cc723c64475937b2c37; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $4,692 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 1,062 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
