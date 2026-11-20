---
id: vault-786d78b3-signer-upgrade-only
title: "Vault: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x786d78b35d5e35bbd7fa750272537dfff15eb4fe"
  family: "5cf12370be5316bf9cfd6b21ea225cd7"
  copies: 114
  name: "Vault"
  upgradeable: "yes"
  admin: "0xe738003b9596487e07d63daae04db8aa77380f77"
  rating: LOW
  value_usd: 1857
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xf45e0fd68b440eb8574504379bff3db67e53db37 with upgradeTo(address), owner 0xe738003b9596487e07d63daae04db8aa77380f77)"
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

`Vault` at `0x786d78b35d5e35bbd7fa750272537dfff15eb4fe`, with 113 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read).
- Update path, read at block 26,438,999: proxy to 0xf45e0fd68b440eb8574504379bff3db67e53db37 with upgradeTo(address), owner 0xe738003b9596487e07d63daae04db8aa77380f77.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $1,857 (ETH and 49 priced tokens, over 114 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
