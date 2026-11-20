---
id: humanidpayments-a2ca14c7-rotate-signer-before-migrating
title: "HumanIDPayments: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa2ca14c7d625895e6939961b87ce378836ca840f"
  family: "610164223708a091465f2d02844b783e"
  name: "HumanIDPayments"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2328
  last_active: 2026-11-18
  recoveries_14d: 382
fix:
  layer: onchain-config
  who_acts: "ADMIN_ROLE holder 0xcafe2e…f7e3"
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
  note: "stored-key setter callable by a live EOA admin"
---

## Summary

HumanIDPayments: pay/refund need an EIP-191 signature from oracleAddress; an oracle with code fails recovery.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setOracleAddress(address) onlyRole(ADMIN_ROLE) in verified source HumanIDPayments.sol:319
- oracleAddress() = 0x1F39402D34ea3024dC7f6afC6ADDDE198332A307 (EOA, nonce 647) at block 26438999
- hasRole(ADMIN_ROLE, 0xcafe2ef59688187ee312c8aca10ceb798338f7e3) = true at block 26438999; that address is an EOA, nonce 55 (RoleGranted at deploy 24022185)

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens).
- Activity: 2,328 transactions called it in the 90 days before that block; last on 2026-11-18.
- 382 signature recoveries in the study's two-week trace window.

## Remediation

admin calls setOracleAddress with a fresh EOA oracle before the oracle account takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
