---
id: wrapperlocketh-50cb61af-rotate-signer-before-migrating
title: "WrapperLockEth: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x50cb61afa3f023d17276dcfb35abf85c710d1cff"
  family: "dadd69ce30cda2a8f5a6d309fc005470"
  name: "WrapperLockEth"
  label: "deployed by Bitfinex: Deployer 6"
  upgradeable: "no"
  rating: LOW
  value_usd: 129748
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-09-30
fix:
  layer: onchain-config
  who_acts: "signer EOA"
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
  note: "live key holder; funds never locked (timed withdraw)"
---

## Summary

WrapperLockEth: early withdraw needs a signer signature; after depositLock withdraw has no signature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- addSigner requires isSigner[msg.sender] (msg.sender path)
- deployer 0x14d067… isSigner true, EOA nonce 618 with 7702 delegation (node block 26438999); owner 0x7a36… not signer

## Impact and exposure

- Value held at block 26,438,999: $129,748 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-09-30.

## Remediation

existing signer adds a new EOA signer

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
