---
id: distributor-c736a9e9-rotate-signer-before-migrating
title: "Distributor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc736a9e9c71cbe6b7eb7404131a6a98394795ca6"
  family: "5d883d1a53af7a3a8827d29f6f10b767"
  copies: 47
  name: "Distributor"
  upgradeable: "yes"
  rating: LOW
  value_usd: 47460
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4807
  last_active: 2026-11-18
  recoveries_14d: 946
fix:
  layer: onchain-config
  who_acts: "SIGNER_ROLE admin or proxy-admin owner 0xA90621a8 (EOA)"
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
  note: "Live upgrade path through ProxyAdmin owned by an EOA; the role setters also exist. The current DEFAULT_ADMIN holder was not identified (the initial Safe 0x395426ce no longer holds it)."
---

## Summary

Distributor (47 copies) where claims need both the user's signature (SignatureChecker, handles 1271) and a platform signature recovered with plain ECDSA that must hold SIGNER_ROLE. A platform signer with code makes claims revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the user's signer (SignatureChecker) and a platform signer holding a role must both sign. Read from source. Executed: a real transaction reverts with code at the signer.
- Distributor.sol:336-346: user signer via SignatureChecker; platform signer via ECDSA.recover then hasRole(SIGNER_ROLE), no 1271 for the platform signer
- SIGNER_ROLE is an AccessControl role (grant/revoke); setCarryWithdrawerSigner is onlyRole(MANAGER_ROLE)
- EIP-1967 admin = ProxyAdmin 0xc0b89eb8, whose owner 0xA90621a807Ff25499a275eFa914DBAEa62a4Ef70 has no code, nonce 322

## Impact and exposure

- Value held at block 26,438,999: $47,460 (ETH and 49 priced tokens, over 47 addresses).
- Activity: 4,807 transactions called it in the 90 days before that block; last on 2026-11-18.
- 946 signature recoveries in the study's two-week trace window.

## Remediation

Grant SIGNER_ROLE to an EOA platform key (or upgrade via ProxyAdmin) before the old key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
