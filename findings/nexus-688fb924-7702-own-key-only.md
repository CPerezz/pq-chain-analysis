---
id: nexus-688fb924-7702-own-key-only
title: "Nexus: 7702 logic that accepts only the account's own key"
status: not-affected
severity: NONE
patterns: [PQ-20]
impact: none
contracts:
- address: "0x688fb924b082d02ffb97ac7b1acdfb67701474bf"
  family: "1b879468be69c602340cc59144f01635"
  copies: 75579
  name: "Nexus"
  label: "created by Rhinestone: Nexus Factory"
  upgradeable: "yes"
  rating: NONE
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9790
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "Code gates the own-key path on the account being a 7702 delegation, so a signer with real code never reaches it. value_usd 361, txs_90d 9790."
---

## Summary

Nexus (Biconomy/Rhinestone) smart account. Its own-key ecrecover in initializeAccount runs only when _amIERC7702() is true (code is exactly a 23-byte 0xef0100 indicator), which EIP-8151 still allows.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Nexus initializeAccount (variant): the signature must recover to the account itself / Solady LibPREP: proves once, at initialisation, that the account's address comes out of a 7702 authorisation…. Read from source.
- Nexus.sol:315-332: own-key check sits inside if (_amIERC7702()); an account with real code takes Initializable.requireInitializable() instead
- ModuleManager.sol:597-604 _amIERC7702 = extcodesize==23 and prefix 0xef0100
- LibPREP (Nexus.sol:552) recovers to address(this) only for a PREP account during init, which is itself a 7702 account; normal signatures go through validator modules (ModuleManager.sol:429, ERC-7579)
- cast code 0x688f... at 26438999: 0xef0100 indicator to 0x00000000000032ddc454c3bdcba80484ad5a798705

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 75,579 addresses).
- Activity: 9,790 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
