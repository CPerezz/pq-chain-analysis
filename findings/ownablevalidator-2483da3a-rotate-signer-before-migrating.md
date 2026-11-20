---
id: ownablevalidator-2483da3a-rotate-signer-before-migrating
title: "OwnableValidator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2483da3a338895199e5e538530213157e931bf06"
  family: "642f82157a04751a9b0b0715d659b8fa"
  name: "OwnableValidator"
  label: "created by Rhinestone: Module Registry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1535
  last_active: 2026-11-17
  recoveries_14d: 115
fix:
  layer: account-migration
  who_acts: "each ERC-7579 account (the account itself)"
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
  note: "LOW by the account's own call. Close to refuted: the v=0 path accepts ERC-1271 for owners with code, if their code implements it."
---

## Summary

Rhinestone OwnableValidator: a threshold of the account's stored owners must sign. Under EIP-8151 an ECDSA-format signature from an owner with real code no longer counts.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Rhinestone OwnableValidator (variant, stateless) / Rhinestone OwnableValidator (variant): owners of the calling account must reach its threshold. Read from source. Executed: a real transaction reverts with code at the signer.
- source OwnableValidator.sol:146,174,206 setThreshold/addOwner/removeOwner use account = msg.sender (per-account config)
- _validateSignatureWithConfig (l.360-398): CheckSignatures.recoverNSignatures, then owners.contains(account, signer)
- node_modules/@rhinestone/checknsignatures CheckNSignatures.sol:49,89: v==0 signatures call ISignatureValidator(owner).isValidSignature (ERC-1271)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,535 transactions called it in the 90 days before that block; last on 2026-11-17.
- 115 signature recoveries in the study's two-week trace window.

## Remediation

The account rotates owners (addOwner/removeOwner, setThreshold); a contract owner can also sign in the v=0 ERC-1271 format.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
