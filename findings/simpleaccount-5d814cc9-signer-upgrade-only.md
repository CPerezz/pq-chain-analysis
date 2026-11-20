---
id: simpleaccount-5d814cc9-signer-upgrade-only
title: "SimpleAccount: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d814cc9e94b2656f59ee439d44aa1b6ca21434f"
  family: "4a7de92bd7a0be5dcffa67664003eeca"
  copies: 2
  name: "SimpleAccount"
  upgradeable: "yes"
  admin: "0xb1077b7c62844efba104d767127a5db6c0f5a0cc"
  rating: LOW
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xf5d0c65516f0724242343c4eaa5d9de3ee4291fb with upgradeTo(address), owner 0xb1077b7c62844efba104d767127a5db6c0f5a0cc)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`SimpleAccount` at `0x5d814cc9e94b2656f59ee439d44aa1b6ca21434f`, with 1 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount _validateSignature: the stored owner or the controller signs. Read (function text).
- Update path, read at block 26,438,999: proxy to 0xf5d0c65516f0724242343c4eaa5d9de3ee4291fb with upgradeTo(address), owner 0xb1077b7c62844efba104d767127a5db6c0f5a0cc.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
