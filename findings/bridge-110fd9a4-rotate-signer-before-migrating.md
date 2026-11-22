---
id: bridge-110fd9a4-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x110fd9a44a056cb418d07f7d9957d0303f0020e4"
  family: "5919cd325324410c2e2cc801a26e9bce"
  name: "Bridge"
  upgradeable: "no"
  rating: LOW
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-08-22
fix:
  layer: onchain-config
  who_acts: "owner 0x0e17c1a78d2a77298df58e5956b33376a1b9f4c2"
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
  note: "The owner force path is held by a live EOA: LOW."
---

## Summary

The Root Network bridge needs threshold signatures, each recovered to the validator at that index. Validators with code stop counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Root Network bridge: each given signature must come from the validator at that place; a threshold of them; the validator set is changed by a signed message or forced by the owner. Read from source.
- Bridge.sol:176 _validators[i] == digest.recover; :244 forceActiveValidatorSet onlyOwner (also setThreshold onlyOwner)
- owner()=0x0e17…f4c2: EOA, nonce 237 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,827 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-22.

## Remediation

The owner forces a new active validator set of EOA keys, or the set rotates through a signed message.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
