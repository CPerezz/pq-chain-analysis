---
id: referralprogram-4c321b01-entry-by-own-signature-only
title: "ReferralProgram: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x4c321b01437abafe04ca064abd59c9557767957f"
  family: "84cd77a0ee19ae94adbf7ecc1753b52e"
  copies: 2
  name: "ReferralProgram"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "referrer (signs from an EOA/7702 key); MEDIUM_TIMELOCK_ADMIN can set referrals directly"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Referral registration only; nothing held; admin path exists. LOW holds. Row says upgradeable yes, but this address is the implementation (the proxy running it was not identified)."
---

## Summary

ReferralProgram implementation: register(sig) recovers the parent from a signature over a fixed MAGIC_MESSAGE. Under EIP-8151 a parent with non-7702 code cannot refer by signature; no funds held and an admin path sets referrals directly.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: ReferralProgram register: the parent must sign a fixed message; a parent with code cannot refer. Read (function text).
- contracts/ReferralProgram/ReferralProgram.sol:46-62 register: parent = ECDSA.recover(toEthSignedMessageHash(MAGIC_MESSAGE), sig)
- setReferrals (:66) onlyRole(MEDIUM_TIMELOCK_ADMIN) writes referrerOf/referralsOf without signatures
- this address: slot_0 = 0xff (initializers disabled), EIP-1967 slots empty, balance 0 at 26438999; facts: 1 direct + 1 proxy run this code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Referrer signs from an EOA or 7702 account, or the admin records the referral via setReferrals.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
