---
id: ethvault-b46dba42-signed-shortcut-lost
title: "EthVault: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb46dba422bcf7f113da2eeb41c0e2cc6298d6bba"
  family: "da6e03a70c315f92ec6b3984c576be1c"
  copies: 3
  name: "EthVault"
  label: "deployed by StakeWise: Deployer 1"
  upgradeable: "yes"
  rating: NONE
  value_usd: 114048
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-10-13
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "ERC-1271 is accepted for the manager and the direct call exists: refuted, or LOW at worst."
---

## Summary

StakeWise EthVault: registerValidators accepts a direct call from the validators manager or its signature through OpenZeppelin SignatureChecker. SignatureChecker falls back to ERC-1271 when ECDSA fails, so a manager with code is handled; the admin can also replace the manager.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: StakeWise registerValidators: the validators manager calls itself, or its signature is checked with SignatureChecker (ECDSA, then ERC-1271). Read from source.
- VaultValidators.sol:81-90: the manager calls itself (msg.sender check) or SignatureChecker (ECDSA, then ERC-1271, SignatureChecker.sol:41-46)
- VaultValidators.sol:118 setValidatorsManager callable by the vault admin
- reading.first.json (EthPrivVault family) lists all three ways

## Impact and exposure

- Value held at block 26,438,999: $114,048 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-13.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
