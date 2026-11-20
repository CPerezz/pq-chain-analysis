---
id: qryptsafe-8c39444f-signature-rechecked
title: "QryptSafe: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x8c39444f1c6e4b7b9639f4325765c8426b4d1cd1"
  family: "c514b39734ebe1a90f74c7bdde1c70d0"
  copies: 14
  name: "QryptSafe"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "vault owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "A voucher recipient who relied on the owner's signature loses it, with no update path; the owner's rescue functions pay the owner, not the recipient, so they do not make this MEDIUM."
---

## Summary

QryptSafe vault (45-byte proxy to 0x9e736020…): the owner signs offline QryptAir vouchers, and a recipient redeems one later with claimAirVoucher against airBags. If the owner's address takes code, outstanding vouchers can never be redeemed, while the owner keeps reclaimOffToken and emergencyWithdraw.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: QryptSafe claimAirVoucher: a voucher the vault owner signed is redeemed later by its recipient against tokens set aside. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- QryptSafe.sol:1954-1955 claimAirVoucher: ECDSA.recover(digest, signature) must equal owner
- reclaimOffToken (1902) and emergencyWithdraw (1993) are onlyOwner by msg.sender, with no signature, and pay the owner, not the voucher recipient
- owner() at 26438999 = 0x6343…aa18 (EOA); the proxy delegates to a fixed address; value $1

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on chain; the owner can reissue the value to recipients by a direct transfer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
