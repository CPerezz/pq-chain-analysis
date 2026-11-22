---
id: oxideaccount-b5fceefb-rotate-signer-before-migrating
title: "OxideAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5fceefbb04ca0cdef87038be5a91f296229b54a"
  family: "a6101ad86e8a6f11ea41479a3d9bff02"
  copies: 948
  name: "OxideAccount"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1207
  last_active: 2026-11-17
  recoveries_14d: 120
fix:
  layer: account-migration
  who_acts: "each Oxide account clone (the account, via EntryPoint or self)"
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
  note: "LOW by the account's own call. The 'setter' is moving to passkey auth, not replacing the bootstrap key."
---

## Summary

OxideAccount implementation for clones: until a passkey is added, signatures must recover to the bootstrapOwner (an immutable clone arg). Under EIP-8151 a bootstrap owner with real code cannot sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Oxide account: before passkeys are added, the signer must be the bootstrap owner. Read from source. Executed: a real transaction reverts with code at the signer.
- source OxideAccount.sol:93-97 accepts ECDSA only when authKeys.length == 0 and recovered == bootstrapOwner()
- addAuthKey (l.48) is onlyEntryPointOrSelf and adds a P256/WebAuthn key, after which ECDSA is no longer used
- bootstrapOwner is fixed per clone (Clones.fetchCloneArgs) and reverts on the implementation itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 948 addresses).
- Activity: 1,207 transactions called it in the 90 days before that block; last on 2026-11-17.
- 120 signature recoveries in the study's two-week trace window.

## Remediation

The account adds a passkey (addAuthKey) while the bootstrap EOA still signs; a 7702-delegated bootstrap EOA keeps working.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
