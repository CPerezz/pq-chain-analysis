---
id: oxideportal-d7ae00b9-rotate-signer-before-migrating
title: "OxidePortal: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd7ae00b91ba0b8e0240b22cd75fe447d177c260f"
  family: "72ed69165be309c5f0c5c961f4107147"
  copies: 2
  name: "OxidePortal"
  upgradeable: "no"
  rating: LOW
  value_usd: 14076
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2258
  last_active: 2026-11-17
  recoveries_14d: 74
fix:
  layer: onchain-config
  who_acts: "TEE operators (anyone with a valid attestation of an approved PCR0 image)"
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
  note: "LOW: rotation is permissionless through registerTee. The note's 'Aztec committee' check was not found in the portal source (it would be in the external Aztec rollup); only the TEE signer sites were verified."
---

## Summary

Oxide portal (Aztec bridge): withdraw and the refund paths need ECDSA.recover over a TEE-signed digest to be a registered TEE (_assertTeeActive). A TEE address that had code would fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Aztec committee (variant): the rebuilt committee must match the stored commitment and two thirds plus one must have signed; a member who cannot sign is listed by address / Aztec SignatureLib.verify:…. Read from source. Executed: a real transaction reverts with code at the signer.
- OxidePortal.sol:362,408,491,633: ECDSA.recover(finalDigest, teeSignature) then _assertTeeActive(signer) via $teeBindings
- registerTee (OxidePortal.sol:165) is external with no owner check; it binds a new TEE key after a Nitro attestation of an approved PCR0
- owner() = 0 at block 26438999, so approveTeePcr0 (onlyOwner) can no longer add images; registration uses the images already approved

## Impact and exposure

- Value held at block 26,438,999: $14,076 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,258 transactions called it in the 90 days before that block; last on 2026-11-17.
- 74 signature recoveries in the study's two-week trace window.

## Remediation

Register a fresh TEE key via registerTee. TEE keys are enclave-held keypairs and cannot practically gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
