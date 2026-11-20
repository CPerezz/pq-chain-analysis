---
id: nitroverifier-677ef715-rotate-signer-before-migrating
title: "NitroVerifier: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x677ef7152a6c620d37fbf57d4882ec2bc53e2ccd"
  family: "3efe18a994f2cf5f01577a67d37500aa"
  copies: 2
  name: "NitroVerifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 7769
  last_active: 2026-11-18
  recoveries_14d: 1185
fix:
  layer: onchain-config
  who_acts: "enclave attester / DEFAULT_ADMIN 0x9ec3…518d"
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
  note: "A live EOA admin/attester can register a replacement key."
---

## Summary

Fluent NitroVerifier: verifyBatch recovers the signer and requires verifiedPubkeys[signer]. Keys are enclave-generated and added by an attester with an SP1 attestation proof.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Nitro enclave verifier: the signer must be a key registered through an enclave attestation; such keys are made inside the enclave and re-registered by a new attestation. Read from source. Executed: a real transaction reverts with code at the signer.
- NitroVerifier.sol:193-194 ECDSA.recover then require(verifiedPubkeys[verifier]); verifyAttestation (ENCLAVE_ATTESTER_ROLE) adds a key, revokeAttestation (DEFAULT_ADMIN_ROLE) removes one
- RoleGranted logs from creation (block 24913410): 0x9ec3f0d76a6d3847d86374c791c6e170cad9518d holds DEFAULT_ADMIN and ENCLAVE_ATTESTER (hasRole true at block 26438999), an EOA with nonce 143; 0x4b6b…3be6 is an attester (nonce 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 7,769 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,185 signature recoveries in the study's two-week trace window.

## Remediation

Attest a fresh enclave key; the admin can revoke the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
