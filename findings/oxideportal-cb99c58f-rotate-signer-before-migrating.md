---
id: oxideportal-cb99c58f-rotate-signer-before-migrating
title: "OxidePortal: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcb99c58fe81ae6b2cb4835e46f7b703745879042"
  family: "30acf8f4fa7c18bb19e5ed020a2a130b"
  copies: 3
  name: "OxidePortal"
  upgradeable: "no"
  rating: LOW
  value_usd: 61535
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 993
  last_active: 2026-11-17
  recoveries_14d: 201
fix:
  layer: onchain-config
  who_acts: "TEE operator (register a new attested key)"
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
  note: "A replacement key path exists that any genuine enclave can use. The row note describes an 'Aztec committee', but the portal source checks registered TEE keys: worth a look."
---

## Summary

OxidePortal (Aztec-rollup token portal, immutable): withdrawals, refunds and prover-tip claims need an ECDSA.recover signature from a TEE key registered in TEE_REGISTRY.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Aztec committee: each slot of the committee carries a signature or an address; the rebuilt committee must match the stored commitment and two thirds plus one must have signed. A member who cannot…. Read from source. Executed: a real transaction reverts with code at the signer.
- OxidePortal.sol:426 accepts any signer with TEE_REGISTRY.isTeeRegistered; the signature comes from calldata, so one from another registered TEE can replace it
- TEE_REGISTRY 0x8b705C35…d9CD: registerTee(attestation, sig, pubkey…) is gated by Nitro attestation verification; the heimdall decompile has no msg.sender check (permissionless for a genuine enclave)
- TEE addresses derive from attested public keys, so the key holder (the enclave operator) can register a new key

## Impact and exposure

- Value held at block 26,438,999: $61,535 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 993 transactions called it in the 90 days before that block; last on 2026-11-17.
- 201 signature recoveries in the study's two-week trace window.

## Remediation

The operator registers a fresh attested TEE key and re-signs pending withdrawals with it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
