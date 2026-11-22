---
id: offchainaggtcd-d5d2b9e9-rotate-signer-before-migrating
title: "OffchainAggTCD: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd5d2b9e9bcd172d5fc8521afd2c98dd239f5b607"
  family: "3412ae42da01a77a0892b17b00a72c2a"
  name: "OffchainAggTCD"
  upgradeable: "no"
  rating: LOW
  value_usd: 12993
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "data-source owners and stakers"
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
  note: "LOW: the key is replaceable through permissionless registration and stake movement. Staked tokens leave via unstake/withdrawReceipts, not by signature."
---

## Summary

Band OffchainAggTCD: report() counts signatures from active data-source addresses and needs more than 2/3 of activeCount. A data-source key with code stops counting and can stall reports.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Band off-chain aggregator: signatures in ascending order; those of active providers are counted; providers enter and leave the active list by stake. Read from source.
- OffchainAggTCD.sol:1689-1712: ecrecover per signature, counted when activeList[recovered] is set
- register (line 1443) is public: anyone with min_provider_stake registers a new data-source address
- stake/unstake (lines 1460, 1473) let the provider owner and stakers move stake, which reorders the active list

## Impact and exposure

- Value held at block 26,438,999: $12,993 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The provider owner unstakes and registers a fresh data-source key (or stakers move stake to another provider).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
