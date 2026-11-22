---
id: api3serverv1-709944a4-rotate-signer-before-migrating
title: "Api3ServerV1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x709944a48caf83535e43471680fda4905fb3920a"
  family: "0fcfb15c3ee0c219fbb9f10fe9eacf7c"
  copies: 2
  name: "Api3ServerV1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6863
  last_active: 2026-11-18
  recoveries_14d: 6795
fix:
  layer: onchain-config
  who_acts: "dAPI manager (contract owned by a 4-of-8 Safe)"
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
  note: "A live party (a Safe) repoints feeds. Readers that pin a Beacon id directly must switch it themselves."
---

## Summary

API3 Api3ServerV1: a Beacon is updated with data signed by the airnode named in the call, and the Beacon id is keccak(airnode, templateId). An airnode key with code freezes its Beacons; a new key means new Beacons, which the dAPI name can be pointed to.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: API3 signed data: the signer must be the airnode named in the call; the beacon's id is derived from that address, so a beacon cannot change its key; a dAPI name can be pointed to another beacon /…. Read from source.
- BeaconUpdatesWithSignedData.sol:37 recover(signature) == airnode; DataFeedServer.sol:91 beaconId = keccak256(airnode, templateId)
- DapiServer.sol:64 setDapiName allows msg.sender == manager; manager() = 0x81bc85f3…f9a6 (contract, nonce 1) whose owner() = 0x2AAE699e…c9E8, a Safe with 8 owners, threshold 4, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6,863 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6,795 signature recoveries in the study's two-week trace window.

## Remediation

Operator signs with a new EOA key; the manager repoints dAPI names to the new Beacon (set).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
