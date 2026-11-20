---
id: leftoverexchanger-b01f8f52-signer-upgrade-only
title: "LeftoverExchanger: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb01f8f528702d411d24c9bb8cc0e2fff779ec013"
  family: "10aaa29e460cafdb7d9a01c516f3f076"
  name: "LeftoverExchanger"
  label: "deployed by 1inch: Deployer 5"
  upgradeable: "yes"
  admin: "0x6439568614000c5ffdcecd717b094082adc86948"
  rating: LOW
  value_usd: 4018
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xe9f1420bf4ff6a1db45baf974c84d81bea781b58, admin 0x6439568614000c5ffdcecd717b094082adc86948)"
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

`LeftoverExchanger` at `0xb01f8f528702d411d24c9bb8cc0e2fff779ec013` (Etherscan tag: deployed by 1inch: Deployer 5). It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: 1inch LeftoverExchanger ERC-1271: the signer must be _OWNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: proxy to 0xe9f1420bf4ff6a1db45baf974c84d81bea781b58, admin 0x6439568614000c5ffdcecd717b094082adc86948.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $4,018 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
