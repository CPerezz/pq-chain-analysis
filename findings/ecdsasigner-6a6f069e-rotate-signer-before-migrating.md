---
id: ecdsasigner-6a6f069e-rotate-signer-before-migrating
title: "ECDSASigner: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6a6f069e2a08c2468e7724ab3250cdbfba14d4ff"
  family: "c26ace576bcf0beb2cbf21da6717f050"
  name: "ECDSASigner"
  label: "deployed by Stackup: Bundler 2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3215
  last_active: 2026-11-18
  recoveries_14d: 1142
fix:
  layer: account-migration
  who_acts: "each Kernel v3 wallet (the account itself)"
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
  note: "LOW by the account's own call: the key holder is the wallet's own configuration."
---

## Summary

Kernel v3 ECDSASigner permission module: the signer is stored as signer[id][wallet] and must be recovered. Under EIP-8151 a stored signer that takes real code cannot sign for that permission.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Kernel v3 ECDSASigner (permission module): the signer stored per wallet and permission id must recover (Solady recover reverts on no address); the wallet replaces it by uninstalling and installing…. Read by hand. Executed: a real transaction reverts with code at the signer.
- source/src/ECDSASigner.sol:20,39 reads owner = signer[id][msg.sender] (per wallet)
- _signerOnUninstall (l.57-60) deletes and _signerOninstall (l.51-54) sets signer[id][msg.sender]: only the wallet, as msg.sender, can replace its own signer
- Not upgradeable; no global admin

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,215 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,142 signature recoveries in the study's two-week trace window.

## Remediation

The wallet uninstalls and reinstalls the permission with a new signer (or uses another validator) while the old key still works.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
