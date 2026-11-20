---
id: zippiesoneth-5d9f8c3b-rotate-signer-before-migrating
title: "ZippiesOnEth: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d9f8c3b273f940cc73b5e430ec446557dc2611b"
  family: "19de4e327e57832bf2c9fbea148ec490"
  copies: 2
  name: "ZippiesOnEth"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1505
  last_active: 2026-11-12
fix:
  layer: onchain-config
  who_acts: "owner 0x22cF…f61F"
evidence:
  level: bytecode
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
  note: "Setter is onlyOwner and the owner is a live (7702) EOA."
---

## Summary

ZippiesOnEth checks signatures against one stored signer. If that signer gets code, signed actions fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompile: setSigner(address) 0x6c19e783 requires msg.sender == owner (store_s, error 0x118cdaa7), emits SignerChanged
- owner() at block 26438999 = 0x22cF8b46…f61F: 7702-delegated EOA (code 0xef0100612373…), nonce 22, so its key still signs
- 1505 txs in 90d (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,505 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

Owner calls setSigner(newEOA) before the signer migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
