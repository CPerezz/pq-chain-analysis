---
id: 00000072-rotate-signer-before-migrating
title: "0x00000072: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x00000072f286204bb934ed49d8969e86f7dec7b1"
  family: "8dfa88b7abe136c2a721b8c075be38af"
  upgradeable: "no"
  rating: LOW
  txs_90d: 27248
  last_active: 2026-11-18
  recoveries_14d: 4710
fix:
  layer: account-migration
  who_acts: "each account using the module (itself)"
evidence:
  level: executed
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
  note: "The setter exists and its caller is the account itself, which is live while its key is still codeless. After migration the way out depends on the account's other modules. LOW per the rotate-before-migrating scale."
---

## Summary

ECDSAValidator 1.0.0 singleton (unverified) stores one owner per smart account and validates userOps and 1271 requests by ecrecover against it. If an owner key takes code, that account's validation through this module fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: validator module: the owner recorded per account, handed over with transferOwnership. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Dossier reading (8dfa88b7): 0xf2fde38b transferOwnership writes the caller's own owner slot; only the account (msg.sender) can call it, and it can also uninstall with 0x8a91b0e3. No admin, no proxy.
- Recovery result compared with the stored owner, with no code check and no 1271 fallback to the owner (reading.first.json).
- The account is the live key holder and can rotate with one call before migrating.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 27,248 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,710 signature recoveries in the study's two-week trace window.

## Remediation

Before the owner key migrates, the account calls transferOwnership(newCodelessOwner) or installs another validator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
