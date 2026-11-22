---
id: nexus-86567c5c-7702-own-key-only
title: "Nexus: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x86567c5cb9bd001e8f6ce1b60b95038275a26d37"
  family: "9838bff7d89f6b86476e2b3e8b65ff31"
  copies: 190
  name: "Nexus"
  label: "created by Biconomy: Nexus Account Factory (MEE v2.2.1)"
  upgradeable: "yes"
  rating: LOW
  value_usd: 113146
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 518
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
  note: "Own-key check confirmed from source, but it is gated to 7702 accounts, which keep working while delegated. LOW (re-delegate or stay delegated). value $113,146 (held), txs_90d 518"
---

## Summary

Nexus account as a real-code proxy. The own-key recover only runs for 7702-delegated Nexus accounts (exempt); this proxy signs through validator modules.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Solady LibPREP: proves once, at initialisation, that the account's address comes out of a 7702 authorisation whose s is the hash of r, a key nobody holds / Nexus initializeAccount (7702): the…. Read from source.
- verified source: Nexus.sol:375 `require(ECDSA.recover(initDataHash, signature) == address(this))`, only inside `if (_amIERC7702())` (ModuleManager.sol:673 checks code is 0xef0100…); other signatures go to validator modules
- cast code at 26438999: real code (proxy, 216 hex chars). On real code _amIERC7702() is false, so the own-key branch is skipped and validators sign

## Impact and exposure

- Value held at block 26,438,999: $113,146 (ETH and 49 priced tokens, over 190 addresses).
- Activity: 518 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Keep the 7702 delegation, or re-delegate to logic that accepts the account's key while it has code / ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
