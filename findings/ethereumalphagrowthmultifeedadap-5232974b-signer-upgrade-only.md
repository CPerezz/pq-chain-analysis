---
id: ethereumalphagrowthmultifeedadap-5232974b-signer-upgrade-only
title: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5232974bcd5a3ffe41478736bb8b0e760130c800"
  family: "d072ae45266149404a67e4ccb0f3dd29"
  name: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2"
  upgradeable: "yes"
  admin: "0x8223a6271d1e0bda019ee55d545d7b86eff1f573"
  rating: LOW
  txs_90d: 513
  last_active: 2026-11-18
  recoveries_14d: 276
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xf3b68c9f8ea997c60bf4f3a03b271c5ee02d985c, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573)"
evidence:
  level: executed
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

`EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2` at `0x5232974bcd5a3ffe41478736bb8b0e760130c800`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0xf3b68c9f8ea997c60bf4f3a03b271c5ee02d985c, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 513 transactions called it in the 90 days before that block; last on 2026-11-18.
- 276 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
