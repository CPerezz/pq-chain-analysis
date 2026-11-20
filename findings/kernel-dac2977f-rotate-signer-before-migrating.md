---
id: kernel-dac2977f-rotate-signer-before-migrating
title: "Kernel: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdac2977f505d38f4457a0bdbc965e6c4a6f7fa9b"
  family: "f22d6bf5a1e49ddc8f3b38ae1928a95e"
  copies: 1907
  name: "Kernel"
  label: "deployed by Stackup: Bundler 1"
  upgradeable: "yes"
  rating: LOW
  value_usd: 17324
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 91
  last_active: 2026-10-27
fix:
  layer: account-migration
  who_acts: "account owner"
evidence:
  level: source-read
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
  note: "The key holder can rotate itself, even after migrating, by calling directly."
---

## Summary

ZeroDev Kernel v1 smart account: userOp and ERC-1271 validation require ECDSA.recover == stored owner. An owner with code can no longer sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Kernel v1: the recovered address must be the stored owner of the account. Read from source.
- Kernel.sol:139-148,176-180: ws.owner == ECDSA.recover(...)
- KernelStorage.sol:54 transferOwnership is onlyFromEntryPointOrOwnerOrSelf, so the owner can also call it directly as msg.sender
- getOwner() 0xddcf77DF…: no code, nonce 0 (signs userOps off-chain)

## Impact and exposure

- Value held at block 26,438,999: $17,324 (ETH and 49 priced tokens, over 1,907 addresses).
- Activity: 91 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

The owner calls transferOwnership (via a userOp, or directly) to a new key before or after migrating; upgradeTo is also available.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
