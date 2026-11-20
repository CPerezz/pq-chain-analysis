---
id: paymentplanv2logic-e803684b-signer-upgrade-only
title: "PaymentPlanV2Logic: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0"
  family: "fc7c0b127371423b27634fc8c0200623"
  name: "PaymentPlanV2Logic"
  label: "deployed by Cyan: Deployer"
  upgradeable: "yes"
  admin: "0x891222addfaf54ab043152e651d7908433941374"
  rating: LOW
  value_usd: 3714
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 164
  last_active: 2026-11-16
  recoveries_14d: 15
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x4302e933916c5acb7c6b61acb961a9721295511b, admin 0x891222addfaf54ab043152e651d7908433941374)"
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

`PaymentPlanV2Logic` at `0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0` (Etherscan tag: deployed by Cyan: Deployer). It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Cyan payment plan: signed by the signer its caller passes, the platform's / Cyan plan revival: signed by the platform signer / Cyan early unwind (OpenSea): signed by the platform signer / Cyan early…. Read from source.
- Update path, read at block 26,438,999: proxy to 0x4302e933916c5acb7c6b61acb961a9721295511b, admin 0x891222addfaf54ab043152e651d7908433941374.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $3,714 (ETH and 49 priced tokens).
- Activity: 164 transactions called it in the 90 days before that block; last on 2026-11-16.
- 15 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
