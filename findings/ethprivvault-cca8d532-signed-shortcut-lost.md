---
id: ethprivvault-cca8d532-signed-shortcut-lost
title: "EthPrivVault: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcca8d532e625d30514ace25963283228f82ccdda"
  family: "5b8e1707c908cc5bd0199a8fc1086ef3"
  copies: 8
  name: "EthPrivVault"
  upgradeable: "yes"
  rating: NONE
  value_usd: 144906
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 51
  last_active: 2026-10-06
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

StakeWise EthPrivVault: registerValidators accepts a direct call from the validators manager or its signature through OpenZeppelin SignatureChecker. SignatureChecker falls back to ERC-1271 when ECDSA fails, so a manager with code is handled; the admin can also replace the manager.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: StakeWise registerValidators: the validators manager calls itself, or its signature is checked with SignatureChecker (ECDSA, then ERC-1271). Read from source.
- VaultValidators.sol:81-90: the manager calls itself (msg.sender check) or SignatureChecker (ECDSA, then ERC-1271, SignatureChecker.sol:41-46)
- VaultValidators.sol:118 setValidatorsManager callable by the vault admin
- reading.first.json (EthPrivVault family) lists all three ways

## Impact and exposure

- Value held at block 26,438,999: $144,906 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 51 transactions called it in the 90 days before that block; last on 2026-10-06.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
