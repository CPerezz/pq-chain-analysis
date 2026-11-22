---
id: upstreamcollectivetoken-31f81798-rotate-signer-before-migrating
title: "UpstreamCollectiveToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x31f8179866f10b87f08a956c14c5a377c83efb1a"
  family: "524c172f14a70643c7c92ba0d0aaaf40"
  copies: 27
  name: "UpstreamCollectiveToken"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-09
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`UpstreamCollectiveToken` at `0x31f8179866f10b87f08a956c14c5a377c83efb1a`, with 26 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- Reviewed through the root issue's mechanism: the reading for this address names a function that replaces the checked key (a setter, a role grant or an owner hand-over), so its holder can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $2,707 (ETH and 49 priced tokens, over 27 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
