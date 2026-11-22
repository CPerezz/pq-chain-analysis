---
id: f0c9651f-rotate-signer-before-migrating
title: "0xf0c9651f: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf0c9651fcb5ec9ff8eb405ba50a1c5840c9f917d"
  family: "6df27152f43a873cc6872f7ff2a0b9e9"
  copies: 81
  upgradeable: "no"
  rating: LOW
  value_usd: 12812
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1266
  last_active: 2026-11-18
  recoveries_14d: 20
fix:
  layer: onchain-config
  who_acts: "factory owner EOA 0xacb4e10fe8c5f470f5b697f5ead3a8add97b8041"
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
  note: "LOW: the signer set is owner-managed by a live EOA (low nonce, but no code)."
---

## Summary

Clone (impl 0xe68a2a75…) of an LP-management account: reposition/swap actions carry signatures, and the recovered addresses are checked against the signer set of delegatedAccountFactory 0x5Dc7d46E…. A signer with code makes those actions revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ordered recoveries handed to another contract; executors are set by functions. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- txs.json: the recovered signer is 0x588a5a0e… (nonce 0); factory getSigners() = [0x588A5A0e…] at block 26438999
- factory decompile: setThreshold and signer-list writers (0x036ded0f, 0x5ee7faae) require msg.sender == owner
- factory owner 0xacb4e10f… is an EOA (nonce 1, no code); the clone's operator 0xdA9A567C… (nonce 24) and owner 0x7C2A515A… (nonce 17) are live

## Impact and exposure

- Value held at block 26,438,999: $12,812 (ETH and 49 priced tokens, over 81 addresses).
- Activity: 1,266 transactions called it in the 90 days before that block; last on 2026-11-18.
- 20 signature recoveries in the study's two-week trace window.

## Remediation

The factory owner replaces the signer in the factory's signer set.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
