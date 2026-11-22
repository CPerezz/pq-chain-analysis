---
id: crabstrategyv2-3b960e47-entry-by-own-signature-only
title: "CrabStrategyV2: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x3b960e47784150f5a63777201ee2b15253d713e8"
  family: "1f799d437d60efe00b9c1a60a7364df1"
  name: "CrabStrategyV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 136605
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 437
  last_active: 2026-11-17
fix:
  layer: account-migration
  who_acts: "the OTC counterparty (market maker)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The signature only lets a party take part in OTC trades; crab holders' funds sit behind direct withdraw paths. value_usd 136605, txs_90d 437."
---

## Summary

Opyn Crab strategy v2: OTC hedge/auction orders are signed by the trader (ECDSA only). A trader with real code can't sign orders.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Crab strategy OTC order: the trader named must have signed (ECDSA only). Read from source.
- CrabStrategyV2.sol:657 offerSigner = ECDSA.recover(...) (no ERC-1271)
- direct deposit()/withdraw(uint256) (l.370, l.383), flashDeposit/flashWithdraw (l.315, l.346) and withdrawShutdown (l.397) by msg.sender

## Impact and exposure

- Value held at block 26,438,999: $136,605 (ETH and 49 priced tokens).
- Activity: 437 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Market makers keep a 7702 delegation or use an EOA for OTC; holders exit via withdraw/flashWithdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
