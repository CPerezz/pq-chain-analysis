---
id: multisigwallet-7da82c7a-rotate-signer-before-migrating
title: "MultiSigWallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9"
  family: "077a160a57be207b3427b9030cf32233"
  copies: 3
  name: "MultiSigWallet"
  label: "Golem: Multisig"
  upgradeable: "no"
  rating: LOW
  value_usd: 17205216
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "multisig owners"
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
  note: "The direct path stays open to the same owners, and rotation needs no ecrecover: LOW. Owner liveness not enumerated (the owners(i) getter returned empty)."
---

## Summary

Golem old Gnosis MultiSigWallet (required = 3). A signature batch containing an owner with code throws.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: old Gnosis MultiSigWallet modifier: every signature must recover to an owner; owners can also confirm by their own call / old Gnosis MultiSigWallet: adds a confirmation for each owner recovered from…. Read from source.
- reading 077a160a: owners confirm and revoke by direct call; addOwner/removeOwner are onlyWallet, reached with direct-call confirmations
- required() = 3 at the block

## Impact and exposure

- Value held at block 26,438,999: $17.2M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners confirm by direct call, or replace the key through a direct-confirmed transaction.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
