---
id: bitcoinsafeowner-f6e3a492-signer-upgrade-only
title: "BitcoinSafeOwner: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf6e3a4924de5008137e0f1711edcfa64606bbca8"
  family: "fc6b4d11c75bde53ae36d2d477b0b395"
  copies: 2176
  name: "BitcoinSafeOwner"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 40
  last_active: 2026-11-14
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x8873b07428f621e543ff4577e812ee7bda43a4d5 with UPGRADE_SINGLETON_TYPEHASH(), called through its own checks)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`BitcoinSafeOwner` at `0xf6e3a4924de5008137e0f1711edcfa64606bbca8`, with 2,175 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Bitcoin Safe owner (uncompressed P2PKH): the signature must recover to the Ethereum address of the Bitcoin public key that hashes to the stored Bitcoin address / Bitcoin Safe owner (compressed…. Read from source.
- Update path, read at block 26,438,999: proxy to 0x8873b07428f621e543ff4577e812ee7bda43a4d5 with UPGRADE_SINGLETON_TYPEHASH(), called through its own checks.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2,176 addresses).
- Activity: 40 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
