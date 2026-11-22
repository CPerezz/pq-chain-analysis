---
id: 9f342d7e-rotate-signer-before-migrating
title: "0x9f342d7e: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9f342d7ee2e55e27250208ac97349d4d25761e8a"
  family: "269480c875e30262e399c3eb6f5cf599"
  copies: 2
  upgradeable: "yes"
  admin: "Safe 0x8e592Df9DC0068B2fC9faFFD0eC8A84a0dB48733 (default admin)"
  rating: LOW
  txs_90d: 2729
  last_active: 2026-11-18
  recoveries_14d: 290
fix:
  layer: onchain-config
  who_acts: "Safe 0x8e592Df9DC0068B2fC9faFFD0eC8A84a0dB48733 (3-of-7) on proxy 0x52e7a0caf234b266bcfaa6aa933a412fde58432a"
evidence:
  level: bytecode
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
  note: "LOW: setter exists and a live 3-of-7 Safe holds the required roles."
---

## Summary

UUPS AccessControlDefaultAdminRules implementation (unverified) behind proxy 0x52e7a0ca…432a, with stored verifierSigner/decryptResultSigner. Under EIP-8151 a stored signer with real code stops verifying.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setDecryptResultSigner, setVerifierSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Proxy 0x52e7a0ca… implementation slot = 0x9f342d7e… at block (cast storage)
- Decompiled setVerifierSigner (0x8db39c8d) and setDecryptResultSigner (0x2605ab9f) are role-gated (AccessControlUnauthorizedAccount); constants VERIFIER_SIGNER_MANAGER_ROLE 0x0b9c59c3…, DECRYPT_SIGNER_MANAGER_ROLE 0x60d4455b…
- hasRole(both manager roles, Safe) = true and hasRole(0x00, Safe) = true; owner()/defaultAdmin() = Safe 0x8e592Df9…; getRoleAdmin = 0x00
- Safe getThreshold = 3, 7 owners

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,729 transactions called it in the 90 days before that block; last on 2026-11-18.
- 290 signature recoveries in the study's two-week trace window.

## Remediation

The Safe calls setVerifierSigner/setDecryptResultSigner with a new key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
