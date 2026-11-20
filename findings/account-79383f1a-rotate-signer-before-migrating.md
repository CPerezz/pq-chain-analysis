---
id: account-79383f1a-rotate-signer-before-migrating
title: "Account: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x79383f1ab202c0f7ad755e298c4ab544296c9fdf"
  family: "49a157ce3d241837ca00130f4b0b3af7"
  copies: 15444
  name: "Account"
  upgradeable: "no"
  rating: LOW
  value_usd: 483622
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 50050
  last_active: 2026-11-18
  recoveries_14d: 3803
fix:
  layer: account-migration
  who_acts: "account admin (key holder)"
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
  note: "Key holder itself can rotate before migrating."
---

## Summary

thirdweb ERC-4337 Account (15,444 clones): admins and session signers authorise by ECDSA only; an admin key with code loses control.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: thirdweb Account permissions: the request must be signed by an admin of the account / thirdweb AccountPermissions._recoverAddress: returns the signer / thirdweb Account ERC-1271: the signer must be…. Read from source. Executed: a real transaction reverts with code at the signer.
- setPermissionsForSigner via SignerPermissionRequest signed by a current admin, submittable by anyone (reading.keys)
- no msg.sender path; not upgradeable (EIP-1167)

## Impact and exposure

- Value held at block 26,438,999: $483,622 (ETH and 49 priced tokens, over 15,444 addresses).
- Activity: 50,050 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,803 signature recoveries in the study's two-week trace window.

## Remediation

Admin signs a request adding a new EOA admin before its key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
