---
id: hydranet-cc4c47cf-signature-rechecked
title: "Lithium: a signature checked again after others relied on it"
project: hydranet
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xcc4c47cf0175aa8108e78679c2586a0a6abb242a"
  family: "c3b241e8d1c2a2ecc33b691a48093dff"
  name: "Lithium"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 12358
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1013
  last_active: 2026-11-18
  recoveries_14d: 268
fix:
  layer: new-deployment
  who_acts: "parties settle before a signing address takes code"
evidence:
  level: executed
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
  note: "executed"
---

## Summary

`Lithium` at `0xcc4c47cf0175aa8108e78679c2586a0a6abb242a`. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Lithium channel state: both alice and bob of the channel must have signed the state / Lithium channel state (calldata variant): both must have signed / Lithium revocation: the signature of alice or…. Read from source. Executed by hand: see Evidence.
- Lithium `0xcc4c47cf0175aa8108e78679c2586a0a6abb242a`: `LithiumVerification.sol` L57–62 requires both parties' `ECDSA.recover`. Executed (300,000 gas added, because both senders' limits are already too tight under the EIP): updates `0x5c9d200171ba634ec878f8481a311a42b452742aba30ec3de9f48b761fc52e9b` and `0x9278bf51b908461e2d432b6d0bf2550517f0d0cc437eed3feb4190c9dc9026ea` revert with code at the counterparty.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: LithiumVerification requires both parties' ECDSA signatures on every channel state and revocation.
- Executed: updates 0x5c9d2001… and 0x9278bf51… revert with code at the counterparty.
- No proxy, no upgrade. 1,013 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $12,358 (ETH and 49 priced tokens).
- Activity: 1,013 transactions called it in the 90 days before that block; last on 2026-11-18.
- 268 signature recoveries in the study's two-week trace window.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
