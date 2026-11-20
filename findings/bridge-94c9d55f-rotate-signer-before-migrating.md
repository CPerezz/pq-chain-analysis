---
id: bridge-94c9d55f-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x94c9d55f064980ed1faf0abb42f3548700619039"
  family: "6fb6da97e90112380370e0f619f23191"
  copies: 6
  name: "Bridge"
  upgradeable: "yes"
  rating: LOW
  value_usd: 70017
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 73
  last_active: 2026-11-16
  recoveries_14d: 7
fix:
  layer: onchain-config
  who_acts: "multisig Safe 0x22a1…ae64"
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
  note: "Role admin and upgrader is a live Safe (3 of 4 owners have sent transactions)."
---

## Summary

Bridge (UUPS): bridgeTokens needs an ecrecover signature from a RELAYER_ROLE holder. A relayer that takes code can no longer sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- Bridge.sol:656 requires hasRole(RELAYER_ROLE, recovered); getRoleAdmin(RELAYER_ROLE) = DEFAULT_ADMIN_ROLE; _authorizeUpgrade is onlyRole(MULTISIG_ROLE)
- RoleGranted logs from deploy block 24268658: DEFAULT_ADMIN and MULTISIG were moved to 0x22a11ff4…ae64; hasRole is true at block 26438999 (the deployer 0x8415…3fba was revoked)
- 0x22a1…ae64 is a Safe 2-of-4 with owner EOAs at nonces 0/3/1/3

## Impact and exposure

- Value held at block 26,438,999: $70,017 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 73 transactions called it in the 90 days before that block; last on 2026-11-16.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Admin Safe grants RELAYER_ROLE to a fresh EOA and revokes the migrating one, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
