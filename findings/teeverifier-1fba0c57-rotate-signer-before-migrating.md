---
id: teeverifier-1fba0c57-rotate-signer-before-migrating
title: "TEEVerifier: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1fba0c57b07af804a9717e51dec9cc27fbc12228"
  family: "75fff02a0a6e88b97c6b505cdc95cca1"
  name: "TEEVerifier"
  label: "Base: TEE Verifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 12959
  last_active: 2026-11-18
  recoveries_14d: 1003
fix:
  layer: onchain-config
  who_acts: "TEEProverRegistry owner Safe / manager"
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
  note: "Live owner Safe and manager EOA. Enclave keys are unlikely ever to hold code."
---

## Summary

Base TEEVerifier. It recovers an enclave signer with ECDSA.tryRecover and requires TEEProverRegistry.isRegisteredSigner and a matching image hash.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: TEE verifier: the signer must be registered in the TEE prover registry with the expected image. Read from source.
- TEEVerifier.sol:57-96; registry 0x1af2…A5aA: registerSigner/deregisterSigner are onlyOwnerOrManager
- Registry owner 0x9855…46A1 = Safe 3/6; manager 0xd874…1b04 = EOA nonce 826
- Registry is a proxy (admin 0x0475…059e, impl 0x1d87…f440)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 12,959 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,003 signature recoveries in the study's two-week trace window.

## Remediation

The manager or owner deregisters the old signer and registers a new enclave key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
