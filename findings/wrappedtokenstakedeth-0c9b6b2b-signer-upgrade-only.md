---
id: wrappedtokenstakedeth-0c9b6b2b-signer-upgrade-only
title: "WrappedTokenStakedETH: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0c9b6b2b9345841f6210f6045ee2508d68ee1ac6"
  family: "69c13af3a68d8433ac982b75f9693b50"
  name: "WrappedTokenStakedETH"
  upgradeable: "yes"
  admin: "0x0e4e519691021d930072ff13c503a50626e31a8e"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xac78ebe8b1770f1a5a0d9eaad88a33150b05846b with upgradeTo(address), owner 0x0e4e519691021d930072ff13c503a50626e31a8e)"
evidence:
  level: bytecode
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

`WrappedTokenStakedETH` at `0x0c9b6b2b9345841f6210f6045ee2508d68ee1ac6`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xac78ebe8b1770f1a5a0d9eaad88a33150b05846b with upgradeTo(address), owner 0x0e4e519691021d930072ff13c503a50626e31a8e.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
