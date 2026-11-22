---
id: nexus-88b94086-7702-own-key-only
title: "Nexus: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x88b9408678d66cc7045918b1f294569d242cf483"
  family: "4eea404f9f4884a4e1ff006dad6ccaf4"
  copies: 44187
  name: "Nexus"
  label: "created by Biconomy: Nexus Account Factory (MEE v2.0.0)"
  upgradeable: "yes"
  rating: LOW
  value_usd: 45114
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4431
  last_active: 2026-11-17
fix:
  layer: account-migration
  who_acts: "account holder (re-delegate or keep the 7702 delegation)"
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
  note: "Own-key-only check confirmed. A delegated account is unaffected, and the fix is to keep or redo the 7702 delegation. value $45,114 (held), txs_90d 4431"
---

## Summary

Nexus: EIP-7702 delegate logic whose signed path accepts only the account's own key (recovered == address(this)). Under EIP-8151 it fails only if the account later holds real code.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Solady LibPREP: proves once, at initialisation, that the account's address comes out of a 7702 authorisation whose s is the hash of r, a key nobody holds. Read from source.
- verified source: Nexus.sol: own-key recover only on the 7702 init path (`_amIERC7702()`), LibPREP rPREP(address(this)) at :545; other signatures via validator modules
- cast code at 26438999: 0xef0100; the target code hash equals facts.representative_code.h; delegations are exempt from EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $45,114 (ETH and 49 priced tokens, over 44,187 addresses).
- Activity: 4,431 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
