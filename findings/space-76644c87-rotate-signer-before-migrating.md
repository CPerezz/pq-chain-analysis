---
id: space-76644c87-rotate-signer-before-migrating
title: "Space: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x76644c879d0b61ea8fbbf306879eb60a292ab45f"
  family: "4795b93f76d0549dd946091eeedabebd"
  copies: 29
  name: "Space"
  upgradeable: "yes"
  rating: LOW
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 73
  last_active: 2026-11-13
fix:
  layer: onchain-config
  who_acts: "account admin"
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
  note: "The key holder is live and has setter and direct-call paths. 73 txs in 90d."
---

## Summary

Space is a thirdweb-based account (upgradeable). Admin and session signatures go through ECDSA recover.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: thirdweb Account permissions: the request must be signed by an admin of the account / thirdweb AccountPermissions._recoverAddress: returns the signer / thirdweb Account validateUserOp: the signer…. Read from source.
- Space.sol:372 withdraw*/execute allow msg.sender == admin directly, with no signature
- setPermissionsForSigner, signed by an admin, adds or removes admins
- getAllAdmins = [0x96C7…047f], an EOA with nonce 95

## Impact and exposure

- Value held at block 26,438,999: $20,752 (ETH and 49 priced tokens, over 29 addresses).
- Activity: 73 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Admin rotates the admin set, or acts by direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
