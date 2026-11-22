---
id: tbtc-afdf5b60-signature-rechecked
title: "DepositRedemption: a signature checked again after others relied on it"
project: tbtc
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xafdf5b603f07cf664e44f3896bb2f0047d330ba4"
  family: "ef83389f8488b7b83bc903c63440b0f8"
  copies: 4306
  name: "DepositRedemption"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 234572
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-02
fix:
  layer: new-deployment
  who_acts: "parties settle before a signing address takes code"
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
  note: "fraud proofs fail against a group with code"
---

## Summary

`DepositRedemption` at `0xafdf5b603f07cf664e44f3896bb2f0047d330ba4`, with 4,305 more addresses running its code. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: tBTC v1 CheckBitcoinSigs: the recovered address must be the address of the signing group's public key; used for the redemption signature and as proof of a fraudulent signature. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (tBTC v1): the signing group's signature is checked again in fraud proofs; a group whose address took code could no longer be proven fraudulent.
- 4,306 deposits, fixed delegates, no upgrade; deprecated, 1 transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $234,572 (ETH and 49 priced tokens, over 4,306 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
