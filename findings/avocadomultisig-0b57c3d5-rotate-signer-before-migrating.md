---
id: avocadomultisig-0b57c3d5-rotate-signer-before-migrating
title: "AvocadoMultisig: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0b57c3d5a7a93c3e9652459aff3c7fef792a7c2c"
  family: "9591f7a69b832c1438365d668e4de94f"
  copies: 131
  name: "AvocadoMultisig"
  label: "deployed by Instadapp: Avocado Broadcaster 6"
  upgradeable: "yes"
  rating: NONE
  value_usd: 31219
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-07
  recoveries_14d: 4
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "a signer with code is handled via ERC-1271."
---

## Summary

AvocadoMultisig: if a signer has code it is verified with ERC-1271, otherwise with ECDSA.recover.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Avocado multisig: each signer must be in the allowed list; a signer with code is taken as a contract signer, otherwise ECDSA.recover must equal it. Read from source. Executed: a real transaction reverts with code at the signer.
- AvocadoMultisigCore.sol:152-158 Address.isContract(signer) branch skips ECDSA
- lines 199-205 IERC1271(signer).isValidSignature

## Impact and exposure

- Value held at block 26,438,999: $31,219 (ETH and 49 priced tokens, over 131 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-07.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
