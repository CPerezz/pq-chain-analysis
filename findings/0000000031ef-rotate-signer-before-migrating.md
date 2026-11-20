---
id: 0000000031ef-rotate-signer-before-migrating
title: "0x00000000 (tagged Biconomy: MEE K1 Validator v1.0.3 (MEE v2.1.0)): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000000031ef4155c978d48a8a7d4edba03b04fe"
  family: "249ca13b9caba6a2f790f608ce304abc"
  copies: 2
  label: "Biconomy: MEE K1 Validator v1.0.3 (MEE v2.1.0)"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2155
  last_active: 2026-11-16
  recoveries_14d: 208
fix:
  layer: account-migration
  who_acts: "each smart account (owner key holder via the account)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Per-account owner, rotatable by the account's own call → LOW."
---

## Summary

ERC-7579 K1 validator module (Biconomy-style: smartAccountOwners(address), getOwner(address), onInstall/onUninstall, transferOwnership). It keeps one owner key per smart account; that account can no longer validate once its owner EOA takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: validator module: owner per account, handed over with transferOwnership. Bytecode and names.
- Selectors (cast selectors on the bytecode): transferOwnership(address), smartAccountOwners(address), getOwner(address), onInstall/onUninstall. The owner is stored per msg.sender account.
- Window traces: called directly by accounts (e.g. 0xdb7dd4fa…, 0x784ff9de…), so the key holder is the account itself, which can call transferOwnership or reinstall the module.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,155 transactions called it in the 90 days before that block; last on 2026-11-16.
- 208 signature recoveries in the study's two-week trace window.

## Remediation

Before the owner EOA takes code, the account calls transferOwnership(newOwner) on the module, or uninstalls and reinstalls it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
