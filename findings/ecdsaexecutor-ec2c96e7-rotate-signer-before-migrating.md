---
id: ecdsaexecutor-ec2c96e7-rotate-signer-before-migrating
title: "ECDSAExecutor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xec2c96e75b09e29b66bf2ee5c37fa749ef9aa7c7"
  family: "3f3f348c6ca6855c746991f27e0d2f4d"
  name: "ECDSAExecutor"
  label: "Eco: ECDSA Executor"
  upgradeable: "no"
  rating: LOW
  txs_90d: 23722
  last_active: 2026-11-18
  recoveries_14d: 1462
fix:
  layer: account-migration
  who_acts: "each Kernel account using the executor (itself)"
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
  note: "The setter exists and the account itself (a live party) calls it. LOW."
---

## Summary

Eco ECDSAExecutor stores an owner per Kernel account (onInstall) and checks execute signatures with ECDSA.recover against it, with no 1271 and no code check. If that owner key takes code, the executor path fails for that account.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ECDSA executor module (execute read): the owner recorded for the account at installation must sign; the account can install another owner. Read by hand. Executed: a real transaction reverts with code at the signer.
- src/executor/ECDSAExecutor.sol:189: owner != ECDSA.recover(digest, signature) reverts.
- Lines 104-112: transferOwnership writes ecdsaExecutorStorage[msg.sender].owner. Callable only by the account itself; the account can also uninstall or reinstall (onInstall/onUninstall).
- No admin or proxy. The key holder is the account, which is live through its own validator.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 23,722 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,462 signature recoveries in the study's two-week trace window.

## Remediation

Before migrating the executor owner key, the account calls transferOwnership(newCodelessOwner) or reinstalls the module.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
